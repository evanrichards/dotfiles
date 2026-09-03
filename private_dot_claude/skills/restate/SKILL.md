---
name: restate
description: Use when Evan says the last response was too long, dense, or unreadable, or asks what the point is, what the ask is, "tldr", "so what do you need from me", or invokes /restate. Re-emits the immediately previous assistant message as a short point plus numbered asks.
---

# Restate

Evan cannot consume a long response with questions buried in it. The content
of your last message is already correct. Only its shape failed. Re-emit it.

## Scope

Read your own immediately previous message and nothing else. Do not re-read
the conversation, re-run a tool, re-investigate, or add a fact that was not
already in that message. This is a re-emit, not a redo, and not a recap of
the session.

## The reply

The reply has three labelled parts, in this order. The first characters you
write are `**Point.**` and the last line you write is the Default line.

**Point.** One or two sentences. State the conclusion, not the path to it. If
the message reported a finding, give the finding. If it proposed work, give
the recommendation you would pick.

**Asks.** A numbered list. One line each. Each ask is answerable on its own,
so that a reply of "1: yes, 2: b" is enough. Merge duplicate questions into
one ask. Put the ask that blocks you first. End each line with `[blocking]`
or `[fyi]`.

Include the decisions the message implied but never asked out loud. A report
that ends "I did not change anything" still leaves Evan a choice about what
happens next, and that choice is an ask. Write `Asks: none.` only when Evan
has nothing to decide.

**Default.** One line that starts "If you say nothing, I will ...". This tells
Evan he can stay silent. Write "I am blocked" only when no path forward
exists.

The whole reply fits in about 120 words. A longer reply means you explained
instead of restated.

## How to compress

- Turn every option list into a recommendation plus lettered choices inside
  one ask. Options never get their own paragraphs.
- Keep every qid, file path, PR number, ticket ID, and count from the
  original. Precision is not length.
- Cut the reasoning, the background, and the caveats. Evan asks for those
  when he wants them.
- Address the asks to Evan as questions. Do not narrate a plan at him.
- Use commas, colons, or full stops for a break in a sentence. Evan does not
  want em dashes.

## Example

The previous message was 600 words on why a nightly evaluation stopped
running: the investigation path, two candidate causes, the one that turned
out to be true, three buried questions, and an offer to add a monitor.

```
**Point.** The `mack-nightly-eval` schedule has not fired since 2026-08-21.
A deploy sync left it paused, and a paused schedule survives a deploy. The
workflow code is fine.

**Asks.**
1. Unpause now, or wait for the 09-05 release? [blocking]
2. The 13 skipped runs: (a) backfill them, (b) let them go? [blocking]
3. A monitor for paused schedules would catch this. Want a ticket? [fyi]

**Default.** If you say nothing, I will unpause it now and let the skipped
runs go.
```
