# Dotfiles Agent Guide

## Skills

Skills live in [`.agents/skills/`](file:///Users/kung/Dotfiles/.agents/skills/). The agent picks them up automatically when the task matches the description.

### yazi-plugin

**Path**: [`.agents/skills/yazi-plugin/SKILL.md`](file:///Users/kung/Dotfiles/.agents/skills/yazi-plugin/SKILL.md)

Use when writing or debugging a Yazi Lua plugin — keybindings, custom commands, `cx` access, `Command` API. Covers the sharp edges that cause silent failures (sync/async split, `:arg()` vs `:args()`, `ya.sync` single-return rule).
