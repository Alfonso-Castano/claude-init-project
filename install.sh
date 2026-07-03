#!/usr/bin/env bash
set -e
REPO_URL="https://github.com/Alfonso-Castano/claude-init-project.git"
TMP_DIR=$(mktemp -d)
git clone --depth 1 "$REPO_URL" "$TMP_DIR"
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r "$TMP_DIR/skills/init-project" ~/.claude/skills/
cp "$TMP_DIR/agents/"*.md ~/.claude/agents/
rm -rf "$TMP_DIR"
echo "✅ init-project skill and agents installed to ~/.claude/"
