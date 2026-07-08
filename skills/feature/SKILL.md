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

Shared conventions — directory layout, file ownership, task statuses, in-flight definition, feature numbering, branch and commit policy — live in `references/context-contract.md`; follow it rather than re-deriving.

</objective>

<process>

## 1. Check for an in-flight feature

```bash
ls -1 .context/features/ 2>/dev/null | sort
```

A feature is **in-flight** if:
- its directory exists but has neither a `CONTEXT.md` nor any task files yet (created, discussion not finished), or
- any task file under its `tasks/` has a `**Status:**` other than `done`, or
- it has a `CONTEXT.md` (a full-loop feature) and no `REVIEW.md` whose `Result:` line is `PASS`.

A quick-path feature (has `tasks/` but no `CONTEXT.md`) is done as soon as its tasks are all `done` — it never gets a `REVIEW.md`, so don't wait for one.

If the user named a specific feature (e.g. `/feature 003` or `/feature add-rate-limiting`), check only that one and report its status. Otherwise, check every feature directory and list all that are in-flight, each with its stage and next command:

- Only the directory exists → `/feature-discuss`
- `CONTEXT.md` exists, no `tasks/` yet → `/feature-plan`
- `tasks/` exists with any task not `done` → `/feature-execute`
- All tasks `done`, `CONTEXT.md` exists, no `REVIEW.md` with `Result: PASS` → `/feature-verify`

Stop here — don't proceed to classification — whenever there's anything in-flight to report, whether it's one feature or several.

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

## 3. Create the feature directory and branch

Before handing off, determine the next feature number (`.context/features/NNN-slug/`, zero-padded, incrementing from whatever already exists) and a short slug from the request.

**Full loop only** — the branch exists to give `feature-reviewer` a diff base, and fast-path features are never reviewed. When routing to `/feature-quick`, skip the branch and base SHA entirely; quick-path work happens directly on whatever branch the user is already on. When routing to the full loop:

```bash
git rev-parse HEAD
git checkout -b feature/NNN-slug
```

Record the commit from the first command as the feature's base SHA, then create and switch to the branch. Pass the feature path (and, full loop, the base SHA) to whichever next step runs — don't make each downstream skill re-derive them. `/feature-discuss` writes the SHA into `CONTEXT.md` as a `**Base:**` line.

</process>
