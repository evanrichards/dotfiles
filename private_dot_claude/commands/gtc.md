---
description: Create a new branch with current changes using git-spice
argument-hint: [message]
---

Create a new stacked branch with the current changes using git-spice (`gs`).

CRITICAL:
- The user calling /gtc IS permission to execute the git commands in this workflow
- NEVER push to remote (no git push, gs branch submit, or any push/submit commands)
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
- We use git-spice (`gs`) for stacked diffs (branches stacked on branches)
- ONE COMMIT PER BRANCH - each branch is an atomic changeset
- Each new feature/change gets its own branch stacked on the current branch
- Commit messages MUST be prefixed with a t-shirt size in brackets: [XS], [S], [M], [L], [XL]
- The t-shirt size represents the COGNITIVE LOAD for reviewing, NOT just lines changed
  - Example: A 5-line change in a critical path might be [M]
  - Example: A 1500-line rename refactor could be [XS] if simple to review
- Do NOT include "Generated with Claude Code" attribution
- Do NOT include Claude as co-author

Workflow steps for creating a new stacked branch:
1. Note the current branch name (this will be the parent/base branch)
2. Review the current changes (git status, git diff)
3. If no message is provided via $ARGUMENTS, analyze the changes and suggest an appropriate commit message with the correct t-shirt size prefix
4. Use `gs branch create` (shorthand: `gs bc`) to create a new branch and commit in one step:
   - Command: `gs bc <descriptive-branch-name> --all --message "[SIZE] descriptive message"`
   - The branch name is a positional argument (first argument after `gs bc`)
   - Always prefix branch names with `evan/` (e.g., `evan/fix-bug-x`)
   - The new branch uses the current branch as its base automatically

5. Special case - If the parent branch contains "swap" (a workaround for git worktrees):
   - After creating the branch, move it onto main instead:
   - Command: `gs branch onto main`
   - This ensures the new branch stacks off main, not the swap branch

Helpful commands after creating a stack:
- `gs ls` or `gs ll` - View your stack structure (short/long)
- `gs up` / `gs down` - Navigate up/down the stack
- `gs top` / `gs bottom` - Jump to top/bottom of stack
- `gs repo sync` (shorthand: `gs rs`) - Sync with remote, delete merged branches
- `gs stack restack` (shorthand: `gs sr`) - Restack all branches in the stack

Follow-up changes (NOT using /gtc):
When the user asks to "commit" changes after already using /gtc on a feature branch:
1. ALWAYS ASK the user for confirmation before executing ANY git commands
2. Suggest the appropriate git-spice commands:
   - Amend all changes (keep message): `gs commit amend --all --no-edit` (shorthand: `gs ca --all --no-edit`)
   - Amend with new message: `gs ca --all --message "updated message"`
   - Add new commit on top: `gs commit create --all --message "additional change"` (shorthand: `gs cc --all --message "..."`)
   - These automatically restack any dependent branches
3. Wait for explicit confirmation before executing
4. NEVER push/submit without explicit instruction

Message format:
- Simple message: `gs bc evan/fix-bug-x --all --message "[XS] Fix bug in X"`
- Message with body: Use a HEREDOC to ensure correct formatting:
  ```
  gs bc evan/add-feature-x --all --message "$(cat <<'EOF'
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
