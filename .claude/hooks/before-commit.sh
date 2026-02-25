#!/bin/bash
# Hook: Runs before git commits
# Provides helpful reminders for better commits

# Check if this is a meaningful commit (not just quick iteration)
if git diff --cached --stat | grep -q "files changed"; then
    num_files=$(git diff --cached --numstat | wc -l | tr -d ' ')

    # For larger commits, remind about documentation
    if [ "$num_files" -gt 5 ]; then
        echo "💡 Tip: This is a larger commit ($num_files files). Consider:"
        echo "   - Breaking into smaller commits"
        echo "   - Updating MEMORY.md with new patterns learned"
        echo "   - Adding README notes if this adds new features"
    fi
fi

# Always allow the commit to proceed
exit 0
