---
description: Create a new branch with current changes using graphite
argument-hint: [message]
---

Create a new branch with the current changes using graphite CLI.

Important workflow details:
- We use Graphite CLI for git workflow
- Use `gt create {message}` to create a NEW branch with the current changes
- You are NEVER committing TO the current branch - you always create a new branch
- Commit messages MUST be prefixed with a t-shirt size in brackets: [XS], [S], [M], [L], [XL]
- The t-shirt size represents the COGNITIVE LOAD for reviewing, NOT just lines changed
  - Example: A 5-line change in a critical path might be [M]
  - Example: A 1500-line mechanical rename refactor could be [XS] if simple to review
- Do NOT include "Generated with Claude Code" attribution
- Do NOT include Claude as co-author

Workflow steps:
1. Review the current changes (git status, git diff)
2. If no message is provided via $ARGUMENTS, analyze the changes and suggest an appropriate commit message with the correct t-shirt size prefix
3. Use `gt create "{message}"` to create a new branch with these changes

Message format:
- For a simple commit: `gt create "[XS] Fix bug in X"`
- For a commit with body: Use a newline after the subject, then a blank line, then the body:
  ```
  gt create "[M] Add feature X

  This implements feature X which handles Y.
  Additional details here."
  ```
