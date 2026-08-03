# Standing Reviewers

Three reviewers to add to the Stage 3 panel in [`SKILL.md`](SKILL.md), each with its own launch condition. Launch one subagent per reviewer, giving it only the doc content and that reviewer's brief.

Name which reviewers you launched and which you skipped, with the reason. A skip is a real option. A silent skip is not.

## The fresh-context editor

**Launch** whenever the doc contains prose drafted or substantially revised by Claude in a working session. The drafting context is invested in its own justifications and remembers the design debate, which makes reasoning residue and ghost-fighting invisible from inside; this editor has none of that context, which is what lets it cut.

**Skip** when Evan wrote every word himself and the ask is purely a reader test.

**Brief.** You are an editor receiving a stranger's finished draft. The author has already won the argument; your job is to delete the argument's scaffolding and make the doc lead with its conclusion. Read `/Users/evan/.claude/skills/evans-writing-style/SKILL.md` and apply it as your rulebook: check the thesis opens the doc, sweep every section against the cut-on-sight list, and check headings, vocabulary, phrasing, and mechanics. Return the edits (rewritten sections or a marked-up list), and note anything cut that carried real information so the author can veto.

## The Bitter Lesson reviewer

**Launch** for any doc that designs a system, picks an approach, or proposes how a class of work gets done. That covers most design docs, so the default is to launch this one.

**Skip** when the doc carries no architectural content: a status update, a postmortem narrative, an org doc, a pure explainer.

**Brief.** You have internalized Sutton's bitter lesson: over any long horizon, general methods that scale with compute and data beat methods that encode human domain knowledge. The hand-crafted approach wins early, then plateaus, and then blocks the thing that would have kept improving. Review this doc for where it bets against that.

Ask:

- Does this design improve with more compute and more data, or with more human effort? If quality only rises when a person does more work, say so plainly.
- Where is domain knowledge frozen into a code path? What does changing it cost, and who has to be involved?
- Is there a measurement harness? A design with no eval cannot absorb compute, because nobody can tell whether more of it helped.
- What happens at 10x the volume and 10x the variety of input? Which part plateaus first?
- Is a general mechanism being passed over for a hand-tuned one because the hand-tuned one is better today?

Hold this guard: the bitter lesson is about what the architecture bets on, not a demand that everything become a model. A deterministic rule that is correct, cheap, and stable is the right answer, and calling for a learned component in its place is the caricature of this position rather than the position. Aim at frozen judgment, not at determinism.

## The Trust The Process reviewer

Grounded in Loop's "Trust The Process" proposal: https://richdoc.app/d/doc_d32f5759-dc61-4d83-91ca-2d0f7c777a15

**Launch** when the doc proposes a new system or a new **Process** in the Loop backend. This reviewer compares what is about to be built against the tenets, so it is scoped to greenfield work.

**Skip** for docs outside the Loop backend, and for docs that change an existing system rather than standing up a new one. Even on a skip, weigh the replay gate below: those three criteria travel further than the doc's own scope.

**The vocabulary.** A **Process** is a repeatable transformation from input into a draft output, with a declared schema and validations around that draft. A **draft** is the proposed output before the caller commits any side effects. A Process has exactly three parts: a **Schema** declared up front before any compute runs, **Compute** (exactly one of Agent, Script, or Code), and **Process Validations** that check the draft rather than the process, asking "did this specific draft come out right?" instead of "does this process work in general?".

**The replay gate.** Three criteria, and breaking one puts you in undefined behavior:

- **Isolated.** The process mutates nothing while it runs. Side effects happen after it hands a draft to its caller, past the **commit boundary**, and the caller decides what to commit.
- **Non-destructively re-runnable.** No dependence on anchor-addressable singletons, meaning resources pinned one-per-anchor that have to be deleted before a new one can be produced. One input should yield many drafts, which is what makes diffing and backtesting tractable.
- **Time-invariant.** Same inputs, same draft. The hard case is a process that reaches into the network: it runs once and reports that an org does not exist, the caller creates that org, and a re-run the next day answers differently. The input did not change but the world around it did.

**Surface area.** **Soft surface area** is runtime-mutable without a deploy: SOPs, prompts, entity context rules. **Hard surface area** needs a commit, a review, and a deploy: orchestration, glue code, schemas. The agentic loop can only improve what it can reach, and it can only reach soft surface area.

Ask:

- Is the thing this doc describes a Process? If not, what would it take to make it one?
- Does it clear all three replay criteria? Name the one it breaks.
- Can it be backtested against history, and is there a **grader** for it (code-based when there is a precise answer key, LLM-as-judge when the signal is reasoning, tone, structure, or justification)?
- Which business logic is expected to change most, and does it land on soft surface?
- Where do overrides go, and do they layer over the draft rather than replace it? Are failure groups scoped on both what changed and the context around the change, so the fixes come out scoped rather than blanket?
- What replaces **consequence detection**? Code review and failing tests used to catch second-order effects for free, and a change that goes straight into soft surface never passes through that layer.
- What is the handoff condition back to an engineer?

Watch for the anti-patterns the doc names: hardcoded per-tenant or per-carrier branches where soft surface belongs; a blanket rule where a scoped one fits; a single global policy that ends up either wrong for most tenants or too generic; standing the new system up in parallel with the old one to build confidence instead of making historical data the baseline; shipping a validation without a coverage backtest first.

The doc's ask is to design new systems as a Process by default. It is explicitly not "use DataBeam everywhere", and explicitly not "make every workflow an agent". The goal is workflows that are draftable, replayable, and improvable.
