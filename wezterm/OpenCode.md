# OpenCode Guidelines for this Repository

1. **Language & Scope** – This repo is pure Lua, holding a single `wezterm.lua` config. There is no build artifact; the “runtime” is WezTerm itself.
2. **Run / Smoke-test** – `wezterm --config-file wezterm.lua start` launches a terminal using the config. This is the quickest way to validate changes.
3. **Lint** – Use `luacheck wezterm.lua` (install via `brew install luacheck`). Pass `--std min` for strict mode.
4. **Unit-test pattern** – None today. If you add tests, place them in `spec/` and run with `busted spec/<file>_spec.lua`.  Single test: `busted spec/tab_title_spec.lua`.
5. **Formatting** – Two-space indent, 100-column soft limit. Run `stylua wezterm.lua` (config-less) before committing.
6. **Imports / Requires** – Absolute module names, e.g. `require("wezterm")`; group std-lib first, third-party next, local modules last; blank line between groups.
7. **Types / Docs** – Use EmmyLua annotations (`---@param …`) for non-trivial functions so IDEs can infer types; keep them terse.
8. **Naming** – snake_case for locals, UpperCamelCase for events / tables returned to WezTerm, ALL_CAPS for constants.
9. **Functions** – Prefer small pure helpers; put large anonymous callbacks in `local function` blocks and reference them.
10. **Tables** – Trailing comma on last field when multi-line; align `=` signs where practical.
11. **Strings** – Use double quotes unless single quotes avoid backslash escapes.
12. **Error handling** – `assert` for unrecoverable config errors; return `nil, "message"` for helpers.
13. **Events** – All `wezterm.on("event", fn)` calls live after helper declarations; keep them alphabetically ordered.
14. **Avoid Globals** – Declare `local` for everything; run `luacheck` to catch leaks.
15. **Key tables** – Sort by key char to minimize merge conflicts.
16. **Git-hooks** – Optionally add `pre-commit` to run `stylua` and `luacheck` (not enforced yet).
17. **PR checklist** – Ensure lint passes, config launches, and README sections stay accurate.
18. **Cursor / Copilot rules** – None present; default OpenAI coding guidelines apply.
19. **File limits** – Keep `wezterm.lua` under ~400 lines; split into `lua/` helpers when it grows.
20. **Contribution mantra** – “Readable config over clever hacks”; optimize for future maintainers.
