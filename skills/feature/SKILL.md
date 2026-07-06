---
name: feature
description: Entry point for building a feature. Classifies scope and routes to the fast path or the full discuss/plan/execute/verify loop. Also reports status on an in-flight feature.
disable-model-invocation: true
allowed-tools: Bash, Read
---

<runtime_note>
Explicit-invocation only (`/feature`). Never auto-triggers on conversational cues, matching `/init-project` and `/update-context`.
</runtime_note>

<objective>

This is the router for the One Big Feature Workflow. It does not do design, planning, or execution itself — it decides which of those to start, or reports where an in-progress feature currently stands.

</objective>

<process>

## 1. Check for an in-flight feature

```bash
ls -1 .context/features/ 2>/dev/null | sort
```

If the user named a specific feature (e.g. `/feature 003` or `/feature add-rate-limiting`), or if exactly one feature directory has no `REVIEW.md` yet, report its status: which of `CONTEXT.md` / `tasks/` / `REVIEW.md` exist, and name the next command to run (`/feature-discuss`, `/feature-plan`, `/feature-execute`, or `/feature-verify`). Stop here — don't proceed to classification.

If `.context/` doesn't exist at all, say so and point to `/init-project`. This workflow assumes a project already has `.context/OVERVIEW.md` and `.context/STATE.md`.

## 2. Classify a new request

Ask the user what they want to build if they haven't said, then classify without spawning any subagent — this is a judgment call, not research:

**Fast path** if the request:
- Can be fully specified in this one exchange, with no further research needed, AND
- Touches one file, or a small, obviously-bounded set of files

**Full loop** otherwise — including any case where you're not sure. A wrongly-escalated small task costs a few minutes of unneeded ceremony. A wrongly-fast-tracked large task costs a broken feature and rework. Default to the full loop when in doubt.

State which path you're taking and why, in one sentence. Then:

- Fast path → tell the user to run `/feature-quick`, or just proceed into it directly if they've already indicated they want you to.
- Full loop → tell the user to run `/feature-discuss`, or proceed into it directly if they've already indicated they want you to.

## 3. Create the feature directory

Before handing off, determine the next feature number (`.context/features/NNN-slug/`, zero-padded, incrementing from whatever already exists) and a short slug from the request. Pass this path to whichever next step runs — don't make each downstream skill re-derive it.

</process>
