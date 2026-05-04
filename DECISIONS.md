# Decisions

Append-only ADR-lite log. Dated entries; never edit, never reorder.

---

## 2026-05-03 — Drop disabled and commented-out Neovim plugin specs

**Context:** `copilot.lua`, `avante.lua`, `copilotchat.lua`, `indent_line.lua`, and `floaterminal.lua` were either `enabled = false` or fully commented out. Carrying them violated the project's "no half-finished implementations" rule.

**Decision:** Delete all five files outright rather than gating them behind a feature flag.

**Rationale:** Git history preserves anything we want to revive. Live config files should reflect current intent.

**Consequences:** `<leader>tt` floating-terminal keybind no longer exists. `<leader>cpt` Copilot-toggle keybind no longer exists. Re-adding any of these requires a fresh, deliberate plugin spec.

---

## 2026-05-03 — Migrate windowrulev2 → windowrule (Hyprland 0.45+)

**Context:** Hyprland 0.45.0 (Oct 2024) unified `windowrulev2` into `windowrule`. The v2 form still parses but is deprecated. Running 0.54.3.

**Decision:** Replace all `windowrulev2` references in `hyprland.conf` and `CLAUDE.md` with `windowrule`.

**Rationale:** Stay on supported syntax; avoid surprise breakage on a future Hyprland update.

**Consequences:** None at runtime — the only `windowrulev2` reference was already commented out. Documentation is now accurate.

---

## 2026-05-03 — Standardize Hyprland script paths to `~/.config/scripts/`

**Context:** `hyprland.conf:300` (GRUB reboot bind) referenced `~/dotfiles/scripts/grub-reboot-menu.sh` while sibling binds at lines 222-223 used the stowed `~/.config/scripts/` path. Both work because of the stow symlink, but the inconsistency was confusing.

**Decision:** All script execs in Hyprland config use the stowed `~/.config/scripts/` path.

**Rationale:** Treat `~/.config/scripts/` (the symlink target) as the canonical runtime path. The repo location `~/dotfiles/scripts/` is an implementation detail of where files live before stowing.

**Consequences:** Config now portable to anyone who stows the repo, regardless of where they cloned it.

---

## 2026-05-03 — Drop Python venv aliases in favor of uv

**Context:** `.aliases.zsh` carried `alias activate='source env/bin/activate'` (twice) and `alias mkvenv='python -m venv env'`. Workflow has migrated to `uv`.

**Decision:** Remove both aliases. Keep `alias python='python3'`.

**Rationale:** `uv` provides `uv venv`, `uv run`, and project-aware execution. Manual venv activation is no longer the standard entry point.

**Consequences:** Any muscle-memory `activate` invocations will fail until retrained.
