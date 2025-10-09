---
description: Fix failing CI for current branch
---

Fix CI failures for the current branch using GitHub CLI.

Workflow steps:
1. Use `gh pr checks` to see the CI status for the current branch's PR
2. For any failing checks, use `gh run view <run-id> --log-failed` to get the error logs
3. Analyze the failures and fix the issues
4. Report what was fixed and re-run checks if needed

If there's no PR for this branch or no CI failures, inform the user.
