---
name: doc-coauthoring
description: Co-author a document with the user through info dump, section-by-section drafting, and Reader Claude testing. Use when the user wants to write or substantially revise a doc, spec, proposal, PRD, or decision doc, or when they want reader reviews run against a doc that is already written.
---

# Doc Co-Authoring

Three stages: **info dump**, section-by-section drafting, **Reader Claude** testing.

Open by naming the workflow and its three stages. If they would rather go freeform, drop it.

Stage 3 stands alone and is the common entry point. When the doc is already written and they want it reviewed, go straight there.

**Where the doc lives.** Draft into a markdown file, not an artifact: you need `Edit` on it all the way through. Default to `/Users/evan/evans-docs/`, and for specs use the `SPEC-YYYY-MM-DD-<slug>.md` convention. Ask if the destination is unclear. Publishing to rich-doc or an Artifact is a last step, after the content is settled.

## Stage 1: Info dump

**Goal:** close the gap between what the user knows and what you know.

Open with these, telling them shorthand is fine and order does not matter:

1. What type of doc is this?
2. Who is the primary audience?
3. What should happen in the reader's head when they finish it?
4. Is there a template to follow, or an existing doc to revise?
5. What constraints matter (timeline, org politics, prior incidents)?

Then invite the **info dump**: background on the problem, related threads, why the alternatives lost, org context, architecture and dependencies, stakeholder concerns. Tell them to dump it unsorted and that you will sort it.

Pull the context yourself instead of asking them to paste it. Slack, Gmail, Drive, Linear, and rich-doc are wired up, so read the channels, tickets, and docs they name. Confirm with them before searching for entities they have not named.

If they are revising an existing shared doc, read its current state first. Flag any image lacking alt-text: a reader who pastes this doc into Claude gets nothing from that image, so offer to write alt-text from a pasted copy.

When the dump slows, ask 5-10 numbered clarifying questions aimed at the gaps you can now see.

**Done when** you can ask about edge cases and trade-offs without needing the basics explained. Ask whether they have more to add before moving on.

## Stage 2: Draft section by section

**Goal:** build the doc one section at a time, with every edit **surgical**.

Agree the structure first. If they do not know what sections they need, propose 3-5 for this doc type and ask them to adjust. Then write the file with every header in place and `[TBD]` under each, so you both have a scaffold to fill.

Start with the section carrying the most unknowns: usually the core proposal for a decision doc, the technical approach for a spec. Summaries and abstracts go last, once you know what they summarize.

For each section:

1. Ask 5-10 clarifying questions about what belongs in it.
2. Brainstorm 5-20 numbered candidate points in chat. Include context they gave earlier and may have forgotten, plus angles they have not raised. Offer more if they want them.
3. Ask what to keep, cut, or combine, with brief reasons: "keep 1,4,7", "cut 3, duplicates 1", "cut 6, audience knows this", "merge 11 and 12". Take freeform answers too. The reasons are the point: they teach you their priorities for every later section.
4. Ask what is missing.
5. Replace the placeholder with the draft, using `Edit`.
6. Iterate on their feedback with **surgical** edits: change the lines they name and leave the rest untouched.

Ask them to name what to change rather than editing the file themselves, so you learn their style for the next section. If they do edit it directly, read the diff and carry those preferences forward.

Every third iteration on a section, ask what can come out without losing anything.

**Done when** they say the section is done. Then move to the next.

Once all sections are drafted, read the whole doc top to bottom and report on flow across sections, contradictions, redundancy, **slop** and generic filler, and whether every sentence carries weight. Fix what they agree with before Stage 3.

## Stage 3: Reader Claude testing

**Goal:** catch what makes sense to the two of you but not to a stranger.

Entering here on a finished doc, read it and ask only two things: who the audience is, and whether it proposes building something new. Then assemble the panel.

**Generated readers.** Draw 3-5 personas from the doc's real audience, and for each, the 5-10 questions that reader arrives with. A persona is a role with a stake rather than a demographic: the on-call engineer who has to operate this, the staff engineer reviewing the PR, the exec funding it.

**Standing reviewers.** Read [`REVIEWERS.md`](REVIEWERS.md) on every Stage 3 run. It holds three reviewers, each with its own launch condition: a fresh-context editor for any Claude-drafted prose, and two design reviewers for docs that propose building something.

Dispatch one subagent per reviewer, giving it only the doc content and that reviewer's brief. No context from this conversation. That isolation is the whole mechanism: **Reader Claude** has to be as ignorant as the reader.

Dispatch another subagent to hunt ambiguity, assumptions the doc leaves unstated, and internal contradictions.

Report per reviewer what landed and what did not, and name which standing reviewers you launched and which you skipped, with the reason. A wrong answer is a gap in the doc rather than a failure of the reader, so fix the section and re-test that reviewer.

**Done when** every generated question comes back answered correctly, every objection from a launched standing reviewer is either fixed or explicitly accepted by the user, and the ambiguity checks surface nothing new.

## Final read

The doc is theirs. Before calling it done:

- Tell them to read it through themselves, since they own its quality.
- Flag the facts, links, and numbers for them to verify.
- Ask whether it lands the impact they named in Stage 1.

Then offer two closing moves: appendices carry depth without bloating the body, and linking this conversation in an appendix shows readers how the doc was built.

## Deviations

If they want to skip a stage, skip it. If they are frustrated at the pace, say so plainly and offer a faster path: fewer brainstorm options, larger drafting chunks, or straight to a full draft they react to. They can adjust any part of this.

Throughout, when something they mention is context you lack, ask right then. Gaps compound.
