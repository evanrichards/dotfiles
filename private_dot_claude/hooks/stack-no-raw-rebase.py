#!/usr/bin/env python3
"""Block raw `git rebase/merge/pull` of main on a stacked branch.

Our repos are squash-merge-only with a merge queue. The base PR lands as a new
squashed commit, so a raw `git rebase main` on a stacked child replays the
child's copy of the base's commits on top of the squashed base. The result is
"same lines changed twice" conflicts. GitHub native stacks rebase the children
on the server after the base merges. Locally, use `gh stack sync` or
`gh stack rebase`, or the explicit `git rebase --onto main <oldbase> <branch>`.

Allowed: `git rebase --onto ...`, mid-rebase control (`--continue/--abort/
--skip`), any rebase while ON main, and the read-only `git merge-base` and
`git merge-tree`.
"""
import json
import re
import subprocess
import sys

data = json.load(sys.stdin)
if data.get("tool_name") != "Bash":
    sys.exit(0)

command = data.get("tool_input", {}).get("command", "")

segments = re.split(r"&&|\|\||;|\|", command)

MAIN_REF = re.compile(r"\b(?:origin/|upstream/)?(?:main|master)\b")
SAFE_REBASE = re.compile(r"--(?:continue|abort|skip|onto)\b")
# `(?![-\w])` keeps `git merge-base` and `git merge-tree` out of the match.
GIT_MERGE = re.compile(r"\bgit\s+merge(?![-\w])")


def offending_segment():
    for seg in segments:
        s = seg.strip()
        if not MAIN_REF.search(s):
            continue
        if re.search(r"\bgit\s+rebase\b", s) and not SAFE_REBASE.search(s):
            return ("rebase", s)
        if GIT_MERGE.search(s):
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
if branch in ("main", "master", ""):
    sys.exit(0)

kind, _seg = hit
print(
    f"Refusing raw `git {kind} main` on branch `{branch}`.\n"
    "Squash-merge + merge queue means this replays the base's commits onto the\n"
    "already-squashed base -> conflicts. Use the stack tooling instead:\n"
    "  gh stack rebase          # local cascade rebase (no push)\n"
    "  gh stack sync --prune    # after a base PR merged: fetch, rebase, PUSH\n"
    "Do not restack a child while its base PR is still in the merge queue;\n"
    "GitHub rebases the children on the server after the base merges.\n"
    "If a manual rebase is truly required, use `git rebase --onto origin/main "
    f"<oldbase-head-sha> {branch}` (allowed).",
    file=sys.stderr,
)
sys.exit(2)
