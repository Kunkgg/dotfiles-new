---
name: yazi-plugin
description: "Write or debug a Yazi Lua plugin. Use when the user asks to add a keybinding, create a plugin, or configure yazi."
---

The Yazi plugin API has sharp edges that cause silent failures. This skill is a **field guide** — the rules distilled from debugging real plugins.

## Lua API rules

### `cx` is sync-only

`cx` (the current UI state) is only accessible inside a `ya.sync()` callback. Reading it anywhere else returns nil silently.

```lua
-- CORRECT
local get_url = ya.sync(function()
    local h = cx.active.current.hovered
    return h and tostring(h.url)
end)

-- WRONG — cx is nil in async context
local function entry()
    local h = cx.active.current.hovered  -- nil!
end
```

Each `ya.sync()` call returns **one value only**. Split into multiple calls if you need multiple values.

### `Command` is async-only

`Command` runs in the async `entry` context — never inside a `ya.sync()` block.

The method is `:arg()` **(singular)**, chained per argument. There is no `:args({...})`.

```lua
-- CORRECT
local output, err = Command("git")
    :arg("-C"):arg(dir):arg("rev-parse"):arg("--show-toplevel")
    :output()

-- WRONG — :args() does not exist
Command("git"):args({ "-C", dir, "rev-parse", "--show-toplevel" })
```

Use `:output()` for one-shot commands. Reserve `:spawn()` + `wait_with_output()` only when you need streaming.

### Entry function

Omit `-- @sync entry`. The default is async — the correct context for `Command`.

```lua
return {
    entry = function()
        local url = get_url()   -- calls ya.sync internally
        local out, _ = Command("foo"):arg("bar"):output()
        ya.clipboard(...)
        ya.notify({ title = "...", content = "...", level = "info", timeout = 3 })
    end,
}
```

## Plugin skeleton

```lua
--- @since 25.5.31

local get_something = ya.sync(function()
    local h = cx.active.current.hovered
    return h and tostring(h.url)
end)

return {
    entry = function()
        local val = get_something()
        if not val then
            return ya.notify({ title = "myplugin", content = "Nothing hovered", level = "warn", timeout = 3 })
        end

        local output, err = Command("sometool"):arg("--flag"):arg(val):output()
        if not output or not output.status.success then
            return ya.notify({ title = "myplugin", content = "Command failed", level = "error", timeout = 3 })
        end

        ya.clipboard(output.stdout:gsub("%s+$", ""))
        ya.notify({ title = "myplugin", content = "Done", level = "info", timeout = 3 })
    end,
}
```

## Keymap binding

In `keymap.toml`, add to `[mgr] prepend_keymap`:

```toml
{ on = [ "c", "r" ], run = "plugin my-plugin-name", desc = "描述" },
```

Plugin directory must be named `<plugin-name>.yazi/` and placed under `~/.config/yazi/plugins/`.

## Useful `cx` properties

| Expression | Type | Description |
|---|---|---|
| `cx.active.current.hovered` | `File?` | Currently hovered file |
| `cx.active.current.hovered.url` | `Url` | Hovered file's URL/path |
| `cx.active.current.cwd` | `Url` | Current directory |
| `cx.active.selected` | `File[]` | Selected files |

Convert a `Url` to string with `tostring(url)`.

## Reference plugins

See these plugins in `~/.config/yazi/plugins/` for working patterns:

- [`diff.yazi`](file:///Users/kung/Dotfiles/yazi/.config/yazi/plugins/diff.yazi/main.lua) — `ya.sync` + `Command:output()` + `ya.clipboard`
- [`smart-enter.yazi`](file:///Users/kung/Dotfiles/yazi/.config/yazi/plugins/smart-enter.yazi/main.lua) — minimal sync plugin accessing `cx`
- [`copy-root-rel-path.yazi`](file:///Users/kung/Dotfiles/yazi/.config/yazi/plugins/copy-root-rel-path.yazi/main.lua) — git root relative path copy
