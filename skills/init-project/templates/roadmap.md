# ROADMAP.md Template

Template for `.context/ROADMAP.md` — only created if the project actually needs more than one phase to reach its core value. Adapted from GSD's `templates/roadmap.md` with the `Plans:` sub-breakdown and REQ-ID traceability removed (that level of detail belongs to whatever per-feature planning loop runs later, not to one-time initialization).

<when_to_skip>

If the project is small enough that "Core Value" from OVERVIEW.md can reasonably be reached in one push, don't create this file at all. A roadmap for a single-phase project is ceremony, not signal. Ask yourself: would a future session actually need phase boundaries to make sense of this, or is "build the thing" the whole plan? When in doubt, ask the user directly rather than defaulting to always-create.

</when_to_skip>

<template>

```markdown
# Roadmap: [Project Name]

## Overview

[One paragraph describing the journey from start to a working version.]

## Phases

- [ ] **Phase 1: [Name]** — [One-line description]
- [ ] **Phase 2: [Name]** — [One-line description]
- [ ] **Phase 3: [Name]** — [One-line description]

## Phase Details

### Phase 1: [Name]
**Goal:** [What this phase delivers — an outcome, not a task list]
**Depends on:** Nothing (first phase)
**Success Criteria** (what must be TRUE when this phase is done):
1. [Observable outcome]
2. [Observable outcome]

### Phase 2: [Name]
**Goal:** [What this phase delivers]
**Depends on:** Phase 1
**Success Criteria:**
1. [Observable outcome]
2. [Observable outcome]

[... continue for all phases ...]
```

</template>

<guidelines>

**Phase Goal:**
- State it as an outcome ("Users can securely access their accounts"), not a task ("Build authentication")
- This is what makes success criteria derivable — goal-backward, not forward task-listing

**Success Criteria:**
- 2-5 per phase, observable and verifiable by a human
- Not implementation tasks — things someone could check are true without reading code

**Depends on:**
- Real dependencies only. "Everything needs Phase 1" is a real dependency; "seemed like the natural order" is not

**Phase count:**
- Derived from the natural shape of the work, never padded to hit a number
- A phase with a single, thin, internal-quality goal ("refactor X", "add tests for Y") should usually be folded into a neighboring phase rather than standing alone

</guidelines>
