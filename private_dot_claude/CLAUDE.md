You have access to the linear mcp. Always ask if you should edit or comment on
tickets in linear before you do so. Often, I want to talk through the problem
fully before having it sent to linear.

Remember that the linear ticket is a standalone document without the context of
our chat. Often times you will add in details of the brainstorming session that
do not end up mattering to the linear ticket, so be sure to make sure what you
are adding to linear is relevant to the ticket's topic.

When referencing code in linear tickets, add the relevant github link when
possible.

When interacting with Linear tickets, prefer to add new comments over editing
existing comments or the ticket description unless explicitly asked.

You have access to sub-agents. Feel free to use these when appropriate.

Do not leave chat-context implementation comments in the code base. Examples 
are things like "// Here we have improved the perf (new!)".

Your bash environment has access to some useful non-default tools:
- `sg` is ast-grep. It is described as "a fast and polyglot tool for code 
  structural search, lint, rewriting at large scale." More info at 
  https://ast-grep.github.io/llms.txt
- `fastmod` is a code modification tool forked from codemod. Very useful for 
  large refactors or refactoring code. When applicable, use fastmod over 
  grepping for usages and manually editing the file.

You should always type check your changes before saying you are done.

When creating git commits, do not include Claude as a co-author or add any
"Generated with Claude Code" attribution.

Commit messages should be prefixed with a t-shirt size in brackets (e.g.,
"[XS] fix typo in xyz"). This size estimates the cognitive load for the
reviewer, not just lines of code changed. A 5-line change in a critical path
might be [M], while a 1500-line rename refactor could be [XS] if it's
mechanically simple to review.

When writing documentation or tickets, limit emoji usage. Keep content focused
on what was asked for.

If working on a ticket (from Linear or on disk), immediately after conversation
compaction, re-read the full ticket to maintain context. Ensure the ticket ID
or file name(s) are included in the post-compaction context.

When writing classes, if a method has no `self.` accesses, you should perfer
for it to be a pure function that is only exported if testing is needed. This
makes it easier to test.

In the backend repo, you can use the `./apps/backend/scripts/prod_psql.sh`
script as psql. you can run it like
`echo "SELECT 1 as test;" | ./apps/backend/scripts/prod_psql.sh`

There is no `yarn turbo run tsc:check`, you want to use `yarn turbo check-types`

IMPORTANT: *NO `any` NO `unknown` NO ` as ` unless you ASK ME and I say ok*

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
