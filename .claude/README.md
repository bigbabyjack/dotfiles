# Claude Code Configuration Guide

## 🎯 Quick Start

Your Claude Code is now supercharged! Here's what you have:

### Custom Skills (use with `/command`)

**Creative & Planning:**
- `/design` - Plan and architect solutions before coding
- `/brainstorm` - Creative ideation sessions
- `/experiment` - Safe playground with auto-branching

**Learning:**
- `/learn [topic]` - Interactive tutorial on any topic
- `/explain [code/concept]` - Deep dive explanations
- `/research [topic]` - Research with latest docs (Context7 + web)

**Quick Actions:**
- `/quick-commit` - Fast git commit with smart messages
- `/tldr [file/project]` - Quick summaries

### Example Usage

```bash
# Start a learning session
/learn rust async programming

# Design before building
/design cli tool for managing todos

# Quick brainstorm
/brainstorm fun project ideas using tmux

# Explain something you're looking at
/explain this codebase

# Fast commit when iterating
/quick-commit

# Get the gist of a file
/tldr nvim/init.lua
```

## 🪝 Hooks

**Location:** `~/.claude/hooks/`

Currently configured:
- `before-commit.sh` - Reminds you about docs for large commits

**To add more hooks:**
1. Create `.sh` file in `~/.claude/hooks/`
2. Make it executable: `chmod +x ~/.claude/hooks/your-hook.sh`
3. Configure when it runs in `settings.json`

## 🧠 Auto Memory

**Location:** `~/.claude/projects/[project]/memory/MEMORY.md`

This file persists across sessions! Use it for:
- Commands you always forget
- Project patterns and conventions
- Workflow preferences
- Tool configurations

**Update it** with: `/remember [something]` or by editing directly

## ⚙️ Configuration Files

### Global Settings
- `~/.claude/settings.json` - Permissions, plugins, preferences
- `~/.claude/CLAUDE.md` - Instructions for all projects

### Project-Specific
- `[project]/.claude.md` or `CLAUDE.md` - Project instructions
- `~/.claude/projects/[project]/memory/MEMORY.md` - Project memory

## 🔧 Settings Enhanced

Your permissions now auto-allow:
- ✅ Git operations (add, commit, status, diff, branch)
- ✅ Language tools (python, rust, node, lua)
- ✅ Terminal tools (tmux, source, cat)
- ✅ Testing (pytest, cargo test, npm test)
- ⚠️ Still requires confirmation: push, force operations, deletions

## 🎨 Customization

### Add a New Skill

Create `~/.claude/skills/your-skill.json`:
```json
{
  "name": "your-skill",
  "description": "What it does",
  "prompt": "Instructions for Claude...",
  "tags": ["category", "workflow"]
}
```

### Modify Existing Skills

Just edit the JSON files in `~/.claude/skills/`!

### Enable/Disable Plugins

Edit `enabledPlugins` in `~/.claude/settings.json`

## 🎓 Tips & Tricks

1. **Chain skills**: Use one skill's output as input to another
   ```
   /research [topic]
   /design [solution based on research]
   /experiment [try it out]
   ```

2. **Pass arguments**: Most skills accept additional context
   ```
   /learn rust error handling
   /explain src/main.rs the error handling part
   ```

3. **Use memory**: After `/learn` sessions, save key insights to MEMORY.md

4. **Safe experiments**: Use `/experiment` - it creates a branch automatically

5. **Quick iteration**: `/quick-commit` for fast progress saving

## 📚 Available Plugins

Currently enabled:
- ✅ context7 - Up-to-date library documentation
- ✅ explanatory-output-style - Educational insights
- ✅ hookify - Custom hooks and rules
- ✅ pyright-lsp - Python language support
- ✅ rust-analyzer-lsp - Rust language support
- ✅ lua-lsp - Lua language support
- ✅ github - GitHub integration

## 🚀 Next Steps

Try it out:
1. Run `/brainstorm` to think of something to build
2. Use `/design` to plan it out
3. Use `/learn` to understand concepts you need
4. Use `/experiment` to try things safely
5. Use `/quick-commit` to save progress

Have fun learning and building!
