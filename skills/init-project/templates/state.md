# STATE.md Template

Template for `.context/STATE.md` — the single file a future session with zero prior context should read first. Deliberately thin: no performance metrics, no velocity tracking (that's instrumentation for an execution loop that hasn't started yet at init time).

<template>

```markdown
# Project State

## Reference

See: .context/OVERVIEW.md
See: .context/ROADMAP.md (if this project has phases)

**Core value:** [One-liner copied from OVERVIEW.md's Core Value section]

## Current Position

Status: Initialized — ready to begin [Phase 1 name, or "the core value" if no roadmap]
Last activity: [YYYY-MM-DD] — Project initialized via /init-project

## Next Action

[One concrete sentence: what should happen next. E.g. "Start work on Phase 1: Core CLI" or, for a project with no roadmap, "Begin building toward the core value described in OVERVIEW.md."]
```

</template>

<guidelines>

**Why this file exists at all:** it's the one file a future session — yours, weeks from now, with a fully cleared context window — reads first to reorient. Everything else in `.context/` is detail this file points to.

**Keep it current, not historical.** This is not a changelog. When work happens later (outside this skill's scope), whatever process does that work should update Current Position and Next Action in place, not append to a growing log.

**No metrics.** Velocity, duration tracking, and progress bars are instrumentation for an active execution loop. At initialization time there's nothing to measure yet, and if a later workflow wants that instrumentation, it can add its own section — it doesn't belong in the one-time init template.

</guidelines>
