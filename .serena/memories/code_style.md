# Code Style and Conventions

## General Rules (from .editorconfig)
- **Encoding**: UTF-8
- **Line Endings**: LF (Unix style)
- **Trailing Whitespace**: Trim
- **Final Newline**: Insert

## Language-Specific Indentation

### Lua (Primary)
- **Indent Style**: Spaces
- **Indent Size**: 2 spaces
- **Quote Style**: Auto prefer single quotes (from StyLua)
- **Call Parentheses**: None (from StyLua)
- **Column Width**: 160 characters (from StyLua)

### Shell Scripts
- **Indent Style**: Spaces
- **Indent Size**: 2 spaces

### Python
- **Indent Style**: Spaces
- **Indent Size**: 4 spaces

### Go
- **Indent Style**: Tabs
- **Indent Size**: 4 spaces (tab width)

### TypeScript/TSX
- **Indent Style**: Spaces
- **Indent Size**: 2 spaces

## Lua Formatting (StyLua)
Configuration file: `nvim/.stylua.toml`
- Column width: 160
- Indent: 2 spaces
- Line endings: Unix
- Quote style: Auto prefer single
- Call parentheses: None

## File Organization
- Configuration files should mirror home directory structure when using Stow
- Keep related configs in their own top-level directories (nvim/, hypr/, zsh/, etc.)
- Custom scripts go in the `scripts/` directory
- Shell scripts should be executable

## Naming Conventions
- **Files**: Use lowercase with hyphens or underscores (e.g., `session-switcher.sh`, `nvim/init.lua`)
- **Directories**: Lowercase, descriptive names
- **Lua modules**: Use lowercase with underscores in custom/ namespace
