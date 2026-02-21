#!/bin/bash
# Hook: SessionEnd — captures structural session summary as a note
# Reads hook JSON from stdin, parses transcript JSONL for facts

set -euo pipefail

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Skip if no transcript
if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

PROJECT=$(basename "$CWD")
DATETIME=$(date +%Y-%m-%d-%H%M)
DATE=$(date +%Y-%m-%d)

# Count assistant messages (approximate session size)
MSG_COUNT=$(grep -c '"role":"assistant"' "$TRANSCRIPT" 2>/dev/null || echo "0")

# Skip very short sessions (likely just a quick question)
if [ "$MSG_COUNT" -lt 2 ]; then
  exit 0
fi

# Extract unique file paths from Edit/Write tool uses
FILES_MODIFIED=$(grep -o '"file_path":"[^"]*"' "$TRANSCRIPT" 2>/dev/null \
  | sed 's/"file_path":"//;s/"//' \
  | sort -u \
  | head -20 \
  | sed 's|^|- |' || echo "- (none detected)")

# Extract unique bash commands (skip common noise)
COMMANDS_RUN=$(grep -o '"command":"[^"]*"' "$TRANSCRIPT" 2>/dev/null \
  | sed 's/"command":"//;s/"//' \
  | grep -v -E '^(ls|cat|echo|pwd|cd )' \
  | sort -u \
  | head -15 \
  | sed 's|^|- |' || echo "- (none detected)")

# Build note content
NOTE="## Session: ${PROJECT} - ${DATETIME}

**Duration:** ${MSG_COUNT} exchanges
**Project:** ${PROJECT}

**Files modified:**
${FILES_MODIFIED}

**Commands run:**
${COMMANDS_RUN}"

# Save the note
NOTE_PATH="$HOME/notes/sessions/${DATE}-${PROJECT}.md"
~/.local/bin/claude-note add "$NOTE_PATH" "$NOTE" 2>/dev/null || true

exit 0
