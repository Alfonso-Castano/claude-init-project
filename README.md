# Installing /init-project

Repo: https://github.com/Alfonso-Castano/claude-init-project

## Quick install

This repo has two independently-installable pieces: **`/init-project`** (one-time project setup) and **`/update-context`** (ongoing `.context/` maintenance). Install either one alone, or both together — `install.sh` takes an optional component argument.

**`/init-project` only** (default — no argument needed):

```bash
curl -fsSL https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash
```
```powershell
Invoke-RestMethod https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash
```

**`/update-context` only:**

```bash
curl -fsSL https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash -s -- context-update
```
```powershell
Invoke-RestMethod https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash -s -- context-update
```

**Both:**

```bash
curl -fsSL https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash -s -- all
```
```powershell
Invoke-RestMethod https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash -s -- all
```

Each installs its own skill/agent files to `~/.claude/` in one step. Details on what gets installed and how below.

Two things to install, both at the **user level** (`~/.claude/`) so this works identically in every project, per the consistency requirement.

## 0. Push this folder to the repo (one-time)

From this folder:

```bash
git init
git add .
git commit -m "init-project skill: initial version"
git branch -M main
git remote add origin https://github.com/Alfonso-Castano/claude-init-project.git
git push -u origin main
```

## 1. The skill

Copy the whole `skills/init-project/` folder to:

```
~/.claude/skills/init-project/
```

Result:
```
~/.claude/skills/init-project/
  SKILL.md
  references/
    questioning.md
    spec-review.md
  templates/
    overview.md
    roadmap.md
    decisions.md
    state.md
```

## 2. The subagents

Copy the three files from `agents/` to:

```
~/.claude/agents/context-researcher.md
~/.claude/agents/context-research-synthesizer.md
~/.claude/agents/context-roadmapper.md
```

## 3. /update-context (optional, separate from /init-project)

`/update-context` keeps an existing `.context/` directory (STATE.md,
DECISIONS.md, ROADMAP.md) current as work progresses — it's a different,
recurring capability from `/init-project`'s one-time setup, and installs
independently of it (see [Quick install](#quick-install) above for the
`context-update`-only one-liner).

**The skill:**

```
~/.claude/skills/update-context/SKILL.md
```

**The subagent** (does the actual read/write work, in its own isolated context):

```
~/.claude/agents/context-updater.md
```

**The staleness-check hook** (monitoring-only — never writes, never invokes Claude, just prints a reminder to stderr at session start if `.context/STATE.md` looks stale):

```
~/.claude/hooks/context-staleness-check.sh
```

The hook needs to be registered in `~/.claude/settings.json` under
`hooks.SessionStart` — `install.sh` does this automatically (merging into
any existing settings.json without disturbing other hooks or settings). If
installing by hand, add:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "$HOME/.claude/hooks/context-staleness-check.sh" }
        ]
      }
    ]
  }
}
```

## Installing on any machine, going forward

Once step 0 is pushed, you never need these local files again. On any machine, in any Claude Code session (terminal or IDE), just say:

> Clone https://github.com/Alfonso-Castano/claude-init-project and install it: copy `skills/init-project` into `~/.claude/skills/` and everything in `agents/` into `~/.claude/agents/`.

Claude Code has git and bash access by default and will do this itself — no scripts to run by hand. You only need to say this once per machine; after that `~/.claude/` already has it and every project picks it up automatically.

**Manual equivalent**, if you'd rather run it yourself — see [Quick install](#quick-install) above for the one-liner (`install.sh`), which does exactly this.

## Updating later

If you revise the skill or agent files, push the changes to the repo (`git add . && git commit -m "..." && git push`), then repeat the same one-sentence install on each machine — it'll overwrite the existing `~/.claude/` copies with the latest version.

## Using it

In any project directory, open Claude Code and run:

```
/init-project
```

It only triggers on explicit invocation — it will never fire on its own from conversational cues (`disable-model-invocation: true` in the frontmatter), matching what you asked for: no auto-trigger, since you only run this once per project and always deliberately.

## What it produces

A `.context/` directory in the project root:

- `OVERVIEW.md` — always
- `research/` — only if you accept the research offer
- `ROADMAP.md` — only if the roadmapper agent decides the project actually needs phases
- `DECISIONS.md` — always (may be a thin seed)
- `STATE.md` — always

No `.claude/` scaffolding, no `config.json`, no CLAUDE.md changes — all of that was deliberately dropped per our discussion.

## Using /update-context

In a project that already has `.context/` (from `/init-project`), run:

```
/update-context
```

Like `/init-project`, it only triggers on explicit invocation
(`disable-model-invocation: true`) — it never fires on its own from
conversational cues. It delegates the actual git-history read and file
writes to the `context-updater` subagent, running in its own isolated
context so the main session's context budget isn't spent on it. If
`.context/` doesn't exist yet in the current project, it says so and stops
— it never creates one (`/init-project` is the only thing that does that).

**What it updates:**

- `STATE.md` — overwritten in place with a fresh snapshot (Current Position, Next Action)
- `DECISIONS.md` — appended to, only if the git evidence shows a genuine new decision
- `ROADMAP.md` — updated only if it already exists and a phase transitioned
- `OVERVIEW.md` and `research/` — left untouched (static by design)

**The staleness hook:** once installed, every new session prints a one-line
stderr note if `STATE.md` is stale relative to new git activity — a visible
nudge to run `/update-context`, not an automatic update. It never writes
files and never invokes Claude on its own.
