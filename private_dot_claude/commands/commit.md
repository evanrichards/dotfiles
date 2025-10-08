---
description: Create a git commit using graphite workflow
argument-hint: [message]
---

Create a git commit with the provided message or staged changes.

Important workflow details:
- We use Graphite for git workflow (use `gt` commands)
- Commit messages MUST be prefixed with a t-shirt size in brackets: [XS], [S], [M], [L], [XL]
- The t-shirt size represents the COGNITIVE LOAD for reviewing, NOT just lines changed
  - Example: A 5-line change in a critical path might be [M]
  - Example: A 1500-line mechanical rename refactor could be [XS] if simple to review
- Do NOT include "Generated with Claude Code" attribution
- Do NOT include Claude as co-author

If no message is provided via $ARGUMENTS, analyze the staged changes and suggest an appropriate commit message with the correct t-shirt size prefix.
