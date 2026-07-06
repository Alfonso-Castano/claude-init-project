---
name: prompt-engineer
description: Generate self-contained, agent-ready prompts for delegating work to fresh Claude sessions or sub-agents. Use whenever you need to hand off a task (fix, feature, debug, refactor) to another agent that has no prior context. Also use when crafting sub-agent prompts within workflows, or when any skill/workflow needs a high-quality delegation prompt. Trigger on: "generate a prompt for", "write a prompt to", "hand this off to another agent", "create a fix prompt", or any context where work must be delegated to a fresh agent with zero shared context.
---

# Prompt Engineer

Generate prompts that let a fresh agent act without back-and-forth. Every prompt you produce must be self-contained — the receiving agent has zero context from this conversation.

## Which mode applies

Check first: is there already a structured task file behind this delegation (e.g. from `/feature-plan`'s task decomposition)? If yes, use **Task-file mode** below — it's cheaper and more accurate than reasoning from scratch. If no structured task file exists — an ad-hoc delegation, a fast-path task, or a request from outside the feature workflow entirely — use the **From-scratch mode** that follows it.

## Task-file mode

When a task file already exists, most of the five core questions are already answered in it:

| Question | Where it already lives in the task file |
|---|---|
| What | "What to do" section |
| Where | "Files" section |
| Why | The feature's `CONTEXT.md`, referenced by the task |
| Constraints | "Constraints" section |
| Verification | "Verification" section |

Your job shrinks to three things:

1. **Transcribe** the task file's content into the standard dispatch prompt structure below — don't re-derive or re-word what's already precise; copy exact paths, exact commands, exact interface names as written.
2. **Select the model tier** from the task file's own `Model tier` field. Never omit this and never let it default to inheriting the parent session's model — an omitted model silently uses the most capable and most expensive option, which defeats the entire point of tiering. If the task file says `cheap`, the task's "What to do" should already contain complete, specific code — the implementer's job is transcription plus verification, not judgment. If `mid`, the implementer needs to apply judgment to a prose description. Reserve `quality` for tasks the planner explicitly flagged as architecturally significant.
3. **Add anything assumed but not restated.** If the task file relies on a project-wide convention from the feature's `CONTEXT.md` (a Global Constraints line, an established pattern) without repeating it verbatim, add it explicitly here — the receiving subagent won't see `CONTEXT.md`, only what you hand it.

Do not re-litigate the task's scope or re-interview for missing information in this mode — if the task file is genuinely ambiguous, that's a planning-quality problem to flag back to `/feature-plan`, not something to paper over with your own guesses here.

## From-scratch mode

Use this when no structured task file exists. A good delegation prompt answers five questions for the receiving agent:
1. **What** — the specific outcome expected
2. **Where** — exact file paths, line numbers, or components involved
3. **Why** — enough context to make judgment calls (not just follow instructions)
4. **Constraints** — what must NOT change, what to avoid, boundaries
5. **Verification** — how the agent confirms it worked

If any of these are missing, the receiving agent will either ask questions (wasting time) or guess wrong (creating bugs).

## Prompt Structure

Use this structure for all delegation prompts, in either mode. Adapt section depth to task complexity — a one-line label fix needs less than a navigation flow rewrite.

```
## Context
[1-3 sentences: what the project is, what area of code this touches, why this matters]

## The Problem
[What's wrong or what's needed. Be specific and observable — "the category label is missing below supplement icons in StackView" not "labels are broken"]

## Files Involved
[Exact paths. If you know line numbers, include them. If uncertain, say which file to search in and what to search for]

## What to Do
[Step-by-step if multi-step, or a clear single instruction. Include the expected end state]

## Constraints
[What NOT to change. Adjacent features to leave alone. Patterns to follow. Design system tokens to use. Architecture to respect]

## Verification
[How to confirm the fix works — build command, what to check in simulator, expected behavior]

## Model
[Explicit tier or model ID — never left to inherit]

## Attachments
[Note any screenshots, error logs, or reference files being provided alongside this prompt]
```

## Calibration by Task Size (from-scratch mode)

### Trivial Fix (missing label, wrong color, typo)
- Context: 1 sentence
- Problem: 1 sentence with exact location
- Files: 1-2 paths
- What to Do: single clear instruction
- Constraints: 1 line ("don't change layout")
- Verification: "build and confirm X appears"
- Model: cheap tier
- Total: ~8-12 lines

### Medium Fix (add tap navigation, wire up data binding, fix a flow)
- Context: 2-3 sentences covering the feature area
- Problem: describe current vs expected behavior
- Files: 2-5 paths with relationships explained
- What to Do: numbered steps
- Constraints: adjacent features, architectural patterns
- Verification: specific user flow to test
- Model: mid tier unless the steps already fully specify the code
- Total: ~20-40 lines

### Large Task (new feature, significant refactor)
- Context: full paragraph on the system and motivation
- Problem: detailed gap analysis
- Files: file tree of relevant area + key patterns to follow
- What to Do: phased approach with intermediate checkpoints
- Constraints: comprehensive (design system, architecture, existing tests)
- Verification: multiple scenarios including edge cases
- Model: quality tier, or split into smaller task-file-mode delegations instead — a task this large is usually a sign it should go through `/feature-plan` rather than a single from-scratch prompt
- Total: ~50-80 lines

## Sub-Agent Prompts

When crafting prompts for sub-agents spawned within a workflow (not fresh sessions):

- Sub-agents inherit some context from parent but not conversation history
- Be explicit about what the sub-agent should return (format, length, structure)
- Include the specific question or task — don't rely on ambient context
- Specify whether the sub-agent should write code or just research/analyze
- Always specify the model explicitly — see Task-file mode above for how this is decided when a task file exists

## Anti-Patterns

Avoid these — they produce prompts that fail:

| Anti-Pattern | Why It Fails | Fix |
|---|---|---|
| "Fix the bug" | No specifics — agent has to explore blindly | Name the exact symptom and location |
| Assuming shared context | Fresh agent knows nothing about prior work | State everything explicitly |
| Vague verification | "Make sure it works" — how? | Specific observable outcome |
| Over-specifying implementation | Leaves no room for judgment on approach | Describe the outcome, not every keystep |
| Missing constraints | Agent "fixes" one thing and breaks another | Name what must not change |
| No file paths | Agent wastes time finding the right files | Anchor with exact paths |
| Omitted model tier | Silently inherits the most expensive model | Always state it explicitly, from the task file if one exists |
