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

Shared conventions — directory layout, file ownership, task statuses, in-flight definition, feature numbering, branch and commit policy — live in `references/context-contract.md` in the `feature` skill's directory (installed at `~/.claude/skills/feature/references/context-contract.md`); follow it rather than re-deriving.

</objective>

<process>

## 1. Setup check

Confirm all task files under `.context/features/NNN-slug/tasks/` are marked `done`. If any are still `pending`/`blocked`/`failed`, stop and point back to `/feature-execute`.

## 2. Spawn the reviewer

Dispatch the `feature-reviewer` subagent (`~/.claude/agents/feature-reviewer.md`) with a fresh context containing: `CONTEXT.md`, every task file, and the **Base SHA** from CONTEXT.md's `**Base:**` line. Do not read or paste the diff in the main session — that defeats the context-isolation this workflow is built around. The reviewer runs `git diff <base>..HEAD` itself, in its own context, to get the real diff. One merged pass covering:

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

If this is the second FAIL for the same root cause, stop generating fix tasks — a second failure on the same discrepancy means the decomposition is likely wrong, not that the fix needs another pass. Route back to `/feature-plan` instead, or to the user, rather than starting a third fix loop.

## 5. On PASS

Write `REVIEW.md` using the template. Tell the user the feature is complete, and suggest merging `feature/NNN-slug` back to main. Then, as an announced final step — tell the user "Feature passed — refreshing .context/ now" — spawn the `context-updater` subagent (`~/.claude/agents/context-updater.md`) directly to refresh `.context/`. No context write ever happens from an ambient trigger — only as part of a command the user explicitly ran; `/feature-verify` is such a command, so running it here is not an ambient trigger.

</process>
