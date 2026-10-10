#!/usr/bin/env python3
"""Block raw `git rebase/merge/pull` of main on a stacked branch.

Our repos are squash-merge-only with a merge queue: the base PR lands as a new
squashed commit, so a raw `git rebase main` on a stacked child replays the
child's copy of the base's commits on top of the already-squashed base ->
"same lines changed twice" conflicts. git-spice avoids this via
`git rebase --onto main <oldbase> <branch>`. Use `gs repo sync` + `gs stack
restack` instead.

Allowed escape hatches: `git rebase --onto ...` (the correct low-level form),
mid-rebase control (`--continue/--abort/--skip`), and any rebase while ON main
(updating the trunk itself is fine).
"""
import json
import re
import subprocess
import sys

data = json.load(sys.stdin)
if data.get("tool_name") != "Bash":
    sys.exit(0)

command = data.get("tool_input", {}).get("command", "")

# Inspect each shell-separated sub-command independently.
segments = re.split(r"&&|\|\||;|\|", command)

MAIN_REF = re.compile(r"\b(?:origin/|upstream/)?(?:main|master)\b")
SAFE_REBASE = re.compile(r"--(?:continue|abort|skip|onto)\b")


def offending_segment():
    for seg in segments:
        s = seg.strip()
        if not MAIN_REF.search(s):
            continue
        if re.search(r"\bgit\s+rebase\b", s) and not SAFE_REBASE.search(s):
            return ("rebase", s)
        if re.search(r"\bgit\s+merge\b", s):
            return ("merge", s)
        if re.search(r"\bgit\s+pull\b", s):
            return ("pull", s)
    return None


def current_branch():
    try:
        out = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True,
            text=True,
            timeout=5,
        )
        return out.stdout.strip()
    except Exception:
        return ""


hit = offending_segment()
if hit is None:
    sys.exit(0)

branch = current_branch()
# On the trunk itself (or unknown repo state) updating main is legitimate.
if branch in ("main", "master", ""):
    sys.exit(0)

kind, _seg = hit
print(
    f"Refusing raw `git {kind} main` on stacked branch `{branch}`.\n"
    "Squash-merge + merge queue means this replays the base's commits onto the\n"
    "already-squashed base -> conflicts. Use git-spice instead:\n"
    "  gs repo sync   # detect merged PRs, drop their commits via --onto\n"
    "  gs stack restack\n"
    "Only restack a child AFTER its base PR has actually landed in the queue.\n"
    "If a manual rebase is truly required, use `git rebase --onto main <oldbase> "
    f"{branch}` (allowed).",
    file=sys.stderr,
)
sys.exit(2)
