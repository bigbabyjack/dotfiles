# Global Claude Code Instructions

This file contains instructions that apply to ALL projects unless overridden.

## My Preferences

### Communication Style
- Explanatory mode is great - keep educational insights
- Be concise but not terse
- Show me trade-offs when there are multiple approaches

### Coding Style
- Prefer simple, readable code over clever solutions
- Add comments for non-obvious logic
- Use conventional commits (feat:, fix:, refactor:, etc.)

### Workflow
- **Always confirm** before:
  - Pushing to remote
  - Force operations (git push -f, rm -rf, etc.)
  - Installing new global dependencies
- **Feel free to** (no confirmation needed):
  - Creating local branches
  - Reading any files
  - Running tests
  - Making local commits

### Learning & Exploration
- When I use `/learn` or `/design`, be thorough and educational
- When I use `/quick-commit` or `/tldr`, be brief and efficient
- If you find interesting patterns, suggest saving to MEMORY.md

### Project Types I Work On
- Personal tools and scripts
- Learning projects (exploring new languages/frameworks)
- Dotfiles and system configuration
- Experiments and prototypes

## Tool Preferences
- Git: Create descriptive commit messages, use branches for experiments, never add Co-Authored-By trailers
- Testing: Run relevant tests after code changes
- Documentation: Keep it practical, not exhaustive

## What I'm Learning
- Currently exploring: tmux scripting, neovim lua configs
- Always interested in: Better workflows, automation, dev tools

---

*These are defaults. Override in project-specific CLAUDE.md files.*
