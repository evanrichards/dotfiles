#!/usr/bin/env python3
"""Block a plain PR whose base is the branch of another PR.

A PR from `gh pr create --base <feature-branch>` is not in a GitHub native
stack. When someone merges it, GitHub merges it into that feature branch, not
into main. The merge queue and the server restack also do not see it. Make
stacked PRs with `gh stack add` + `gh stack submit`, or with `gh stack link`
when the local stack state is not usable.

Blocked:
- `gh pr create`, `gh pr new` and `gh pr edit` with a `--base`/`-B` value
  other than main or master.
- `gh api` calls on a `pulls` path that set a `base` field other than main or
  master.
"""
import json
import os
import re
import shlex
import sys

TRUNKS = {"main", "master"}
SEPARATORS = {";", "&&", "||", "|", "&", "\n", "(", ")"}
PR_SUBCOMMANDS = {"create", "new", "edit"}
API_FIELD_FLAGS = {"-f", "-F", "--field", "--raw-field"}
WRAPPERS = {"command", "env", "exec", "nohup", "time"}
ASSIGNMENT = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*=")


def split_segments(command):
    """Return the command as a list of token lists, one list for each simple command.

    The lexer keeps newlines out of the whitespace set, so that an unquoted
    newline separates two commands. A newline inside quotes stays in the token.
    """
    lexer = shlex.shlex(command, posix=True, punctuation_chars=";&|()\n")
    lexer.whitespace = " \t\r"
    lexer.whitespace_split = True
    segments = [[]]
    for token in lexer:
        if token in SEPARATORS or set(token) <= set(";&|()\n"):
            segments.append([])
        else:
            segments[-1].append(token)
    return [s for s in segments if s]


def gh_args(tokens):
    """Return the arguments after `gh` when `gh` is the program of the command, else None.

    Variable assignments and wrapper programs can come before `gh`. A `gh`
    token in another position is an argument, for example of `echo`.
    """
    i = 0
    while i < len(tokens) and (ASSIGNMENT.match(tokens[i]) or tokens[i] in WRAPPERS):
        i += 1
    if i < len(tokens) and os.path.basename(tokens[i]) == "gh":
        return tokens[i + 1 :]
    return None


def pr_base_values(tokens):
    """Return the `--base` values of a `gh pr create|new|edit` command."""
    rest = gh_args(tokens)
    if rest is None or len(rest) < 2 or rest[0] != "pr" or rest[1] not in PR_SUBCOMMANDS:
        return []
    values = []
    args = rest[2:]
    for j, arg in enumerate(args):
        if arg in ("--base", "-B") and j + 1 < len(args):
            values.append(args[j + 1])
        elif arg.startswith("--base="):
            values.append(arg[len("--base=") :])
        elif arg.startswith("-B") and len(arg) > 2 and not arg.startswith("--"):
            values.append(arg[2:])
    return values


def api_base_values(tokens):
    """Return the `base` field values of a `gh api` command on a `pulls` path."""
    rest = gh_args(tokens)
    if rest is None or not rest or rest[0] != "api":
        return []
    args = rest[1:]
    if not any(re.search(r"(^|/)pulls(/|$)", a) for a in args):
        return []
    fields = []
    for j, arg in enumerate(args):
        if arg in API_FIELD_FLAGS and j + 1 < len(args):
            fields.append(args[j + 1])
        elif "=" in arg and arg.split("=", 1)[0] in ("--field", "--raw-field"):
            fields.append(arg.split("=", 1)[1])
        elif arg[:2] in ("-f", "-F") and len(arg) > 2 and not arg.startswith("--"):
            fields.append(arg[2:])
    values = []
    for field in fields:
        key, sep, value = field.partition("=")
        if sep and key == "base":
            values.append(value)
    return values


def regex_base_values(command):
    """Find the base values with a regex when the shell lexer cannot parse the command.

    The lexer fails on a heredoc body with an odd count of quotes.
    """
    values = []
    for match in re.finditer(r"\bgh\s+pr\s+(?:create|new|edit)\b[^\n;&|]*", command):
        for base in re.finditer(
            r"(?:--base|-B)(?:=|\s+)(['\"]?)([^\s'\"]+)\1", match.group(0)
        ):
            values.append(base.group(2))
    return values


def offending_bases(command):
    try:
        segments = split_segments(command)
    except ValueError:
        return [v for v in regex_base_values(command) if v not in TRUNKS]
    values = []
    for tokens in segments:
        values.extend(pr_base_values(tokens))
        values.extend(api_base_values(tokens))
    return [v for v in values if v not in TRUNKS]


def main():
    data = json.load(sys.stdin)
    if data.get("tool_name") != "Bash":
        return 0
    command = data.get("tool_input", {}).get("command", "")
    if "gh" not in command:
        return 0
    bad = offending_bases(command)
    if not bad:
        return 0
    print(
        f"Refusing a PR whose base is `{bad[0]}`, not `main`.\n"
        "A plain PR on the branch of another PR is not in a GitHub native stack.\n"
        "GitHub merges it into that branch, not into main, and the merge queue\n"
        "and the server restack do not see it. Make the stacked PR with gh stack:\n"
        "  gh stack add -Am \"[S] msg\" evan/<name>   # on the top branch of the stack\n"
        "  gh stack submit --auto                   # push, open draft PRs, link the stack\n"
        "If the local gh stack state is not usable (a rebase from another worktree\n"
        "is open, or another worktree has the base branch checked out), link on\n"
        "GitHub only. This command pushes the branch, opens a draft PR with the\n"
        "correct base and adds it to the stack:\n"
        "  gh stack link <base-branch-or-pr> <your-branch>\n"
        "If `gh stack link` refuses (the base PR has auto-merge on), push the branch\n"
        "with no PR, tell Evan, and open the PR on main after the base merges.\n"
        "Do not work around this hook. If a plain PR on a non-main base is really\n"
        "necessary, ask Evan to run the command with `!`.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
