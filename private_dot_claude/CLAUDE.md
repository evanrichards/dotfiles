## Parallel agents & misdirected messages

I am often running multiple agents in parallel across different chats and
worktrees. Because of this, I sometimes paste a message into the wrong chat.

If a message arrives that sounds "apropos of nothing" — it doesn't follow from
the current task, references work or context this chat hasn't touched, or
otherwise reads like it was meant for a different agent — STOP and push back.
Ask whether it was actually intended for this chat before acting on it. Do NOT
quietly decide "well, I guess I'm doing this now" and try your best to comply;
that just burns time and makes it slower for me to notice I put it in the wrong
place. A quick "this doesn't seem related to what we were doing — did you mean
to send this here?" is exactly what I want.

## Tools

You should use git-spice (`gs`) for stacked branch workflows. Use `gs` (not
`gt` or raw git) for branch creation, navigation, restacking, and submitting
PRs. See /gtc for the branch creation workflow. Full docs:
https://abhinav.github.io/git-spice/llms-full.txt

### Stacking with the merge queue (squash-only)

Our repos are squash-merge-only and use a GitHub merge queue. The queue rebases
each PR onto the live tip of main and lands it as a brand-new squashed commit, so
the base PR's original commits never appear in main by identity. A stacked child
(B on A) still contains A's commits in its history, so the ONLY thing that keeps a
restack conflict-free is git-spice replaying just the child's own commits via
`git rebase --onto main A B`. Anything that rebases the child onto main without
excluding the old base's commits will replay B's copy of A's changes on top of the
squashed A already in main → "same lines changed twice" conflicts. To stay safe:

- Always sync and restack through git-spice (`gs repo sync` / `gs rs`, then
  `gs stack restack`). NEVER `git pull main` + raw `git rebase main` on a stacked
  branch — raw git has no idea to drop the old base's commits.
- Only restack a child AFTER its base PR has actually landed in the queue (green
  merge). Restacking while the base is still mid-queue rebases the child onto an
  A-less main; when A later lands squashed, the next sync collides the child's
  A-copy with it.
- Don't delete merged local branches by hand or rebase branches out-of-band before
  syncing — that destroys the base reference git-spice needs for `--onto`. Let
  `gs repo sync` detect merged PRs and clean up.
- Residual conflicts against OTHER people's PRs that the queue rebased ahead of you
  are legitimate and unavoidable; only "child vs its own base" conflicts indicate a
  workflow/tooling mistake.

Your bash environment has access to some useful non-default tools:
- `sg` is ast-grep. It is described as "a fast and polyglot tool for code
  structural search, lint, rewriting at large scale." More info at
  https://ast-grep.github.io/llms.txt
- `fastmod` is a code modification tool forked from codemod. Very useful for
  large refactors or refactoring code. When applicable, use fastmod over
  grepping for usages and manually editing the file.
- `temporal` is the Temporal CLI. When debugging workflows, use
  `temporal --env prod` to query production for workflow history, status,
  and other details.
- We use the loop-corp MCP a _lot_ for debugging. If i am asking you about
  historical data or logs or mutating stuff, i am most likely asking you to use
  the MCP to write a script to get the answer.

## Code Style

Do not leave chat-context implementation comments in the code base. Examples
are things like "// Here we have improved the perf (new!)".

By default, type check your changes before saying you are done. Exception:
if a PR is already open for the branch, push your changes and let CI run
the type check instead of running it locally first. Type checking is slow,
and running it locally and then again in CI doubles the wait.

When type checking reveals errors (locally or in CI), fix them, even if
they appear pre-existing or unrelated to the current changes. Do not
dismiss errors or move on without fixing them. Most cross-package type
errors are resolved by running `pnpm install && pnpm turbo build`.

When writing classes, if a method has no `self.` accesses, you should perfer
for it to be a pure function that is only exported if testing is needed. This
makes it easier to test.

## Git

When creating git commits, do not include Claude as a co-author or add any
"Generated with Claude Code" attribution.

Commit messages should be prefixed with a t-shirt size in brackets (e.g.,
"[XS] fix typo in xyz"). This size estimates the cognitive load for the
reviewer, not just lines of code changed. A 5-line change in a critical path
might be [M], while a 1500-line rename refactor could be [XS] if it's
mechanically simple to review.

## Worktrees

When the session is running in a git worktree (the environment's working
directory is under a `worktrees/` path, e.g.
`.../backend/.claude/worktrees/<name>`), every file you touch must live under
that worktree root. Before the first Edit/Write of a session, note the worktree
root from the environment and treat it as the only valid prefix for file paths.

The trap: worktrees live *inside* the main repo, so a recursive search finds two
copies of every file — the main-repo copy and the worktree copy. Subagents
(Explore, etc.) and search tools routinely report the **main-repo** absolute
path (`.../backend/lib/...`) because it's the shorter, canonical-looking one.
If you paste that path straight into Read/Edit, you silently edit the wrong
checkout — usually a different branch with unrelated uncommitted work. Bash
commands run with cwd in the worktree, so `git rm`/`git status` land correctly,
which makes the divergence even harder to notice (deletions in the worktree,
edits in main).

Rules:
- Never edit a path under the main `backend/lib` (or any path outside the
  worktree root) while in a worktree. Translate every agent-supplied or
  search-supplied absolute path to the worktree root before opening it.
- After a batch of edits, run `git status` in the worktree and confirm the
  modified files actually show up there. If they don't, you edited the wrong
  copy — revert in the main repo with `git checkout HEAD -- <files>` (only after
  confirming those files were clean at HEAD so you don't clobber other work) and
  re-apply in the worktree.

## Writing

When writing documentation or tickets, limit emoji usage. Keep content focused
on what was asked for.

When providing a URL in chat output, paste the raw URL on its own (or inline as
plain text). Do not wrap it in markdown link syntax like `[label](url)`. My
terminal renders markdown links as the label only, hiding the URL — raw URLs
are clickable as-is and easier to copy.

When writing readmes, focus on the *what* and *why* of the project, not the
*how*. Unless explicitly asked *never* write:
- hypothetical future work
- FAQs or common issues
- roadmaps
- monitoring details

CRITICAL - When writing tickets:
- Add links to relevant code when possible
- Keep tickets focused on WHAT needs to be done and WHY, not speculative content

NEVER INCLUDE THESE SECTIONS (unless explicitly requested by the user):
- NO "Success Criteria" or "Acceptance Criteria" sections
- NO "Testing Considerations" or "Test Plan" sections
- NO "Productionization Considerations" sections
- NO "Future Work" or "Future Considerations" sections
- NO time estimates or effort estimates
- NO "Monitoring" or "Observability" sections
- NO "Rollout Plan" or "Deployment Strategy" sections

If you find yourself writing any of these forbidden sections, STOP and remove them.
The ticket should describe the work to be done, not how to validate or deploy it.

## Dual Goals

Every session has two goals:

1. **Explicit**: The immediate task (implement X, debug Y)
2. **Implicit**: Multiply influence as a staff engineer - through documentation, skills, hooks, and patterns that help the team do it right the first time and avoid common traps

Keep both in mind. While working on the explicit goal, watch for opportunities to improve tooling, docs, or workflows that make everyone more efficient and correct. Not every session yields something (fix merge conflict, trivial tasks), but longer sessions often do.

## Self-Improving Documentation

When we learn something that would help someone (including future Claude) in a
similar situation, ask if we should add it to the domain's README. This includes:
- Implementation patterns that aren't obvious from the code
- Debugging insights and troubleshooting steps
- Platform behaviors that required explanation

Ask after we've confirmed the learning works (moved the problem forward), not
immediately. Discuss the change together rather than drafting it unilaterally.

When debugging, read the relevant domain READMEs first before diving into
code or storage. Let README reading cascade - if one references another domain,
read that README too. Don't stop at the surface; build a full picture of how
something works. Use judgment on depth - you can always go back and read more.

## Design & Idioms

- **Remove root causes; don't engineer around them.** If you're adding a
  factory, adapter, wrapper, or dynamic module whose only job is to make
  something fit a constraint, stop — that's a signal the design is wrong
  upstream. Name the actual constraint, then change the thing that creates it.
  "Make it work" is not the bar; the idiomatic shape is.
- **Find the existing precedent and copy it.** Before inventing a structure,
  locate how the codebase already solves the same shape (a sibling factory, a
  peer module) and match it. The right pattern is usually a few files away.
- **Respect domain ownership — no domain-hopping.** A consumer must not reach
  into a peer/owning domain's internals to reassemble what it needs. The domain
  that owns a concern keeps that concern's code, exposes composable pieces, and
  other domains compose only from their legitimate dependencies.
- **For non-mechanical changes, give me the state of the world and the shape of
  the options before executing.** Lay out the root problem and 2–3 solution
  shapes with a recommendation; let me pick. Don't charge ahead on structure.
- **When stuck — or when I push back twice — stop patching and state the root
  problem plainly.** Bullet the actual constraint and why each workaround fails,
  then re-derive the design from the constraint, not from the last broken attempt.
- **Smells to recognize:** indirection that loses traceability (string/registry
  lookup chosen over injecting a concrete instance); configurable/dynamic modules
  with an `imports`/options passthrough; "add then revert" churn. Prefer plain
  static wiring and injected instances.
