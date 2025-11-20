---
description: Create a Linear ticket
argument-hint: [ticket-description]
---

Create a Linear ticket for the AI Platform team.

If $ARGUMENTS is provided: Create the ticket immediately with the provided description.
If $ARGUMENTS is empty: Brainstorm and refine the ticket details with the user before creating it in Linear.

Context:
- User: Evan Richards (evan@loop.com, ID: e88a31ed-fffc-46ea-8c89-f004af4e87a7)
- Team: AI Platform (ID: aac63dd9-6c68-452d-b699-71e3341023ec)

Remember that Linear tickets are standalone documents without chat context. Only include relevant details in the ticket, not the entire brainstorming discussion.

When referencing code in the ticket, include relevant GitHub links when possible.

CRITICAL - Ticket Content Rules:
- Keep tickets focused on WHAT needs to be done and WHY
- Limit emoji usage

NEVER INCLUDE THESE SECTIONS (unless explicitly requested):
- NO "Success Criteria" or "Acceptance Criteria"
- NO "Testing Considerations" or "Test Plan"
- NO "Productionization Considerations"
- NO "Future Work" or "Future Considerations"
- NO time estimates or effort estimates
- NO "Monitoring" or "Observability"
- NO "Rollout Plan" or "Deployment Strategy"

If you find yourself writing any forbidden section, STOP and remove it immediately.
The ticket describes the work to be done, not how to validate or deploy it.
