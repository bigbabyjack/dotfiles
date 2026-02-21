#!/bin/bash
# Hook: PostToolUse (Bash) — captures git commit info as a note
# Reads hook JSON from stdin, skips if not a git commit

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Only act on git commit commands
if ! echo "$COMMAND" | grep -q 'git commit'; then
  exit 0
fi

# Give git a moment to finalize
sleep 0.5

# Extract commit info from the repo
SUBJECT=$(git -C "$CWD" log -1 --format='%s' 2>/dev/null || echo "unknown")
BODY=$(git -C "$CWD" log -1 --format='%b' 2>/dev/null || echo "")
SHORT_HASH=$(git -C "$CWD" log -1 --format='%h' 2>/dev/null || echo "0000000")
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null || echo "unknown")
PROJECT=$(basename "$CWD")
DATE=$(date +%Y-%m-%d)
STAT=$(git -C "$CWD" log -1 --stat --format='' 2>/dev/null || echo "")

# Build note content
NOTE="## Commit: ${SUBJECT}

**Branch:** ${BRANCH}
**Project:** ${PROJECT}

**Files changed:**
${STAT}"

# Append body if non-empty
if [ -n "$BODY" ]; then
  NOTE="${NOTE}

**Full message:**
${BODY}"
fi

# Save the note
NOTE_PATH="$HOME/notes/commits/${DATE}-${PROJECT}-${SHORT_HASH}.md"
~/.local/bin/claude-note add "$NOTE_PATH" "$NOTE" 2>/dev/null || true

exit 0
