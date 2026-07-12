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

-- 3. 快捷键配置 (Tmux 风格 Leader 键)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = 'c', mods = 'OPT', action = wezterm.action.SendString '\x1bc' },

  -- 面板分割
  { key = 'v', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'c', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- 面板跳转
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- 标签页管理
  { key = 'n', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- 类似 Tmux 的 prefix + w 交互式导航
  { key = 'w', mods = 'LEADER', action = wezterm.action.ShowTabNavigator },

  -- Windows 与 Panel 高级管理
  {
    key = 'r', mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then window:active_tab():set_title(line) end
      end),
    },
  },
  {
    key = 'Enter', mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane) pane:move_to_new_tab() end),
  },
  { key = 'f', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },
  {
    key = 'o', mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()
      for _, p in ipairs(tab:panes()) do
        if p:pane_id() ~= pane:pane_id() then
          p:activate()
          window:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, p)
        end
      end
      pane:activate()
    end),
  },
}

-- 动态绑定 Leader + 1~9 快速切换 Tab
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config

