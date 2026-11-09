#!/usr/bin/env python3
"""Stop hook: the work is not done until the PR for the current branch is green.

The hook acts only in a session that pushed. A Bash call in the transcript must
run `git push`, `gh stack submit`, `gh stack push`, or `gh pr create`.

For the open PR of the current branch, the hook blocks the stop when:
- local HEAD has commits that the PR does not have,
- the PR has merge conflicts,
- a check failed, or
- a check is still running.

The hook blocks at most once for each pair of head commit and state, so it does
not repeat itself while the agent waits on CI. It also blocks at most
MAX_BLOCKS_PER_SESSION times in one session. A "pending" block tells the agent
to start a background watch and end the turn. The watch wakes the agent when CI
finishes, and the next stop checks the PR again.
"""
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

PUSH_RE = re.compile(
    r"\bgit\s+push\b|\bgh\s+stack\s+(?:submit|push)\b|\bgh\s+pr\s+create\b"
)
FAILED_CONCLUSIONS = {
    "FAILURE",
    "TIMED_OUT",
    "CANCELLED",
    "STARTUP_FAILURE",
    "ACTION_REQUIRED",
}
FAILED_STATES = {"FAILURE", "ERROR"}
PENDING_STATES = {"PENDING", "EXPECTED"}
STATE_DIR = Path.home() / ".claude" / "state" / "ci-green-before-stop"
MAX_BLOCKS_PER_SESSION = 10
STATE_TTL_SECONDS = 7 * 24 * 3600


def run(args, cwd, timeout=20):
    try:
        out = subprocess.run(
            args, cwd=cwd, capture_output=True, text=True, timeout=timeout
        )
    except Exception:
        return None
    if out.returncode != 0:
        return None
    return out.stdout.strip()


def session_pushed(transcript_path):
    try:
        with open(transcript_path, encoding="utf-8") as f:
            for line in f:
                if '"tool_use"' not in line or not PUSH_RE.search(line):
                    continue
                try:
                    entry = json.loads(line)
                except ValueError:
                    continue
                content = (entry.get("message") or {}).get("content") or []
                for block in content:
                    if (
                        isinstance(block, dict)
                        and block.get("type") == "tool_use"
                        and block.get("name") == "Bash"
                        and PUSH_RE.search(
                            (block.get("input") or {}).get("command", "")
                        )
                    ):
                        return True
    except OSError:
        return False
    return False


def open_pr(cwd):
    raw = run(
        [
            "gh",
            "pr",
            "view",
            "--json",
            "number,state,url,headRefOid,mergeable,statusCheckRollup",
        ],
        cwd,
    )
    if raw is None:
        return None
    try:
        pr = json.loads(raw)
    except ValueError:
        return None
    if pr.get("state") != "OPEN":
        return None
    return pr


def local_head_not_on_pr(cwd, pr_head):
    head = run(["git", "rev-parse", "HEAD"], cwd, timeout=5)
    if head is None or head == pr_head:
        return None
    # The PR head can be ahead of local HEAD, for example when CI pushes an
    # auto-fix commit. Then local HEAD is an ancestor of the PR head, and
    # nothing is unpushed.
    try:
        ancestor = subprocess.run(
            ["git", "merge-base", "--is-ancestor", head, pr_head],
            cwd=cwd,
            capture_output=True,
            timeout=5,
        ).returncode == 0
    except Exception:
        return None
    return None if ancestor else head


def check_name(check):
    return check.get("name") or check.get("context") or "unnamed check"


def classify(pr, cwd):
    unpushed = local_head_not_on_pr(cwd, pr["headRefOid"])
    if unpushed is not None:
        return "unpushed", [unpushed[:12]]
    if pr.get("mergeable") == "CONFLICTING":
        return "conflict", []
    failed, pending = [], []
    for check in pr.get("statusCheckRollup") or []:
        if check.get("__typename") == "StatusContext":
            state = check.get("state")
            if state in FAILED_STATES:
                failed.append(check_name(check))
            elif state in PENDING_STATES:
                pending.append(check_name(check))
            continue
        if check.get("status") != "COMPLETED":
            pending.append(check_name(check))
        elif check.get("conclusion") in FAILED_CONCLUSIONS:
            failed.append(check_name(check))
    if failed:
        return "failing", failed
    if pending or not pr.get("statusCheckRollup"):
        return "pending", pending
    return "green", []


def short_list(names, limit=6):
    names = sorted(set(names))
    shown = ", ".join(names[:limit])
    if len(names) > limit:
        shown += f" (and {len(names) - limit} more)"
    return shown


def message(pr, state, names):
    n, url = pr["number"], pr["url"]
    lines = ["[Automated stop hook, not a human message]", ""]
    if state == "unpushed":
        lines += [
            f"Local HEAD {names[0]} has commits that PR #{n} ({url}) does not have.",
            "Push them (`gh stack submit --auto` for a stack, else `git push`).",
            "Then wait for CI as the next stop of this hook tells you.",
        ]
    elif state == "conflict":
        lines += [
            f"PR #{n} ({url}) has merge conflicts with its base.",
            "The work is not done until the PR can merge.",
            "Run /fix-ci to resolve the conflicts, then push.",
        ]
    elif state == "failing":
        lines += [
            f"PR #{n} ({url}) has failed checks: {short_list(names)}.",
            "The work is not done until CI is green. Run /fix-ci.",
            "If a failure is outside this change and you cannot fix it, tell Evan",
            "the check name and the cause in one or two lines, then stop.",
        ]
    else:
        waiting = short_list(names) if names else "no checks reported yet"
        lines += [
            f"CI is still running on PR #{n} ({url}). Waiting on: {waiting}.",
            f"Run `gh pr checks {n} --watch --fail-fast` with run_in_background,",
            "then end your turn. The watch wakes you when CI finishes.",
            "Then fix any failure with /fix-ci.",
            "If a background watch for this PR already runs, end your turn now.",
        ]
    return "\n".join(lines)


def load_state(path):
    try:
        return json.loads(path.read_text())
    except (OSError, ValueError):
        return {"keys": [], "blocks": 0}


def prune_old_state():
    now = time.time()
    try:
        for f in STATE_DIR.iterdir():
            if now - f.stat().st_mtime > STATE_TTL_SECONDS:
                f.unlink()
    except OSError:
        pass


def main():
    data = json.load(sys.stdin)
    transcript = data.get("transcript_path")
    cwd = data.get("cwd") or os.getcwd()
    session = data.get("session_id") or "unknown"
    if not transcript or not session_pushed(transcript):
        return

    pr = open_pr(cwd)
    if pr is None:
        return
    state, names = classify(pr, cwd)
    if state == "green":
        return

    STATE_DIR.mkdir(parents=True, exist_ok=True)
    prune_old_state()
    state_path = STATE_DIR / f"{session}.json"
    seen = load_state(state_path)
    key = f"{pr['number']}:{pr['headRefOid']}:{state}"
    if key in seen["keys"] or seen["blocks"] >= MAX_BLOCKS_PER_SESSION:
        return
    seen["keys"].append(key)
    seen["blocks"] += 1
    state_path.write_text(json.dumps(seen))

    print(json.dumps({"decision": "block", "reason": message(pr, state, names)}))


if __name__ == "__main__":
    main()
