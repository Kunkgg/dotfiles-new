# ---------------------------------------------------------
# 1. 基础配置
# ---------------------------------------------------------
export LANG=en_US.UTF-8

# 历史纪录设置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# 开启基础补全
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# 开启 Vi 模式
bindkey -v
export KEYTIMEOUT=1

export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple" # 顺便加速 Python pip

# ---------------------------------------------------------
# 2. 插件加载
# ---------------------------------------------------------
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ---------------------------------------------------------
# 3. alias
# ---------------------------------------------------------
alias ls="ls -a"
alias ll="ls -l -a"

# ---------------------------------------------------------
# 4. 初始化 app
# ---------------------------------------------------------
eval "$(starship init zsh)"

