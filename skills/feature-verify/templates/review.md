# REVIEW.md Template

<template>

```markdown
# Review: <feature name>

## Task-level check
[For each task file: does the code match what the task specified? Any drift, noted per task.]

## Decision coverage
[For each decision in CONTEXT.md: was it actually implemented? Call out any that were quietly dropped or changed.]

## Goal alignment
[Does the feature, taken as a whole, do what the original one-sentence goal in CONTEXT.md said it would?]

## Evidence
[The exact verification command(s) run in this review pass, and their actual output/exit codes. Not a summary of an earlier run — run fresh, in this pass.]

## Result
PASS | FAIL — fix tasks generated: [list, if any]
```

</template>

<guidelines>

**Evidence is not optional and not retrospective.** If you're about to write PASS, you must have just run the verification command in this same review pass and read its output. "The executor said it passed" is not evidence — check the diff and the test output yourself.

**A fix on FAIL is a new task file, not a rewrite of history.** Generate `.context/features/NNN-slug/tasks/NNN-fix-<slug>.md` in the same format as any other task, and route back to `/feature-execute` for just that task — don't re-run the whole feature.

</guidelines>
