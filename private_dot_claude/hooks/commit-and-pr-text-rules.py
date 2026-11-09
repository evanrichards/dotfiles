#!/usr/bin/env python3
"""Block commit messages and GitHub text that break Evan's writing rules.

The hook checks `git commit` and `gh pr|issue create|edit|comment` commands. It
reads the message from the command line and from any message file that the
command names (`-F`, `--file`, `--body-file`).

It blocks:
- Claude attribution: a Claude co-author trailer, "Generated with Claude Code",
  or a Claude Code session link or trailer.
- An em dash, or an en dash with a space on each side.
- The words "substrate" and "honest", unless Evan used the word in a prompt in
  this session.
"""
import json
import re
import shlex
import sys

TARGET_RE = re.compile(
    r"\bgit\s+commit\b|\bgh\s+(?:pr|issue)\s+(?:create|edit|comment)\b"
)
FILE_FLAGS = {"-F", "--file", "--body-file"}
ATTRIBUTION_RES = [
    re.compile(r"co-authored-by:\s*claude", re.I),
    re.compile(r"generated with \[?claude code", re.I),
    re.compile(r"claude\.ai/code/session", re.I),
    re.compile(r"^\s*claude-session:", re.I | re.M),
]
DASH_RE = re.compile(r"—| – ")
BANNED_WORDS = ["substrate", "honest"]


def message_files(command):
    try:
        tokens = shlex.split(command, posix=True)
    except ValueError:
        tokens = command.split()
    paths = []
    for i, token in enumerate(tokens):
        if token in FILE_FLAGS and i + 1 < len(tokens):
            paths.append(tokens[i + 1])
        for flag in ("--file=", "--body-file="):
            if token.startswith(flag):
                paths.append(token[len(flag):])
    return paths


def read_text(path, cwd):
    if path == "-":
        return ""
    full = path if path.startswith("/") else f"{cwd}/{path}"
    try:
        with open(full, encoding="utf-8") as f:
            return f.read()
    except OSError:
        return ""


def user_prompts(transcript_path):
    text = []
    if not transcript_path:
        return ""
    try:
        with open(transcript_path, encoding="utf-8") as f:
            for line in f:
                if '"type":"user"' not in line and '"type": "user"' not in line:
                    continue
                try:
                    entry = json.loads(line)
                except ValueError:
                    continue
                content = (entry.get("message") or {}).get("content")
                if isinstance(content, str):
                    text.append(content)
                elif isinstance(content, list):
                    for block in content:
                        if isinstance(block, dict) and block.get("type") == "text":
                            text.append(block.get("text", ""))
    except OSError:
        pass
    return "\n".join(text).lower()


def main():
    data = json.load(sys.stdin)
    if data.get("tool_name") != "Bash":
        return 0
    command = (data.get("tool_input") or {}).get("command", "")
    if not TARGET_RE.search(command):
        return 0
    cwd = data.get("cwd") or "."
    text = command + "\n" + "\n".join(
        read_text(p, cwd) for p in message_files(command)
    )

    problems = []
    if any(r.search(text) for r in ATTRIBUTION_RES):
        problems.append(
            "Remove the Claude attribution (co-author trailer, "
            "\"Generated with Claude Code\", or session link). "
            "Evan does not want it in any commit, PR, or comment."
        )
    if DASH_RE.search(text):
        problems.append(
            "Replace each em dash (and each spaced en dash) with a comma, "
            "colon, semicolon, parentheses, or a new sentence."
        )
    found = [w for w in BANNED_WORDS if re.search(rf"\b{w}", text, re.I)]
    if found:
        prompts = user_prompts(data.get("transcript_path"))
        found = [w for w in found if w not in prompts]
    if found:
        problems.append(
            "Rewrite the sentences that use "
            + ", ".join(f'"{w}"' for w in found)
            + ". Evan does not use these words."
        )

    if not problems:
        return 0
    print(
        "Blocked: the commit or GitHub text breaks Evan's writing rules.\n- "
        + "\n- ".join(problems)
        + "\nFix the message (or the message file) and run the command again.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
