# wezterm 退化为纯宿主，复用职责全归 herdr

---
status: accepted
---

本机上 wezterm 与 herdr 各自都提供 pane / tab / workspace，叠在一起时键位、鼠标、剪贴板三块都会出现两套语义，职责边界无法划清。因此决定：**wezterm 放弃复用职责，只做纯宿主** —— 删掉 `config.leader` 与整个 `LEADER+*` 键块，分屏 / tab / workspace / zoom 全部归 herdr；wezterm 只保留终端原生能力（原生选取、复制粘贴、字体、scrollback）和 `cmd+t` / `cmd+1-9` / `cmd+w` 这些不走 leader 的默认键。

## Considered Options

- **wezterm 继续兼任复用器，herdr 只当 agent 面板** —— 放弃。两套 pane / tab 语义并存，鼠标归属（谁抓、原生选取怎么绕过）与剪贴板路径都得设计两遍，得不偿失。
- **保留 wezterm 的 leader，只把它改绑到别的键以避开 `ctrl+a`** —— 放弃。wezterm 在 LEADER 激活时会**吞掉**未匹配的按键、不转发，只要 `config.leader` 还在，herdr 的 `ctrl+a` 前缀就永远收不到；**删掉 `config.leader` 是前缀方案能成立的前置条件**，不是可选优化。

## Consequences

- **已知损失**：`LEADER+o`（关闭其他 pane）与 `LEADER+Enter`（把 pane 移到新 tab）在 herdr 没有对应 action，接受损失、不做替代。
- **鼠标与剪贴板全部改走 herdr**：herdr 的选中即复制直接写系统剪贴板，与 wezterm 的 `Cmd+V` 是同一条路径；wezterm 的原生选取退到「按住 bypass 修饰键（默认 `Shift`）」这条路径上。
- **调色板成为单真源**：wezterm 的 `color_scheme` 是唯一真源，herdr 用 `theme.name = "terminal"` 镜像宿主 ANSI 调色板 —— 宿主换配色，复用器跟着变。
- **「多个 wezterm tab 各跑一个 herdr session」这条路仍然保留**：`cmd+t` / `cmd+1-9` / `cmd+w` 未动，wezterm tab bar 的自动隐藏行为也不动。
