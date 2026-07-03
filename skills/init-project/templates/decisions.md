# DECISIONS.md Template

Template for `.context/DECISIONS.md` — a running log future sessions and future skills (e.g. a per-feature planning loop) append to over the project's life. Distinct from OVERVIEW.md's "Key Decisions" table, which only captures decisions made *during initialization*. This file is the one meant to keep growing.

<template>

```markdown
# Decisions Log

Running record of decisions that constrain future work. Newest first. Any future session or skill should check here before re-deciding something already settled.

## [YYYY-MM-DD] — [Short decision title]

**Decision:** [What was decided]
**Rationale:** [Why]
**Made during:** Project initialization
```

</template>

<guidelines>

**Seed it at initialization** with whatever decisions actually came up during the brain-dump/questioning conversation (technical preferences the user stated unprompted, explicit exclusions with reasoning, anything the user was firm about). Don't manufacture decisions that weren't actually made — an empty or near-empty DECISIONS.md at init time is normal and correct for a project where nothing beyond scope was decided yet.

**One entry per decision, newest first.** Keep entries short — this is a lookup table for "was this already decided," not a design document.

**This file is meant to be appended to later**, by whatever process handles individual features or phases after initialization. That's out of this skill's scope — its job here is just to create the file with an accurate seed, in the right shape for something else to extend later.

</guidelines>
