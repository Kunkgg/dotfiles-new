local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 1. 基础 UI 与字体设置
-- 设置为带有图标支持的 Nerd Font
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 14.0
config.color_scheme = "Tokyo Night" 

-- 窗口外观
config.window_decorations = "RESIZE" 
config.initial_rows = 36
config.initial_cols = 100
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- 2. 系统与按键行为 (macOS 特定优化)
-- 阻止 macOS 将 Option (Alt) 键解释为特殊字符（如输入 ç）
-- 这对于 fzf (Option+c) 以及在终端里按词移动光标 (Option+b/f) 非常重要
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- 3. 快捷键配置 (Tmux 风格 Leader 键)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- 为 fzf 的 Option + c 提供绝对兜底映射 (发送 \x1bc 即 ESC+c 信号)
  { key = 'c', mods = 'OPT', action = wezterm.action.SendString '\x1bc' },

  -- ====================
  -- 面板分割
  -- ====================
  { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- 面板跳转
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- 标签页管理
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
}

return config

