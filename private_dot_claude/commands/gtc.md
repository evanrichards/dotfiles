---
description: Create a new branch with current changes using graphite
argument-hint: [message]
---

Create a new stacked branch with the current changes using Graphite CLI.

IMPORTANT: This command is ONLY for creating NEW branches in the stack. For follow-up changes to an existing feature branch, use the amend workflow instead (see below).

Stacking workflow principles:
- We use Graphite CLI for stacked diffs (branches stacked on branches)
- ONE COMMIT PER BRANCH - each branch is an atomic changeset
- Each new feature/change gets its own branch stacked on the current branch
- Commit messages MUST be prefixed with a t-shirt size in brackets: [XS], [S], [M], [L], [XL]
- The t-shirt size represents the COGNITIVE LOAD for reviewing, NOT just lines changed
  - Example: A 5-line change in a critical path might be [M]
  - Example: A 1500-line rename refactor could be [XS] if simple to review
- Do NOT include "Generated with Claude Code" attribution
- Do NOT include Claude as co-author

Workflow steps for creating a new stacked branch:
1. Note the current branch name (this will be the parent branch)
2. Review the current changes (git status, git diff)
3. If no message is provided via $ARGUMENTS, analyze the changes and suggest an appropriate commit message with the correct t-shirt size prefix
4. Create a new branch with `git checkout -b <descriptive-branch-name>`
5. Stage and commit the changes using `git add` and `git commit -m "{message}"`
6. Use `gt track` to track the new branch to the parent:
   - If the parent branch contains "swap" (a workaround for git worktrees), track to `main` instead
   - Otherwise, track to the noted parent branch
   - Command: `gt track --parent <parent-branch>`

Follow-up changes (NOT using /gtc):
When the user asks to "commit" changes after already using /gtc on a feature branch:
1. ASK the user before committing (confirm they want to amend)
2. Stage changes: `git add <files>`
3. Amend using `gt modify -a` (or `gt modify -am "updated message"` if changing commit message)
4. This automatically restacks any dependent branches
5. Alternative: `git commit --amend --no-edit` then `gt restack`

Message format:
- For a simple commit: `git commit -m "[XS] Fix bug in X"`
- For a commit with body: Use a HEREDOC to ensure correct formatting:
  ```
  git commit -m "$(cat <<'EOF'
  [M] Add feature X

  This implements feature X which handles Y.
  Additional details here.
  EOF
  )"
  ```
