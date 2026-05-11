---
description: Fix failing CI for current branch
---

Fix CI for the current branch's PR. "Green" means **mergeable** — zero cancelled, zero failing, all required checks succeeded. `gh pr checks` only shows the latest run per name and HIDES cancelled-then-rerun-success records that still block merge. Always assess via `statusCheckRollup`.

## Workflow

1. **Find non-success records** (cancelled OR failing), keeping every row — do not group by name:
   ```bash
   gh pr view --json statusCheckRollup --jq '.statusCheckRollup[] | select(.conclusion != null and .conclusion != "SUCCESS" and .conclusion != "NEUTRAL" and .conclusion != "SKIPPED") | {name, conclusion, detailsUrl}'
   ```

2. **Cancelled runs** (usually leftovers from force-push concurrency cancellation):
   ```bash
   gh pr view --json statusCheckRollup --jq '.statusCheckRollup[] | select(.conclusion == "CANCELLED") | .detailsUrl' | grep -oE 'runs/[0-9]+' | sort -u
   ```
   For each unique run ID:
   - Confirm `gh run view <id> --json status,headBranch` shows `status=completed` and the right branch.
   - `gh run rerun <id>` — re-queues the same run ID in place; the rollup conclusion updates rather than appending a new row.
   - If a same-workflow run is currently in-progress, wait for it first — rerunning while another is in flight will trigger concurrency cancel of the in-flight one.

3. **Failing runs** (`conclusion == "FAILURE"`):
   - `gh run view <run-id> --log-failed` to read the error.
   - Common infra flakes — rerun, do not fix code:
     - `Run E2E Tests` failing on "Start temporal debouncer" with `Debouncer server failed to start` (jest "Run tests" step succeeded) → `gh run rerun <id> --failed`.
     - `check-eslint-style` exit 124 (timeout 12m killed eslint) → rerun. Repeat across multiple runs = real.
     - `Run Black Box Tests` ending with `##[error]The runner has received a shutdown signal` (spot instance) → look for `Tests: N passed, M total`; if tests passed, `gh run rerun <id> --failed`.
   - Real failures: fix the code, push.
   - Prefer `gh run rerun <id> --failed` over whole-workflow rerun — only requeues the failed job, avoids workflow concurrency cancellation.

4. **Verify**: re-run the step 1 query. Only report green when it returns nothing.

## Notes

- **Force-pushed rebase always creates a fresh CANCELLED batch.** GitHub queues two parallel triggers per workflow on push and concurrency-cancels one within seconds. After every push, expect ~half the checks to immediately show CANCELLED. Don't read this as "the previous push left checks cancelled" — they're new ones from the latest push and need the same rerun treatment.
- If there's no PR for the branch or the rollup is fully clean, tell the user.
