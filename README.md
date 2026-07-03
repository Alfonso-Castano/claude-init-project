# Installing /init-project

Repo: https://github.com/Alfonso-Castano/claude-init-project

## Quick install

```bash
curl -fsSL https://raw.githubusercontent.com/Alfonso-Castano/claude-init-project/main/install.sh | bash
```

This installs the skill and agents to `~/.claude/` in one step. Details on what gets installed and how below.

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
