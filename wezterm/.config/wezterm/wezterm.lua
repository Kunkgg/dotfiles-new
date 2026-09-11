local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. 基础 UI 与字体设置
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 14.0
config.color_scheme = "Tokyo Night"


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

-- 3. wezterm 退化为纯宿主
--
-- 【已删除】config.leader = { key = 'a', mods = 'CTRL', ... }
--   研究 #2 的硬前提：wezterm 在 LEADER 激活时会吞掉未匹配按键（含 ctrl+a），
--   不删则 herdr 的 ctrl+a 前缀永远收不到。同时整块 LEADER+* 绑定（分屏 /
--   跳转 / tab / zoom / 重命名 / 1-9 / 关闭其他 pane）全部移除，职责归 herdr。
--
-- 【保留】wezterm 默认键：cmd+t / cmd+1-9 / cmd+w 不走 leader、不受影响，
--   "多个 wezterm tab 各跑一个 herdr session" 这条路仍然留着；复制 / 粘贴 /
--   搜索 / 字体 / scrollback 的 ctrl+shift+* 也原样保留。
--
-- 【删除】{ key = 'c', mods = 'OPT', action = SendString '\x1bc' }
--   RIS 终端重置在 herdr 内会连 herdr 客户端一起重置。wezterm 已无复用职责，
--   建议直接删（备选：保留但改键）。
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
}

return config
