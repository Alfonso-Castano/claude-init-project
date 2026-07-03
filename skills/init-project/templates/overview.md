# OVERVIEW.md Template

Template for `.context/OVERVIEW.md` — the living project context document. Adapted from GSD's `templates/project.md`, with REQ-ID formalism dropped (no execute/verify loop consumes it here).

<template>

```markdown
# [Project Name]

## What This Is

[Current accurate description — 2-3 sentences. What does this thing do and who is it for?
Use the user's language and framing. Update whenever reality drifts from this description.]

## Core Value

[The ONE thing that matters most. If everything else fails, this must work.
One sentence that drives prioritization when tradeoffs arise.]

## Scope

### In Scope

- [Capability or feature the user described]
- [Capability or feature the user described]

### Explicitly Out of Scope

<!-- Boundaries the user stated, or that emerged from the scope check. Always include the reasoning — prevents re-litigating later. -->

- [Exclusion] — [why]

## Context

[Background information that informs future work:
- Relevant prior work, experience, or existing assets
- Domain-specific things a future session needs to know
- Known constraints or considerations the user raised]

## Constraints

- **[Type]**: [What] — [Why]

Common types: Budget, Timeline, Tech/tooling preference, Dependencies, Compatibility

## Key Decisions

<!-- Decisions made during initialization that constrain future work. -->

| Decision | Rationale |
|----------|-----------|
| [Choice] | [Why] |

---
*Initialized: [date]*
```

</template>

<guidelines>

**What This Is:**
- Current accurate description of the thing being built
- 2-3 sentences, in the user's words and framing
- Not a marketing pitch — a plain statement of what it is

**Core Value:**
- The single most important thing
- Everything else can slip; this cannot
- Drives prioritization when tradeoffs arise later

**Scope — In Scope / Out of Scope:**
- Both come from the conversation, not from Claude inventing boundaries
- Out of Scope always includes reasoning — the point is to prevent the same idea getting re-litigated in a future session with no memory of why it was cut

**Context:**
- Background that informs how future work should approach this
- Prior work, domain specifics, things the user assumed Claude would "just know"

**Constraints:**
- Hard limits — include the "why," since constraints without rationale get questioned and re-argued later

**Key Decisions:**
- Only decisions actually made during this initialization conversation
- Not a running log to append to forever — if this project accumulates ongoing decisions, that's what `DECISIONS.md` is for

</guidelines>

<brownfield_note>

If the user is initializing context for something that already partially exists (not a from-scratch idea), ask what already exists and reflects it in "What This Is" and Context rather than treating it as pure greenfield. Full codebase-mapping (à la GSD's `/gsd:map-codebase`) is out of scope for this skill — if that level of existing-code analysis is needed, that's a separate concern from a one-time context initialization.

</brownfield_note>
