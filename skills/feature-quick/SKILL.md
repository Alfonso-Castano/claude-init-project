---
name: feature-quick
description: Fast path for a small, well-understood feature or fix. Skips discuss/plan/verify ceremony but still writes one task file and still requires evidence before claiming completion.
disable-model-invocation: true
allowed-tools: Bash, Agent, Read, Write
---

<runtime_note>
Explicit-invocation only (`/feature-quick`). Never auto-triggers.
</runtime_note>

<objective>

Handle a small task without the discuss → plan → execute → verify ceremony, while keeping two things the full loop has that are worth never skipping: a structured task record, and a hard evidence gate before claiming done.

Shared conventions — directory layout, file ownership, task statuses, in-flight definition, feature numbering, branch and commit policy — live in `references/context-contract.md` in the `feature` skill's directory (installed at `~/.claude/skills/feature/references/context-contract.md`); follow it rather than re-deriving.

</objective>

<process>

## 1. Confirm this belongs on the fast path

If you arrived here directly (not via `/feature`'s classification) and the task actually looks multi-file, ambiguous, or research-dependent, say so and suggest `/feature-discuss` instead. Don't silently proceed with a fast-path task that isn't one.

## 2. Determine dispatch shape

Run `orchestrator`'s Diagnose step mentally: at this size, it is almost always Single Session. If there's a clean, self-contained reason to spend a subagent (e.g., keeping exploratory output out of the main context), spawn exactly one — never more than one on the fast path.

## 3. Generate the dispatch prompt (if spawning a subagent)

If dispatching, use `prompt-engineer`'s calibration-by-size logic in its normal (non-task-file) mode — there's no task file yet at this stage, so `prompt-engineer` reasons from the request directly, calibrated as Trivial or Medium per its own sizing guide.

## 4. Do the work

Either the main session does it directly, or the dispatched subagent does, following whatever `prompt-engineer` produced.

## 5. Write the task record

```bash
mkdir -p .context/features/NNN-slug/tasks
```

Write a single file, `.context/features/NNN-slug/tasks/001-<slug>.md`, using the standard task template (see `feature-plan`'s `templates/task.md` for the shape) — filled in after the fact rather than planned in advance. This keeps a consistent, greppable record even for fast-path work, without the up-front planning cost.

## 6. Evidence gate — do not skip this step

Before saying anything is done, fixed, or passing:

1. Name the exact command that proves the claim (test run, build, lint — whatever applies to this change).
2. Run it fresh, in this turn. Do not rely on an earlier run or on a subagent's self-report.
3. Read the full output and check the exit code.
4. If the output does not support the claim, say so plainly and keep working — do not round up.
5. Only once the output confirms it: report the result, and quote the evidence (exit code, relevant output lines) alongside the claim.

Words like "should work," "this looks right," or "probably passes" are a signal you skipped a step — go back and run the command.

## 7. Close out

Mark the task file's status as done, with the evidence noted. Suggest — don't run — `/update-context` if this change is significant enough to be worth a `STATE.md` refresh.

</process>
