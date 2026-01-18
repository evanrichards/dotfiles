---
description: Implement a Linear ticket
argument-hint: <ticket-id>
---

Implement Linear ticket $1 using the following structured workflow:

## Phase 1: Read and Understand the Ticket

Fetch the Linear ticket and all its comments. Read both carefully - comments often contain important context, clarifications, or scope changes. Note any code references, linked PRs, or related tickets mentioned.

## Phase 2: Explore the Codebase

Before asking any questions, explore the codebase to build understanding:
- Look up any code references mentioned in the ticket
- Read relevant READMEs and documentation
- Examine existing patterns and implementations that relate to the work
- Follow README cascades - if one references another domain, read that too

Questions that can be answered by looking at documentation, code examples, or existing patterns should be answered through exploration, not by asking the user.

## Phase 3: Clarify Ambiguities

After exploration, use AskUserQuestion for any remaining uncertainties:
- Ambiguous requirements that the codebase doesn't clarify
- Design decisions with multiple valid approaches
- Business logic questions not documented anywhere
- Scope questions (what's in vs out)

Do NOT ask the user questions that could be answered by reading the codebase.

## Phase 4: Plan the Implementation

Use EnterPlanMode to create a detailed implementation plan. The plan should:
- Break down the work into concrete steps
- Identify files that will be modified or created
- Note any risks or considerations

Present the plan to the user for approval before proceeding.

## Phase 5: Implement

Only after the user approves the plan, begin implementation. Type check your changes before saying you're done.

---

Context:
- User: Evan Richards (evan@loop.com, ID: e88a31ed-fffc-46ea-8c89-f004af4e87a7)
- Team: AI Platform (ID: aac63dd9-6c68-452d-b699-71e3341023ec)
