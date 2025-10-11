---
description: Create a new branch with current changes using graphite
argument-hint: [message]
---

Create a new branch with the current changes using graphite CLI.

Important workflow details:
- We use Graphite CLI for git workflow
- You are NEVER committing TO the current branch - you always create a new branch
- Commit messages MUST be prefixed with a t-shirt size in brackets: [XS], [S], [M], [L], [XL]
- The t-shirt size represents the COGNITIVE LOAD for reviewing, NOT just lines changed
  - Example: A 5-line change in a critical path might be [M]
  - Example: A 1500-line rename refactor could be [XS] if simple to review
- Do NOT include "Generated with Claude Code" attribution
- Do NOT include Claude as co-author

Workflow steps:
1. Note the current branch name (this will be the parent branch)
2. Review the current changes (git status, git diff)
3. If no message is provided via $ARGUMENTS, analyze the changes and suggest an appropriate commit message with the correct t-shirt size prefix
4. Create a new branch with `git checkout -b <branch-name>`
5. Stage and commit the changes using `git add` and `git commit -m "{message}"`
6. Use `gt track` to track the new branch to the parent:
   - If the parent branch contains "swap" (a workaround for git worktrees), track to `main` instead
   - Otherwise, track to the noted parent branch
   - Command: `gt track --parent <parent-branch>`

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
