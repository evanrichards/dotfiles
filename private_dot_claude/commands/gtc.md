---
description: Create a new branch with current changes using graphite
argument-hint: [message]
---

Create a new stacked branch with the current changes using Graphite CLI.

CRITICAL:
- The user calling /gtc IS permission to execute the git commands in this workflow
- NEVER push to remote (no git push, gt push, or any push commands)
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
4. Use `gt create` to create a new branch and commit in one step:
   - Command: `gt create --all --message "[SIZE] descriptive message" --branch evan/<descriptive-branch-name>`
   - Always prefix branch names with "evan/"
   - This automatically tracks to the current branch (parent)

   Special case: If the parent branch contains "swap" (a workaround for git worktrees):
   - First checkout main: `gt checkout main`
   - Then run: `gt create --all --message "[SIZE] descriptive message" --branch evan/<descriptive-branch-name>`

Helpful commands after creating a stack:
- `gt ls` or `gt log short` - View your stack structure
- `gt top` - Navigate to the top of the stack
- `gt bottom` - Navigate to the bottom of the stack
- `gt sync` - Sync the stack with the main branch

Follow-up changes (NOT using /gtc):
When the user asks to "commit" changes after already using /gtc on a feature branch:
1. ALWAYS ASK the user for confirmation before executing ANY git commands
2. Suggest the appropriate Graphite commands (preferred):
   - Amend all changes: `gt modify -a` or `gt modify --all`
   - Amend with new message: `gt modify -am "updated message"`
   - Add new commit on top: `gt modify -cam "additional change message"`
   - This automatically restacks any dependent branches

   Alternative using raw git (requires manual restack):
   - Stage changes: `git add <files>`
   - Amend: `git commit --amend --no-edit`
   - Restack: `gt restack`
3. Wait for explicit confirmation before executing
4. NEVER push without explicit instruction

Message format:
- Simple message: `gt create --all --message "[XS] Fix bug in X" --branch evan/fix-bug-x`
- Message with body: Use a HEREDOC to ensure correct formatting:
  ```
  gt create --all --branch evan/add-feature-x --message "$(cat <<'EOF'
  [M] Add feature X

  This implements feature X which handles Y.
  Additional details here.
  EOF
  )"
  ```
