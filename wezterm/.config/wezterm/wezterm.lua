local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. 基础 UI 与字体设置
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 14.0
-- 单真源调色板：herdr 的 theme.name = "terminal" 经 OSC 4/10/11 镜像这里的 ANSI 色（#4）。
config.color_scheme = "Catppuccin Mocha"

-- 窗口外观
config.window_decorations = "RESIZE"
config.initial_rows = 36
config.initial_cols = 120
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- 2. 系统与按键行为 (macOS 特定优化)
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- 3. wezterm 退化为纯宿主（wayfinder #5；键位归属见 #3，安全性依据见 #2）
--
-- 【已删除】config.leader = { key = 'a', mods = 'CTRL', ... }
--   研究 #2 的硬前提：wezterm 在 LEADER 激活时会吞掉未匹配按键（含 ctrl+a），
--   不删则 herdr 的 ctrl+a 前缀永远收不到。整块 LEADER+* 绑定（分屏 / 跳转 /
--   tab / zoom / 重命名 / 1-9 / 关闭其他 pane）一并移除，职责归 herdr。
--
-- 【保留】wezterm 默认键 cmd+t / cmd+1-9 / cmd+w 不走 leader，不受影响 ——
--   「多个 wezterm tab 各跑一个 herdr session」这条路仍然留着；复制 / 粘贴 /
--   搜索 / 字体 / scrollback 的 ctrl+shift+* 也原样保留。
--
-- 【删除】{ key = 'c', mods = 'OPT', action = SendString '\x1bc' }
--   RIS 终端重置在 herdr 内会连 herdr 客户端一起重置。
config.keys = {
  -- 关掉 wezterm 自己的 ctrl+alt 分屏族 —— wezterm 不再分屏，且避免与
  -- herdr 直连层抢语义。
  { key = '"', mods = 'CTRL|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = '%', mods = 'CTRL|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = '"', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = '%', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = "'", mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = '5', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },

  -- 关掉 wezterm 自己的 ctrl+alt+shift+方向键调整 pane 尺寸（herdr 负责 resize）。
  { key = 'LeftArrow',  mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = 'RightArrow', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = 'UpArrow',    mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },
  { key = 'DownArrow',  mods = 'CTRL|SHIFT|ALT', action = wezterm.action.DisableDefaultAssignment },

  -- 放开 herdr copy mode 的翻页键。本机 wezterm（20240203）默认表把
  --   CTRL+U 绑成 CharSelect、CTRL+F 绑成 Search（新版只占 ctrl+shift+*，
  --   此版连不带 SHIFT 的也占），herdr copy mode 的 ctrl+u/ctrl+d（半页）与
  --   ctrl+b/ctrl+f（整页）因此永远收不到这两个键。
  --
  --   写法说明：此版的默认绑定以 key = 'U'（大写）+ CTRL 登记，用小写
  --   'u' + CTRL 写 DisableDefaultAssignment 不生效（wezterm show-keys 实测）。
  --   而大写身份与 SHIFT 变体折叠在一起，摘不掉「只带 CTRL」那一个 ——
  --   代价是 ctrl+shift+u 的字符选择器一并失效（ctrl+shift+f 搜索同理，
  --   但 Cmd+F 的搜索与 Cmd+* 键族都不受影响）。
  --   顺带恢复 shell 里 ctrl+u（删至行首）/ ctrl+f（前移一字符）的原生语义。
  { key = 'U', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
  { key = 'F', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
}

return config
