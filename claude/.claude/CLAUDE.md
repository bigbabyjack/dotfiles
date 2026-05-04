# CLAUDE.md — Universal Rules

Universal rules for any Claude Code session, in any repo, on any language. Project-specific tooling, commands, and conventions live in per-project `AGENTS.md` / `CLAUDE.md`.

The full agent-harness playbook lives at `~/code/agentic-research/agent-harness.md` — read it when in doubt about *why* a rule exists.

## Pre-commit / pre-merge discipline

Hooks fire on every commit. They cannot be bypassed:

- **Never use `--no-verify`.** If a hook fails, fix the underlying issue.
- **Never add suppression markers to silence problems.** Examples: `# noqa`, `# type: ignore`, `# pyright: ignore`, `# fmt: skip|off|on` (Python), `// @ts-ignore`, `// eslint-disable*` (TS/JS), `#[allow(...)]` (Rust). Block at the hook layer per project.
- **Never add per-file or per-rule lint ignores** to project config to silence problems.

Suppression is the path of least resistance under time pressure. Removing the path forces real fixes.

## Commits

- **Conventional Commits format**: `type(scope): subject`. Types: `feat`, `fix`, `refactor`, `test`, `docs`, `perf`, `build`, `ci`, `chore`.
- **Verb-led, specific subjects.** `extract X from Y`, `unify Z handlers`. Never `cleanup`, `improve`, `update stuff`.
- **One concern per commit.** Atomic = concern-sized, not single-file. ~5–10 files / ~100 lines is a healthy average. Megacommits aren't.
- **Commit early, commit often.** After each green test pass, commit. Don't batch modules.
- **Never `git add -A` / `git add .` reflexively.** Stage explicit paths so unrelated changes don't get bundled.

## TDD discipline

For new features: red → green → refactor → commit, per concern.

- Write the failing test first.
- Implement until it passes.
- Refactor with tests still passing.
- Commit.

## Verification loop

After any change, before declaring work done:

1. Run the project's test suite (or the scoped subset).
2. Run the project's full hook pass (`pre-commit run --all-files` or equivalent).
3. Review the diff: `git diff --stat HEAD` and skim the files.
4. Sanity-check recent commits: `git log --oneline -5`.

If anything's red, fix before committing. If verification can't be run (e.g., UI behavior, no automated check), say so explicitly rather than claiming success.

## Persistent state pattern

For any non-trivial project, maintain two markdown files at the repo root:

- **`WORKING_NOTES.md`** — current state. Replaced/edited in place. Sections: *Where we are*, *Active task*, *Recent decisions (and why)*, *Open threads*, *Don't lose*. Update before any context-risk operation.
- **`DECISIONS.md`** — append-only ADR-lite. Dated entries, never edited, never reordered. Format: *Context / Decision / Rationale / Consequences*.

Re-read both at session start. Update `WORKING_NOTES.md` at session end and before `/compact`. The two files answer different questions: *where am I right now* vs *why did past-me make that call*.

## Anti-patterns

- **Reflexive `try: except: pass`** (or equivalent silent error swallowing) around imports / risky calls — don't.
- **"Just one more file" megacommits** — split.
- **Tests that import code without exercising it** — write tests that fail without the implementation.
- **Inventing config keys, env vars, marker names that silently no-op.** Validate or assert at startup.
- **Adding error handling, fallbacks, or validation for scenarios that can't happen.** Trust internal code; only validate at system boundaries.
- **Comments that explain what code does** — well-named identifiers do that. Comments are for *why* (hidden constraint, subtle invariant, workaround for a specific bug).
- **Backwards-compat shims for code with no external users** — just change the code.

## Working in unfamiliar code

- Read existing structure before proposing changes; follow existing patterns.
- Where existing code has problems that affect the current work (e.g., a file that's grown too large, tangled responsibilities), include targeted improvements as part of the change.
- Don't propose unrelated refactoring. Stay focused on what serves the current goal.

## GPU jobs

GPU-touching commands on this machine go through `gpuq` — see the project's `AGENTS.md` for setup. Don't fall back to running CUDA commands directly; ask the user if `gpuq` isn't on PATH.

## Risky / destructive actions

Confirm before doing anything that's hard to reverse: deleting branches/files, force-pushing, dropping tables, rewriting published history, killing processes you didn't start, modifying CI/CD, anything that affects shared state outside this machine. Match the scope of action to what was actually requested.

## Project-specific layer

Each project should have its own `AGENTS.md` (with `CLAUDE.md` symlink) covering:

- Tooling: exact CLI invocations for the language/stack
- Project-specific anti-patterns observed in this repo (living catalog)
- Conventions that diverge from these universal rules (with rationale)
