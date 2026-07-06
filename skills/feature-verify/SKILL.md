---
name: feature-verify
description: Single merged review pass (spec compliance + code quality + goal alignment) plus a hard evidence gate before the feature can be marked done. Fourth step of the full feature loop.
disable-model-invocation: true
allowed-tools: Bash, Agent, Read, Write
---

<runtime_note>
Explicit-invocation only (`/feature-verify`). Never auto-triggers.
</runtime_note>

<objective>

Check that what was built matches what was planned, and what was planned matches what was decided — in one pass, not three separate stages. Then apply a hard evidence gate before anything is reported as done. Output: `.context/features/NNN-slug/REVIEW.md`.

</objective>

<process>

## 1. Setup check

Confirm all task files under `.context/features/NNN-slug/tasks/` are marked `done`. If any are still `pending`/`blocked`/`failed`, stop and point back to `/feature-execute`.

## 2. Spawn the reviewer

Dispatch the `feature-reviewer` subagent (`~/.claude/agents/feature-reviewer.md`) with a fresh context containing: `CONTEXT.md`, every task file, and the actual diff since the feature branch started (not a description of the diff — the real diff). One merged pass covering:

- **Task-level check** — does the code match each task's spec
- **Decision coverage** — was everything in `CONTEXT.md`'s Implementation Decisions actually implemented
- **Goal alignment** — does the feature as a whole satisfy the one-sentence goal

Do this as a single pass, not three separate subagent round-trips — that consolidation is the specific thing being adopted here rather than running plan-check, verify, and code-review as separate stages.

## 3. Evidence gate — this is the literal completion check, not an add-on

Before the reviewer (or you) can write PASS in `REVIEW.md`:

1. Identify the exact command that proves the feature works (test suite, build, lint, whatever applies).
2. Run it fresh, in this review pass. A task executor's earlier "tests pass" report is not sufficient on its own — confirm it yourself, now.
3. Read the full output and exit code.
4. If it doesn't support a PASS claim, it isn't a PASS — write FAIL with the actual state, and generate fix tasks (see below). Do not round up language like "should be fine" or "looks correct" — either you have fresh evidence or you don't.
5. Only with fresh, confirming evidence: write PASS, with the evidence quoted in `REVIEW.md`.

## 4. On FAIL

Generate one task file per discrepancy, in the normal task-file format, under `tasks/`, numbered to continue the existing sequence. Route back to `/feature-execute` — only for the new fix tasks, not the whole feature again.

## 5. On PASS

Write `REVIEW.md` using the template. Tell the user the feature is complete, and suggest — don't run — `/update-context`, since a shipped feature is exactly the kind of event that command exists to capture. This workflow never invokes another skill's write path on the user's behalf.

</process>
