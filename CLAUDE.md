# CLAUDE.md — [Project Name]

[One-line tagline — org / personal project / internship, etc.]

<!--
  This is Alfonso's foundational CLAUDE.md, built from the Claude Code
  Optimization project (project init, context/memory management, and the
  one-big-feature workflow). Copy this into a new project's root, then:
    1. Fill in the bracketed placeholders above and in "Architecture Quick
       Reference" at the bottom — everything else below is meant to work
       unchanged across every project.
    2. Run /init-project if .context/ doesn't exist yet.
  HTML comments like this one are stripped before Claude ever reads this
  file, so they're free to use for your own reminders.
-->

@.context/OVERVIEW.md @.context/STATE.md @.context/DECISIONS.md @.context/ROADMAP.md

Full context lives in `.context/` (created by `/init-project`) and is auto-loaded above. Read it before doing anything else — this file is the protocol layer, `.context/OVERVIEW.md` is the actual project description.

---

## Session Protocol

**Starting a session**
- If `.context/` doesn't exist yet, run `/init-project` first — everything below assumes it does.
- OVERVIEW.md, STATE.md, and DECISIONS.md (and ROADMAP.md, if present) are auto-loaded via the `@imports` above — read them before touching anything.
- Native Auto Memory loads automatically alongside them; no action needed.
- If STATE.md looks stale relative to recent git activity, run `/update-context` before proceeding.
- Confirm your understanding of the current task before touching any code.

**Mid-session**
- Run `/update-context` anytime it'd help — a natural pause, a decision just got made, or before you'd lose your own thread. It's safe to run mid-task.
- Run `/compact` when context feels heavy — don't wait until it's bloated.
- If something goes sideways, STOP and re-plan immediately. Don't keep pushing on a plan that's already wrong.

**Ending a session**
- Run `/update-context` before you stop. This is manual and deliberate — there is no automatic hook doing it for you, by design.

---

## Building a Feature

For any new feature or non-trivial fix, start with `/feature` and describe what you want built. It classifies the request and tells you what runs next:

| Path | When | Commands |
|---|---|---|
| Fast path | Small, single-file, well-understood | `/feature-quick` |
| Full loop | Everything else, or any real uncertainty | `/feature-discuss` → `/feature-plan` (add `--thorough` for unfamiliar territory) → `/feature-execute` → `/feature-verify` |

Each stage writes to `.context/features/NNN-slug/` and tells you the next command — don't skip ahead. Every command here is explicit-invocation only; none fire on their own. Both paths end with a hard evidence gate before anything is called done (see **Verification Before Done** below) — this isn't optional ceremony, it's built into `/feature-quick` and `/feature-verify` directly.

On PASS, `/feature-verify` refreshes `.context/` itself as an announced final step — no separate `/update-context` needed for that event. Run `/update-context` manually for every other occasion.

---

## Subagent Strategy

Whenever scope is ambiguous, invoke the **`orchestrator`** skill and stop at the lowest rung of its ladder that works (single session → subagents → agent teams) — this applies to any task, not just `/feature-*` work.

Generate every dispatch prompt via **`prompt-engineer`** (task-file mode when a task file exists, from-scratch mode otherwise) — it owns the tier→model mapping. Every dispatch states an explicit model tier; never let a subagent silently inherit the most expensive model available.

---

## Working Style

- **Plan before building.** Anything with real architectural weight or 3+ steps: use `/feature-discuss` and `/feature-plan`, don't just start editing. Genuinely simple, obvious tasks: skip the ceremony and execute directly.
- **Fix bugs autonomously.** Given a bug report, diagnose from the actual logs/errors/failing tests and fix it — don't ask for hand-holding. One reasonable attempt informed by the real error; if it fails again, stop and reconsider the root cause rather than re-patching the symptom a third time.
- **Demand elegance, in balance.** For non-trivial changes, pause and ask "is there a more elegant way?" If a fix feels hacky, ask "knowing everything I know now, what's the clean solution?" Skip this for simple, obvious fixes — don't over-engineer what doesn't need it.
- **Minimal impact.** Touch only what the current task needs. Don't refactor things that aren't broken. One change at a time — keep problems easy to isolate.

---

## Verification Before Done

Never mark anything complete without fresh evidence from this turn: name the exact command that proves the claim, run it now, read the output and exit code — "should work" means you skipped a step.

This is a hard, mechanized gate inside `/feature-quick` and `/feature-verify` — see those skills for exactly how it's enforced.

---

## Token Efficiency

- Read specific files, not whole directories, unless a full scan is genuinely needed.
- Don't dump full file contents back into responses — summarize findings.
- Ask targeted questions, not broad exploratory ones.
- For simple tasks, skip planning ceremony entirely and go straight to `/feature-quick`.
- `STATE.md` is a snapshot, overwritten in place by `/update-context` — never let it grow into a log.
- `.context/research/` is read once at init and never re-read automatically — treat it as reference, not a recurring cost.
- Native Auto Memory already handles small recurring operational notes (build quirks, debugging fixes, inferred preferences) for free in the background — don't duplicate that inside `.context/` files, and don't ask about it explicitly.
- Every subagent dispatch carries an explicit model tier — see **Subagent Strategy** above.

---

## Honesty and Pushback

- If an idea has a gap, a redundancy, or a clearly better alternative exists, say so plainly before proceeding. Agreement for its own sake is not helpful here.
- No guessing — if something is genuinely unclear, ask rather than assume, and say explicitly when you're stating an assumption versus reporting a fact.
- Never round up a completion claim — see **Verification Before Done**.
- Auto Memory handles day-to-day self-correction automatically now; there's no manual lessons/mistakes log to maintain on top of it.

---

## Core Principles

- **Simplicity first** — make every change as simple as possible.
- **No laziness** — find root causes; no temporary fixes; senior-developer standards.
- **Minimal impact** — changes touch only what's necessary.

---

## Architecture Quick Reference

<!--
  Fill this in per project, once /init-project (and any research phase) is
  done — pull from .context/OVERVIEW.md and .context/research/ARCHITECTURE.md
  if it exists. Keep this to a skimmable diagram plus a handful of key file
  pointers. It's a map, not a full architecture doc — that's what OVERVIEW.md
  and research/ are for.
-->

[Per-project architecture summary goes here]
