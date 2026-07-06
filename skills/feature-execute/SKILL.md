---
name: feature-execute
description: Run the task files produced by /feature-plan, one fresh-context executor subagent per task (or wave), one commit per completed task. Third step of the full feature loop.
disable-model-invocation: true
allowed-tools: Bash, Agent, Read
---

<runtime_note>
Explicit-invocation only (`/feature-execute`). Never auto-triggers.
</runtime_note>

<objective>

Execute the plan without letting this session's context absorb the actual work. Each task gets a fresh, cleanly-scoped subagent; nothing accumulates in the main session beyond a thin status ledger.

</objective>

<process>

## 1. Setup check

Confirm `.context/features/NNN-slug/tasks/*.md` exists. Stop and point to `/feature-plan` if not.

## 2. For each wave (per the parallelization shape `/feature-plan` determined)

For every task in the wave:

### a. Generate the dispatch prompt via prompt-engineer, Task-file mode

`prompt-engineer` reads the task file directly — the file already answers what/where/why/constraints/verification, so this is a transcription-and-formatting pass, not a from-scratch reasoning pass. Its job here is specifically:

- Transcribe the task file's content into the standard dispatch structure
- Select the model tier per the task file's own `Model tier` field — never leave it to inherit the parent session's model
- Add anything the task file assumes but doesn't restate explicitly (e.g., a project-wide convention from `CONTEXT.md`'s Global Constraints, if the task file didn't repeat it)

### b. Dispatch

Spawn the `feature-executor` subagent (`~/.claude/agents/feature-executor.md`) with: the generated prompt, the task file, and nothing else from this session's history. Fresh context, every time — this is the anti-context-rot mechanism and it is not optional.

### c. Handle the result

The executor reports one of: **DONE** (with evidence — see the agent file), **BLOCKED** (missing information, needs a decision), or **FAILED** (attempted but verification didn't pass).

- **DONE:** commit (one commit per task), mark the task file's status, move to the next task in the wave.
- **BLOCKED:** stop and ask the user — don't guess at the missing decision yourself.
- **FAILED:** do not immediately re-dispatch with "try again." Apply root-cause-first triage before any second attempt:
  1. What's the actual observed failure (exact error, exact output) — not a guess at what's wrong.
  2. What's the root cause, not just the symptom being patched.
  3. Does the fix fit within the existing task's scope, or does it reveal the task itself was mis-scoped by the planner? If a task has failed three times, stop re-patching and reconsider whether the task's design is wrong, not just its execution — send it back to `/feature-plan` for that one task rather than continuing to force it.

## 3. Wait for wave completion before starting the next

Don't start a dependent wave until every task in the prior wave is DONE — that's what "dependent" means. Independent waves can run concurrently if the harness supports it.

## 4. Hand off

Once all tasks are DONE, tell the user the next command is `/feature-verify`.

</process>
