---
name: feature-plan
description: Research (conditionally) and decompose an approved feature into per-task files. Second step of the full feature loop. Supports --thorough for a fuller research pass on unfamiliar or high-risk work.
disable-model-invocation: true
allowed-tools: Bash, Agent, Read
---

<runtime_note>
Explicit-invocation only (`/feature-plan`). Never auto-triggers. Accepts an optional `--thorough` flag.
</runtime_note>

<objective>

Turn `CONTEXT.md` into a set of small, dependency-ordered task files that an executor can pick up with no further ambiguity. This is the step where ambiguity is most expensive — an unclear task produces an executor that guesses, and two executors guessing differently about the same concern produce conflicts.

Shared conventions — directory layout, file ownership, task statuses, in-flight definition, feature numbering, branch and commit policy — live in `references/context-contract.md` in the `feature` skill's directory (installed at `~/.claude/skills/feature/references/context-contract.md`); follow it rather than re-deriving.

</objective>

<process>

## 1. Setup check

```bash
if [ ! -f .context/features/NNN-slug/CONTEXT.md ]; then
  echo "NO_CONTEXT — run /feature-discuss first"
fi
```

Stop if `CONTEXT.md` doesn't exist. Don't guess at decisions that step is supposed to have already captured.

## 2. Spawn the planner

Dispatch the `feature-planner` subagent (defined in `~/.claude/agents/feature-planner.md`) with a fresh context window containing: `CONTEXT.md`, `.context/OVERVIEW.md`, and whether `--thorough` was passed.

Do not read the codebase or research anything yourself in this conversation — that's the planner's job, in its own isolated context, so this session's context budget isn't spent on it.

**Without `--thorough`:** the planner decides for itself, in the same pass, whether it needs to investigate anything before decomposing. If the domain is already well-understood from the codebase and `CONTEXT.md`, it skips straight to writing task files. If not, it does the minimum research needed inline and records only what mattered in `RESEARCH.md` — this collapses what would otherwise be a separate researcher round-trip into the one planning pass, for the common case.

**With `--thorough`:** the planner always does a dedicated research pass first, writes a fuller `RESEARCH.md`, and only then decomposes. Reach for this on unfamiliar libraries, new integrations, or anything where getting the ecosystem wrong would be expensive to unwind later.

## 3. Review the output

The planner returns: whether it researched anything, and the list of task files it wrote under `.context/features/NNN-slug/tasks/`. Skim the task list yourself for one thing specifically: do any two tasks touch the same file without a dependency between them? That's a conflict waiting to happen — send it back to the planner to resolve before moving on.

## 4. Determine parallelization shape

Run `orchestrator`'s Diagnose and Decompose steps against the task list that just came back:

- Independent tasks with non-overlapping file ownership → subagents, grouped into waves by the `Depends on` field
- Tightly sequential, small task count → may be fine as a single session
- Only escalate to an agent team if tasks genuinely need to message each other mid-task — this should be rare for a single feature

State which shape applies and why, in a sentence, before handing off.

## 5. Hand off

Tell the user the next command is `/feature-execute`.

</process>
