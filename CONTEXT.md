# 终端栈（wezterm × herdr）

本 repo 是 macOS 上各类工具配置的集合；本文件只收**终端栈**这一层的术语 —— 宿主终端与运行在其内的复用器之间，键位、鼠标、剪贴板、滚动与视觉的职责怎么划分。只收在这个上下文里有特定含义的词，通用概念不收。

## Language

### 角色

**宿主 (Host)**:
承载复用器的外层终端程序；在本 repo 指 wezterm。它只保留终端原生能力，不承担复用职责。
_Avoid_: 外层终端、终端仿真器、terminal

**复用器 (Multiplexer)**:
运行在宿主内、提供 pane / tab / workspace 的 TUI 程序；在本 repo 指 herdr。
_Avoid_: 终端复用器、workspace manager、会话管理器

### 键位

**前缀键 (Prefix)**:
复用器里进入前缀模式的那一个键。先按它、再按动作键才触发动作。
_Avoid_: leader、leader 键

**前缀层 (Prefix layer)**:
复用器中「前缀键 + 动作键」的两段式绑定集合 —— 动作的通用入口，不受宿主与系统占用约束。
_Avoid_: leader 块、LEADER+*

**直连键 (Direct chord)**:
不经前缀模式、由宿主原样送达复用器的组合键。免前缀是它的定义特征；代价是必须避开宿主与系统的占用。
_Avoid_: 免前缀键、direct binding

**两层键位 (Two-layer keymap)**:
同一套动作同时挂在「前缀层」与「直连层」上的设计 —— 前者通用，后者免前缀。
_Avoid_: 双绑定、键位映射

**模式 (Mode)**:
复用器的临时按键上下文（前缀 / 工作区导航 / 复制 / 调整尺寸）。**判据是模式条**：模式激活时，模式条临时占据底部 tab row。
_Avoid_: 状态、模式条

**工作区导航模式 (Workspace-navigation mode)**:
`workspace_picker`（`prefix+w`）打开的**模式** —— 模式条渲染为 `NAVIGATE  esc back  ↑/↓ workspace  tab pane`。它与**会话导航器**（`prefix+g`）是两个不同的界面。
_Avoid_: navigate 模式、workspace picker 模式

**会话导航器 (Session navigator)**:
复用器里 `prefix+g` 打开的悬浮覆盖层，用于跨 workspace / tab / pane 的选择、跳转与搜索。它**不是模式**：覆盖层打开期间模式条不渲染，按键进的是覆盖层自己的输入框，而不是模式键位。
_Avoid_: navigate 模式、导航模式

**预览选中项 (Preview selection)**:
**模式**或覆盖层里被高亮、但尚未提交的候选项。方向键只移动它、不产生切换；提交是另一次独立输入（工作区导航模式内为 `Enter`）。
_Avoid_: 光标、选中、当前焦点

**宿主原生路径 (Host-native path)**:
宿主自己消费输入、不转发给复用器的那条路径。按住宿主的 bypass 修饰键，或复用器压根没截获该输入时，输入走这条。
_Avoid_: 绕过、bypass

### 滚动

**宿主滚动缓冲 (Host scrollback)**:
复用器按 pane 保留的、已滚出屏幕顶部的行历史。**模式**里的翻页与滚轮滚动的都是它；它为空时，翻页就无处可去。
_Avoid_: 滚动历史、回滚缓冲、scrollback

**备用屏 (Alternate screen)**:
全屏 TUI（Claude Code、OpenCode、vim）接管整屏时使用的第二块屏。它的内容不进**宿主滚动缓冲**。
_Avoid_: alt screen、副屏、备用缓冲区

**备用屏历史 (Alternate-screen history)**:
备用屏应用自己维护的会话历史（如 Claude Code 的对话回滚）。它是应用内部状态，复用器只能借该应用的鼠标滚动接口按页取用（herdr 的 `agent read --lines N`，且要求 agent 空闲），**模式**的翻页够不到。
_Avoid_: transcript、对话滚动缓冲、备用屏 scrollback

### 配置落地

**配置资源 (Config artifact)**:
该进 repo、受版本控制的那一份配置。
_Avoid_: 设置、dotfile

**运行时状态 (Runtime state)**:
程序自己写、不该进 repo 的文件 —— 会话快照、socket、日志。
_Avoid_: 数据、缓存

**落地 (Landing)**:
把决定好的配置写进 repo，并让运行中的实例真正加载它（软链 + reload + 实测）。
_Avoid_: 部署、上线
