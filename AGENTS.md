# Dotfiles Agent Guide

## Skills

Skills live in [`.agents/skills/`](file:///Users/kung/Dotfiles/.agents/skills/). The agent picks them up automatically when the task matches the description.

### yazi-plugin

**Path**: [`.agents/skills/yazi-plugin/SKILL.md`](file:///Users/kung/Dotfiles/.agents/skills/yazi-plugin/SKILL.md)

Use when writing or debugging a Yazi Lua plugin — keybindings, custom commands, `cx` access, `Command` API. Covers the sharp edges that cause silent failures (sync/async split, `:arg()` vs `:args()`, `ya.sync` single-return rule).

## Agent skills

### Issue tracker

Issues live in GitHub Issues on `Kunkgg/dotfiles-new`, driven by the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` plus `docs/adr/` at the repo root. See `docs/agents/domain.md`.
