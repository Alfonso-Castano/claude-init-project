---
name: feature-discuss
description: Capture implementation decisions for a feature before planning begins — libraries, error handling, edge cases, scope boundary. First step of the full feature loop.
disable-model-invocation: true
allowed-tools: Bash, Read, Write
---

<runtime_note>
Explicit-invocation only (`/feature-discuss`). Never auto-triggers.
</runtime_note>

<objective>

Capture *how* to build the feature, not just *what* to build, before any planning happens. Planning cannot start on solid ground until these decisions exist. Output is `.context/features/NNN-slug/CONTEXT.md`.

</objective>

<process>

## 1. Ground yourself

```bash
cat .context/OVERVIEW.md 2>/dev/null
cat .context/STATE.md 2>/dev/null
```

Read only these two — not `research/`, not `DECISIONS.md` in full — unless the conversation surfaces a specific reason to check further. Keep this step cheap.

## 2. Scope check (borrowed from brainstorming's discipline)

Before asking anything else, ask yourself: does this request actually describe multiple independent features? (E.g., "add auth, billing, and an admin dashboard" is three features, not one.) If so, say this to the user directly and recommend running `/feature-discuss` separately for each, starting with the first. Don't spend the Q&A below refining a request that needs splitting first.

## 3. Lightweight Q&A — assumptions mode by default

Propose your best guess at the implementation decisions, and ask the user to confirm or correct, rather than open-ended interviewing — this is faster in the common case where your guesses are reasonable. Cover, as relevant:

- Libraries / dependencies to use or avoid
- Error-handling strategy for this feature
- Whether behavior is scoped narrowly or applies globally
- Edge cases worth deciding now rather than leaving to the planner's judgment
- Anything from `STATE.md` or `OVERVIEW.md` that constrains the approach

Ask one question (or one batch of proposed assumptions) at a time. If the user says "just use your judgment" on something, note that explicitly in the output rather than silently picking — the planner should be able to tell "decided by user" from "Claude's default judgment call" at a glance.

If the user prefers a fuller interview instead of assumptions-mode for this feature, switch — don't insist on the faster mode against their stated preference.

## 4. Write CONTEXT.md

```bash
mkdir -p .context/features/NNN-slug
```

```markdown
# Feature: <name>

## Goal
[One sentence — what this feature does]

## Scope
[What's in scope. What's explicitly out of scope, if it came up.]

## Implementation Decisions
- [Decision]: [what was decided, and who decided it — user or Claude's default judgment]
- ...

## Open Questions
[Anything explicitly deferred to the planner or executor's judgment]
```

## 5. Hand off

Tell the user the next command is `/feature-plan` (mention `--thorough` if this feature already looks like it needs real research — new ecosystem, unfamiliar library, etc. — so they can decide whether to pass it).

</process>
