## Tools

You should use git-spice (`gs`) for stacked branch workflows. Use `gs` (not
`gt` or raw git) for branch creation, navigation, restacking, and submitting
PRs. See /gtc for the branch creation workflow. Full docs:
https://abhinav.github.io/git-spice/llms-full.txt

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
