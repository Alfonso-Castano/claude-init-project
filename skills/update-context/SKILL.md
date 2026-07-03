---
name: update-context
description: Update .context/ (STATE.md, DECISIONS.md, ROADMAP.md) to reflect current project state. Run at natural stopping points, or anytime mid-task.
disable-model-invocation: true
allowed-tools: Bash, Agent
---

<runtime_note>
This skill is explicit-invocation only (`/update-context`). It never auto-triggers — `disable-model-invocation: true` in the frontmatter enforces that, matching `/init-project`: updating `.context/` should be a deliberate action the user asks for, not something that fires on an ambiguous cue.
</runtime_note>

<objective>

This project uses a `.context/` directory (created by `/init-project`) to
carry state across sessions. Delegate the full update to the
`context-updater` subagent (defined in `~/.claude/agents/`) to bring it up
to date now.

</objective>

<process>

## 1. Setup Check

```bash
if [ ! -f .context/STATE.md ]; then
  echo "NOT_INITIALIZED"
fi
```

If `.context/` doesn't exist in this project at all, say so plainly and stop
— don't create it. `.context/` is only created by `/init-project`; this
skill updates it, it doesn't initialize it.

## 2. Delegate

Spawn the `context-updater` subagent. Do not read git history or the
`.context/` files yourself in this conversation — the whole point of
delegating is to keep this session's context window from absorbing the git
log and four files. The subagent reads and writes STATE.md, DECISIONS.md,
and ROADMAP.md (if present) directly.

## 3. Report

Report the subagent's summary back to the user as-is.

</process>
