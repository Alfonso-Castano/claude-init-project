# The `.context/` Contract

The shared filesystem contract every feature-workflow skill and agent relies
on instead of re-deriving. If a skill's own file is more detailed than this
on some point, the skill's file wins — this is a summary, not a superset.

<directory_layout>

Top level (created by `/init-project`, maintained by `/update-context`):

```
.context/
  OVERVIEW.md    # always — static after init, edited only on a genuine scope change
  STATE.md       # always — thin snapshot, overwritten in place, never a log
  DECISIONS.md   # always — append-only log
  ROADMAP.md     # only if the project needs phases
  research/      # only if research was accepted at init — static, never rewritten
  features/
    NNN-slug/
      CONTEXT.md       # full-loop only — from /feature-discuss
      RESEARCH.md      # optional — from /feature-plan, only if research happened
      tasks/
        NNN-*.md       # one file per task, never a monolithic plan doc
      REVIEW.md        # full-loop only — from /feature-verify
```

A quick-path feature (`/feature-quick`) has `tasks/` but no `CONTEXT.md` and
never gets a `REVIEW.md`.

</directory_layout>

<file_ownership>

- `/init-project` — creates OVERVIEW.md, DECISIONS.md, STATE.md always;
  research/ and ROADMAP.md conditionally. One-time. Commits once at the end.
- `context-updater` (via `/update-context`) — the only writer of STATE.md
  updates (overwrite in place) and the only appender to DECISIONS.md.
  Updates ROADMAP.md only on a phase transition, if it exists. Never touches
  OVERVIEW.md or research/ except in the rare case of a genuine scope change,
  which it must call out explicitly. Commits its own changes.
- `/feature` — creates the feature directory (step 3) when handing off from
  classification, plus the branch for full-loop features only (see
  `<branch_convention>`).
- `/feature-discuss` — writes CONTEXT.md; creates the feature directory and
  branch itself if invoked directly and neither exists yet.
- `feature-planner` (via `/feature-plan`) — writes RESEARCH.md (conditionally)
  and all files under `tasks/`.
- `feature-executor` (via `/feature-execute`) — writes only the code the task
  specifies. Never touches `.context/` and never commits.
- `/feature-execute`'s main session — after each executor reports DONE,
  updates that task file's Status/Evidence and owns the commit.
- `feature-reviewer` (via `/feature-verify`) — writes REVIEW.md and, on FAIL,
  new fix task files under `tasks/`.
- `/feature-quick` — writes a single task file directly (filled in after the
  fact), no CONTEXT.md, no RESEARCH.md, no REVIEW.md.
- OVERVIEW.md and research/ are static: written once, read many times, never
  routinely rewritten.

</file_ownership>

<task_status_vocabulary>

`pending | in-progress | done | blocked` — the only values a task file's
`**Status:**` line may hold (see `feature-plan/templates/task.md`).

</task_status_vocabulary>

<in_flight_definition>

A feature is **in-flight** if:
- its directory exists but has neither a `CONTEXT.md` nor any task files
  yet (created, discussion not finished), or
- any task file under its `tasks/` has a `**Status:**` other than `done`, or
- it has a `CONTEXT.md` (full-loop) and no `REVIEW.md` whose `Result:` line
  is `PASS`.

A quick-path feature (`tasks/` but no `CONTEXT.md`) is done as soon as all
its tasks are `done` — it never gets a `REVIEW.md`, so don't wait for one.

</in_flight_definition>

<feature_numbering>

Feature directories are `NNN-slug`, zero-padded to 3 digits, incrementing
from whatever the highest existing `NNN` already is.

**Active-feature resolution when a skill is invoked directly** (no feature
path handed down from `/feature` or a prior stage): the active feature is
the highest-numbered **in-flight** directory under `.context/features/`.
Creating a brand-new feature means incrementing the highest existing `NNN`
regardless of whether it's in-flight or done.

Task files inside a feature follow the same zero-padded sequence
(`tasks/NNN-<slug>.md`); fix tasks generated on a FAIL continue that same
sequence rather than starting a new one.

</feature_numbering>

<branch_convention>

Each **full-loop** feature gets its own branch, `feature/NNN-slug`, created
at feature start — normally by `/feature`'s step 3, or by `/feature-discuss`
itself as a fallback when invoked directly and no branch exists yet. The
pre-branch `HEAD` is recorded as a `**Base:**` line in `CONTEXT.md`.
`feature-reviewer` diffs `<base>..HEAD` to get the real diff. On `PASS`, the
user is told to merge the branch back to main.

Quick-path features (`/feature-quick`) get **no branch** — they are never
reviewed, so there is no diff base to preserve; the work happens directly on
whatever branch the user is already on.

</branch_convention>

<commit_policy>

- `/init-project` commits `.context/` once at the end:
  `chore(context): initialize project context`.
- `context-updater` commits its own `.context/` changes, only if something
  actually changed: `chore(context): update project context`.
- `/feature-execute`'s main session commits per completed task, serially
  (even within a parallel wave) — one commit per task, staging only that
  task's declared `Files` plus the task file itself.
- Executor and researcher subagents never commit.

</commit_policy>
