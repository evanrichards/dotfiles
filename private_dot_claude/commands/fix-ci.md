---
description: Fix failing CI for current branch
---

Fix CI for the current branch's PR. "Green" means **mergeable** — zero cancelled, zero failing, all required checks succeeded, the rollup's overall `state` is `SUCCESS`, AND `mergeStateStatus` is not `BLOCKED`. `gh pr checks` only shows the latest run per name and HIDES cancelled-then-rerun-success records that still block merge. Always assess via `statusCheckRollup` — and never report green from the rollup alone (see step 0; a rollup `SUCCESS` can still be unmergeable).

## Workflow

0. **Read the rollup state AND mergeStateStatus first.** The rollup catches most "Expected — Waiting for status to be reported" required checks (branch-protection-required checks with no CheckRun for the current SHA — invisible to any count-based query). `mergeStateStatus` is the only signal that catches the rest (see the jobless-cancelled-twin trap in step 2b):
   ```bash
   gh api graphql -f query='{ repository(owner:"<owner>", name:"<repo>") { pullRequest(number:<n>) { mergeStateStatus reviewDecision commits(last:1) { nodes { commit { oid statusCheckRollup { state } } } } } } }' --jq '.data.repository.pullRequest | {mergeStateStatus, reviewDecision, sha: .commits.nodes[0].commit.oid, rollup: .commits.nodes[0].commit.statusCheckRollup.state}'
   ```
   Rollup states: `SUCCESS`, `PENDING`, `FAILURE`, `ERROR`, `EXPECTED`. **Never report green based on enumerating CheckRuns** — a PENDING state with zero FAILED CheckRuns still blocks merge because GitHub is waiting on required-check names that have no CheckRun yet.

   **Rollup `SUCCESS` alone does NOT mean mergeable.** Interpret the pair:
   - rollup `SUCCESS` + `mergeStateStatus` not `BLOCKED` → green.
   - rollup `SUCCESS` + `mergeStateStatus: BLOCKED` + `reviewDecision` missing/`REVIEW_REQUIRED` → CI is green but the PR needs approval; say so.
   - rollup `SUCCESS` + `BLOCKED` + `APPROVED` → almost certainly the **jobless cancelled twin** (step 2b). Branch protection still counts N required checks as "expected" even though every visible check run succeeded; `enqueuePullRequest` / merge will reject with "N of M required status checks are expected".

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

2b. **Jobless cancelled twins** (invisible to steps 0–1): a twin run concurrency-cancelled *before it created any jobs* leaves **no check runs at all** — nothing in `.statusCheckRollup[]`, and the rollup state stays `SUCCESS` because the sibling's checks all passed. But branch protection still counts the dead suite's required checks as "expected", so merge/enqueue fails. Symptom: rollup `SUCCESS`, approved, `mergeStateStatus: BLOCKED`, and exactly the long-running required checks have one success record while every other check has two. Diagnose at the workflow-run layer, not the check layer:
   ```bash
   gh run list --commit <headSha> --json databaseId,name,status,conclusion,event \
     --jq 'map(select(.conclusion == "cancelled"))'
   ```
   For each cancelled run, `gh run view <id> --json jobs --jq '.jobs | length'` — `0` jobs confirms it died pre-job-creation. Fix with a plain `gh run rerun <id>` (`--failed` won't work; there are no failed jobs).

3. **Failing runs** (`conclusion == "FAILURE"`):
   - `gh run view <run-id> --log-failed` to read the error.
   - Common infra flakes — rerun, do not fix code:
     - `Run E2E Tests` failing on "Start temporal debouncer" with `Debouncer server failed to start` (jest "Run tests" step succeeded) → `gh run rerun <id> --failed`.
     - `check-eslint-style` exit 124 (timeout 12m killed eslint) → rerun. Repeat across multiple runs = real.
     - `Run Black Box Tests` ending with `##[error]The runner has received a shutdown signal` (spot instance) → look for `Tests: N passed, M total`; if tests passed, `gh run rerun <id> --failed`.
   - Real failures: fix the code, push.
   - Prefer `gh run rerun <id> --failed` over whole-workflow rerun — only requeues the failed job, avoids workflow concurrency cancellation.

4. **Verify**: re-run the step 0 query AND the step 1 query. Only report green when rollup state is `SUCCESS`, step 1 returns nothing, AND `mergeStateStatus` is not `BLOCKED` (or BLOCKED is fully explained by a missing approval). **Do not declare green based on only counting CheckRuns** — the UI may still show "Expected — Waiting for status to be reported" rows that are invisible to CheckRuns queries but block merge, and a jobless cancelled twin (step 2b) is invisible even to the rollup state.

## Notes

- **Force-pushed rebase always creates a fresh CANCELLED batch.** GitHub queues two parallel triggers per workflow on push and concurrency-cancels one within seconds. After every push, expect ~half the checks to immediately show CANCELLED. Don't read this as "the previous push left checks cancelled" — they're new ones from the latest push and need the same rerun treatment.
- **"Expected — Waiting for status to be reported" rows in the UI are invisible to `.statusCheckRollup[]`.** They live at the branch-protection layer, not in CheckRuns. A count-based query like `select(.conclusion == "FAILURE") | length == 0` will lie. The rollup `state` field reflects most of them — but NOT the jobless-cancelled-twin case (step 2b), where rollup stays `SUCCESS`. `mergeStateStatus` is the only signal that covers both. Check rollup `state == "SUCCESS"` AND `mergeStateStatus != "BLOCKED"`.
- If there's no PR for the branch or everything is clean (rollup `SUCCESS` and not `BLOCKED`), tell the user.
