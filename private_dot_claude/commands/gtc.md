---
description: Create a new branch with current changes as a GitHub stacked PR branch (gh stack)
argument-hint: [message]
---

Create a new stacked branch with the current changes using GitHub native stacks (`gh stack`).

CRITICAL:
- The user calling /gtc IS permission to execute the git commands in this workflow
- NEVER push to remote unless the user asks. These commands push: `git push`, `gh stack submit`, `gh stack push`, `gh stack sync`, `gh stack link`, `gh stack merge`. Use `gh stack rebase` for a local-only restack.
- ANY git actions after /gtc completes require explicit user confirmation
- NEVER commit implementation docs - these are for local use only and should not be included in commits

IMPORTANT: This command is ONLY for creating NEW branches in the stack. For follow-up changes to an existing feature branch, use the amend workflow instead (see below).

Stacking Philosophy:
- Break large changes into small, self-contained PRs that can be tested, reviewed, and merged independently
- Benefits: Faster code review, reduced merge conflicts, unblocked development, better collaboration
- Each diff should represent a single, coherent change
- The unit of change is an individual commit, not a multi-commit PR

When to create a NEW stacked branch (/gtc):
- You're starting a logically distinct piece of work that builds on the current branch
- You've finished one reviewable chunk and want to start the next dependent change
- You want to keep working without being blocked by PR reviews

Common stacking patterns:
1. By functional components: Database layer → Backend service → Frontend UI
2. Iterative improvements: Create PR as soon as you have something reviewable, then keep building
3. Refactor/change pattern: Refactor first (PR 1), then add feature/fix on top (PR 2)

Stacking workflow principles:
- We use GitHub native stacked PRs through the `gh stack` CLI extension. Local stack state lives in `.git/gh-stack` and is shared by every worktree of the repo.
- A native stack is LINEAR: one branch on top of another. There is no fan-out. Two independent changes on the same base are two stacks.
- ONE COMMIT PER BRANCH - each branch is an atomic changeset
- Commit messages MUST be prefixed with a t-shirt size in brackets: [XS], [S], [M], [L], [XL]
- The t-shirt size represents the COGNITIVE LOAD for reviewing, NOT just lines changed
  - Example: A 5-line change in a critical path might be [M]
  - Example: A 1500-line rename refactor could be [XS] if simple to review
- Do NOT include "Generated with Claude Code" attribution
- Do NOT include Claude as co-author

Workflow steps for creating a new stacked branch:
1. Note the current branch name and run `gh stack view --short`. This tells you if the current branch is already in a stack.
2. Review the current changes (git status, git diff)
3. If no message is provided via $ARGUMENTS, analyze the changes and suggest an appropriate commit message with the correct t-shirt size prefix
4. Create the branch and the commit:
   - Always prefix branch names with `evan/` (e.g., `evan/fix-bug-x`)
   - **On `main`, or on a branch that is not in a stack (a new stack):**
     ```
     git switch -c evan/<name> --no-track
     git add -A && git commit -m "[SIZE] message"
     gh stack init evan/<name>
     ```
     `gh stack init` adopts the existing branch as the bottom of a new stack on `main`.
   - **In a fresh worktree** (the branch is `worktree-<name>` or `claude/<name>`): rename it first with `git branch -m evan/<name>`, then `git branch --unset-upstream` (a branch created from `origin/main` tracks main), commit, and run `gh stack init evan/<name>`.
   - **On the top branch of an existing stack (stack one more on top):**
     ```
     gh stack add -Am "[SIZE] message" evan/<name>
     ```
     `-A` stages untracked files too. If the current branch is in a stack but is not the top, stop and ask: `gh stack add` always adds on top, and an insert in the middle needs the interactive `gh stack modify`.

Helpful commands:
- `gh stack view` (`--short`, `--json`) - View the stack and PR status
- `gh stack up` / `gh stack down` / `gh stack top` / `gh stack bottom` / `gh stack trunk` - Navigate
- `gh stack rebase` - Local cascade rebase of the stack onto its parents (`--upstack`, `--downstack`, `--no-trunk`, `--continue`, `--abort`)
- `gh stack sync` - Fetch, fast-forward trunk, cascade rebase, PUSH, and relink the stack on GitHub. Add `--prune` to delete local branches of merged PRs.
- `gh stack modify` - Interactive TUI to reorder, insert, fold, drop, or rename branches. A human must drive it.
- `gh stack checkout <stack#|pr#|branch>` - Check out an existing stack

Follow-up changes (NOT using /gtc):
When the user asks to "commit" changes after already using /gtc on a feature branch:
1. ALWAYS ASK the user for confirmation before executing ANY git commands
2. Suggest the appropriate commands:
   - Amend all changes (keep message): `git commit -a --amend --no-edit`
   - Amend with new message: `git commit -a --amend -m "updated message"`
   - Add new commit on top: `git commit -am "additional change"`
   - Then restack the branches above: `gh stack rebase --upstack --no-trunk`. gh stack does NOT restack automatically after a commit.
   - Check `git diff --cached --stat` before an amend on a lower branch. The index can hold work that belongs to a branch higher in the stack.
3. Wait for explicit confirmation before executing
4. NEVER push/submit without explicit instruction

Message format:
- Simple message: `gh stack add -Am "[XS] Fix bug in X" evan/fix-bug-x`
- Message with body: Use a HEREDOC to ensure correct formatting:
  ```
  gh stack add -A evan/add-feature-x -m "$(cat <<'EOF'
  [M] Add feature X

  This implements feature X which handles Y.
  Additional details here.
  EOF
  )"
  ```

Commit message content:
- The code shows the "what" - the commit message should capture the "why" and key decisions
- Include salient tradeoffs and choices made during implementation that aren't obvious from the diff
- A future reader should understand why this approach was chosen over alternatives
- Be terse but complete - focus on decisions a human reviewer needs to understand
- Skip obvious choices; document non-obvious ones (e.g., "Used X instead of Y because Z")

Submitting PRs (only when the user asks for it):
- Run `gh stack submit --auto`. It pushes every branch, creates the missing PRs as DRAFTS, sets each base, and creates or updates the stack object on GitHub. Pass `--open` only when the user asks for ready-for-review PRs (it also un-drafts existing PRs).
- `--auto` makes its own titles and adds a "Stack created with GitHub Stacks CLI" footer. Then set each new PR's title and body: `gh pr edit <branch> --title "..." --body-file <file>`.
- A single branch (a stack of one) gets no stack object on GitHub. That is fine; `gh stack submit` links it when a second branch arrives.
- To push changes to branches that already have PRs, use `gh stack push` (per-branch `--force-with-lease`). It skips merged and queued branches.
- ALWAYS verify each PR after you create or edit it. Run `gh pr view <number> --json title,body,baseRefName,commits,files` and compare each field with what you intended:
  - The title must match the intended commit subject.
  - The body must be the full intended body, not the commit message and not a truncated one.
  - The base must be the branch below it (or `main` for the bottom PR), and the commits and files must be only this branch's change.
- If a field is wrong, fix it with `gh pr edit` and run `gh pr view` again. Do not report the PR as done until the check passes.

After a PR in the stack merges:
- GitHub rebases the PRs above it on the server and retargets the next one to `main`. Do NOT rebase them locally while the base is still in the merge queue.
- After the merge lands, run `gh stack sync --prune` to bring the local branches up to date. If it reports a conflict that replays the merged PR's own commits, abort (`gh stack rebase --abort`) and do the rebase by hand with `git rebase --onto origin/main <merged-PR-head-sha> <branch>`. Get the SHA from `gh pr view <merged-pr> --json headRefOid`. (gh-stack issue #512.)
- Merging: `gh stack merge <pr#>` merges that PR and every unmerged PR below it, all or nothing, through the merge queue. You cannot merge a PR in the middle of a stack by itself.
