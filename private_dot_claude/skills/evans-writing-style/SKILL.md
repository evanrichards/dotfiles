---
name: evans-writing-style
description: Evan's writing style for design docs, specs, tickets, and other work prose. Use when drafting, editing, or reviewing any document for Evan (rich docs, specs, PRDs, tickets, READMEs, doc comments), before writing the first paragraph and again as a final review pass before publishing.
---

# Evan's writing style

Distilled from Evan's line-by-line review comments on real docs. Apply while
drafting, then run the checklist as a dedicated pass before publishing. Every
rule traces to actual feedback; when a rule and the material genuinely
conflict, ask instead of guessing.

## Drafting order

Evan writes from a conclusion he has already reached: lead with the
compelling part, defend it after, cut the fat from the point. Drafting by
narrowing toward a conclusion produces the opposite shape and most of the
fluff on the cut list below.

- Before any prose, state the thesis in one or two sentences. That is the
  opening. The rest of the doc defends it, ordered by descending reader
  retention: strongest support early, detail later. Never draft top to
  bottom toward the point.
- The "and this is why it's important" excitement is real but it is chat
  content, not doc content. Put it in a note to Evan alongside the draft
  ("kept out of the doc: ..."); he promotes it deliberately or not at all.

## The reader is linear

- Humans read top to bottom, once. Never lean on a concept the doc has not
  introduced yet; a forward aside plants a hook the reader must carry for
  pages. If a point needs a later concept, move the point to where the
  concept lives. Section pointers like "(§5)" are fine for navigation, not as
  license to use §5's vocabulary early.
- No "how to read this doc" scaffolding or authority-labeling sections. Docs
  get handed off with a conversation; they do not live in a vacuum.

## Cut on sight

- Reasoning residue, the cause behind most items below: prose that shows how
  the author got to the conclusion instead of what the reader should build
  or believe. If a sentence exists to justify, reassure, or retrace, cut it;
  the itemized rules catch known variants, this principle catches new ones.
- Draft archaeology: "an earlier draft carried six tables", "this was
  originally called X". No one cares about previous drafts or old names.
- Reassurances against worries no reader has: "collides with nothing",
  "the platform never branches on it". If nobody would think it, do not
  deny it. Corollary: a competent-audience assumption is fine; things
  "understood by nature of being a platform" need no invariant.
- Explanations of house machinery and standard patterns: what durable events
  are, what a transactional outbox guarantees, that entities carry standard
  columns, how a well-known registration pattern works. The audience builds
  with these daily.
- Emphasis tics that restate instead of adding: "and that is by
  construction", "what it buys", "X is the dial", "which is the point",
  "rides" (banned word). Reader fatigue.
- Announcing what you are not building ("no renewal at launch"). If the
  deferral matters, the not-built section owns it; otherwise say nothing.
- References to the current/legacy system outside the sections that own the
  contrast (typically the opening motivation section). Elsewhere the new
  design stands alone.
- Defining a term twice: define once at first use, then just use the word.
- Fighting ghosts: paragraphs that argue with positions from the design
  conversation instead of stating the outcome ("what it is not is a pure
  function of its arguments"). The reader never held that position; state
  the rule, not the rebuttal. When a section reads as fossilized debate, the
  fix is usually the bulleted version: one bullet per rule, no justification
  unless it changes what the reader builds.
- One home per fact: every mechanism is stated fully in exactly one place;
  every other mention is a pointer, not a restatement. Code comments inside
  interface blocks count as homes, so a bullet restating the comment above
  it is a duplicate. Previews written when sections were far apart become
  duplicates when the structure changes; re-check after any reordering.

## Structure

- A title must govern a real subsection: multiple content blocks, a table or
  interface it labels, or a target other text points at. A heading crowning a
  single paragraph is fluff; delete it and let the paragraph flow. Audit
  headings after heavy cutting, since sections shrink out from under their
  titles.
- Prose that enumerates (decision lists, applied-in-N-moves, metric
  definitions, timing knobs) reads better as bullets: one bullet per item,
  the shared fact in the intro line.
- Give a section that seems to come from nowhere a one-sentence why at the
  top, in terms of the problem it addresses, not the doc's history.

## Vocabulary

- Use the house word when one exists (backtest, not "re-run against
  historical decisions").
- One analogy per mechanism, unless two families genuinely name different
  layers (operations vs phases). Mixed families for one layer is a smell;
  two layers with a stated asymmetry at the joint is fine.
- Boring, literal names for everything: decision kinds, columns, sections.
  Prefer dissolving a badly named bundle into plain fields over renaming it.

## Phrasing

- Plain beats aphoristic. If the author would need a second read, no reader
  gets it on the first. Metaphors ("wearing costumes", "triages like a
  person who..."), motto sentences ("depth is a level, levels do not reveal
  flow"), and vivid images are the first thing to cut.
- No em dashes. Use colons, semicolons, parentheses, or two sentences.
- No quippy one-liners in work docs. Limit emoji.
- Never write "substrate" or "honest" unless Evan used the word first.

## Mechanics

- Link every code reference to GitHub (file to blob URL, file:line to #L
  anchors). Link every qid to its corp.app.loop.com page.
- No metadata or subtitle decoration lines in the doc body (spec ids,
  measurement provenance, audience notes). If it matters it is content; if
  not, cut it.
- Tickets: what and why only, with code links. Never add Success Criteria,
  Test Plan, Future Work, Rollout, Monitoring, or estimate sections unless
  explicitly asked.
- READMEs: what and why, not how. No FAQs, roadmaps, or hypothetical future
  work.

## Review pass

A first draft written in-session is shaped by its own drafting: the author
is invested in the justifications and the design debate, which makes
reasoning residue and ghost-fighting invisible from inside. So the edit pass
is not optional and not a trim; run it as a rewrite of someone else's draft.
The strong form is a fresh-context editor: dispatch a subagent with only the
doc content and this skill, none of the drafting conversation. Ghosts and
residue read as noise to it, which is exactly what makes them cuttable.

Whether editing fresh or inline, sweep each section against the lists above
and fix in place. Check that the thesis opens the doc. Check diagrams and
figure labels too: they lag prose edits and keep old vocabulary alive. Note
anything cut that carried real information so Evan can veto the cut.
