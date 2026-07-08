# Task Template

Template for a single file under `.context/features/NNN-slug/tasks/NNN-<slug>.md`. One file per task — never a monolithic plan doc.

<template>

```markdown
# Task NNN: [Short name]

**Status:** pending | in-progress | done | blocked
**Depends on:** [task numbers this must wait for, or "none"]
**Model tier:** cheap | mid | quality — [one line: why this tier fits this task]

## Files
- Create: `exact/path/to/file.ext`
- Modify: `exact/path/to/existing.ext` [:line-range if known]
- Test: `exact/path/to/test.ext`

## What to do
[Specific, observable outcome. If the plan already worked out the exact code, include it here — that's what makes this a "cheap tier" task: transcription plus testing, not judgment.]

## Interfaces
- Consumes: [what this task uses from earlier tasks — exact names/signatures]
- Produces: [what later tasks rely on from this one]

## Constraints
[What must NOT change. Adjacent code to leave alone.]

## Verification
[Exact command to run, and what output confirms success]

## Evidence
[Filled in at completion: the command actually run, its output/exit code, and the date]
```

</template>

<guidelines>

**Model tier is decided at planning time, not execution time.** If the task's "What to do" section already contains the complete code, mark it `cheap` — the executor's job is transcription plus verification. If it requires judgment from a prose description (an approach to figure out, not just apply), mark it `mid`. Reserve `quality` for tasks with real architectural weight. Never leave this blank — an executor subagent that isn't told a tier explicitly inherits whatever model is running the parent session, which is usually the most expensive one and defeats the point of tiering.

**Depends on drives wave grouping.** Tasks with no shared dependencies, and no dependency on each other, can run in the same parallel wave. `orchestrator`'s decomposition step uses this field directly — keep it accurate, not optimistic. Two tasks that touch the same file are not independent even if neither formally depends on the other.

**Evidence gets filled in at completion, not at planning.** Leave it blank when the task file is written; `/feature-execute`'s main session fills it in from the executor's report, after the executor actually ran the verification command in that turn.

</guidelines>
