---
description: Triage and address GitHub PR comments for current branch
---

Get GitHub PR comments for the current branch, triage them, and address issues.

Workflow steps:
1. Get the current branch name
2. Fetch ALL PR comments for this branch:
   - Use `gh pr view --json comments` for general PR comments
   - Use `gh pr view --json reviews` or `gh api repos/{owner}/{repo}/pulls/{pr}/comments` for line-specific review comments
3. Triage all comments (both general and line-specific) into two categories:
   - **Obviously correct**: Issues that are clearly bugs, typos, or objective improvements
   - **Taste/Unsure**: Issues that are subjective, unclear, or require discussion
4. Address all "obviously correct" issues immediately
5. Present the "taste/unsure" issues to the user and ask for guidance

When presenting unsure issues to the user:
- Quote the relevant comment
- Explain why it's not obvious
- Ask for their preference

If there are no comments or the PR doesn't exist, inform the user.
