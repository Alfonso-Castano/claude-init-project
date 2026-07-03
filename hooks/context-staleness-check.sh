#!/usr/bin/env bash
#
# context-staleness-check.sh — SessionStart hook
#
# Purely a monitor. It never writes to any file and never invokes Claude.
# It just prints a note at the start of a session if .context/STATE.md
# looks stale, so you remember to run /update-context yourself. This is
# the deliberate alternative to an automatic write: visible, non-executing,
# and it can't silently drift your files if it's wrong.
#
# Threshold: nudges if STATE.md's last git commit is more than 2 days old
# AND there's uncommitted or new work since then. A quiet project with no
# new work correctly stays silent — there's nothing to update.

set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR" 2>/dev/null || exit 0

[ -f ".context/STATE.md" ] || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

LAST_STATE_COMMIT_EPOCH="$(git log -1 --format=%ct -- .context/STATE.md 2>/dev/null || echo 0)"
NOW_EPOCH="$(date +%s)"
AGE_DAYS=$(( (NOW_EPOCH - LAST_STATE_COMMIT_EPOCH) / 86400 ))

DIRTY_COUNT="$(git status --porcelain | wc -l | tr -d ' ')"
NEW_COMMIT_COUNT="$(git log --since="@${LAST_STATE_COMMIT_EPOCH}" --oneline 2>/dev/null | wc -l | tr -d ' ')"

if [ "$AGE_DAYS" -ge 2 ] && { [ "$DIRTY_COUNT" != "0" ] || [ "$NEW_COMMIT_COUNT" -gt 1 ]; }; then
  echo "Note: .context/STATE.md is ${AGE_DAYS} days old and there's new work since then — consider running /update-context." >&2
fi

exit 0
