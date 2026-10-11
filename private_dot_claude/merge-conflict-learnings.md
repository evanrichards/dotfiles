# Merge conflict learnings

`/fix-ci` adds one entry here each time it resolves a merge conflict. The goal
is to find the habits that make a PR conflict-prone, and later to promote a
recurring pattern into a CLAUDE.md rule. When a pattern shows up in three or
more entries, propose the CLAUDE.md rule to Evan.

## Cause classes

- **Avoidable reach**: our PR edited existing code that the feature did not
  need, for example a refactor, an extraction, a rename, or a reformat in a
  busy file. A purely additive PR would not conflict.
- **Same-line work**: both PRs changed the same lines for their own reasons.
  This is a real overlap. The fix is coordination (sequence or stack the
  PRs), not a change to how one PR is written.
- **Shared list**: both PRs added entries at the same spot in a registration
  list, an enum, a module `providers` array, or a doc section. Git sees
  adjacent insertions as a conflict.
- **Tooling**: stack restack, squash-merge replay, a CI auto-fix commit, or a
  generated file. The PR content did not cause it.

## Entry format

```
### YYYY-MM-DD #<our PR> vs #<base PR>: <one-line title>
- Files: <conflicting paths>
- Class: <cause class>
- What happened: <our change> vs <their change>, 1-3 lines
- Semantic risk: <what a naive "take ours/theirs" would silently lose, or "none">
- Prevention: <the habit that would have avoided it, or "unavoidable">
```

## Entries

### 2026-10-10 #84689 vs #84685: hard delete extracted the method that a hard reset fix edited
- Files: `lib/domain-platform-persistent-agents/src/persistent-agent-chat/persistent-agent-hard-reset.service.ts`
- Class: Avoidable reach
- What happened: #84689 (hard delete) moved `#terminateChatWorkflow` out of the hard reset service into a new shared `PersistentAgentChatStopService`, so hard delete could reuse it. #84685 changed that same method on main to call `findWorkflowHandle` and return when the chat never started a workflow.
- Semantic risk: a "take ours" resolution drops the #84685 fix. The shared service and the hard delete path keep the old bug. The hard reset spec auto-merged but mocks `findWorkflowHandle`, so it fails against our code.
- Prevention: keep a feature PR additive. Copy ~20 lines into the new service instead of extracting shared code from a busy file. Do the extraction later as its own small PR that lands fast.
