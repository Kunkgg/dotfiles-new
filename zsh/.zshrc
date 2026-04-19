# ---------------------------------------------------------
# 1. 基础配置
# ---------------------------------------------------------
typeset -U path fpath
export LANG=en_US.UTF-8

# 历史纪录设置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# 开启基础补全
autoload -Uz compinit && compinit -u
zstyle ':completion:*' menu select

# 开启 Vi 模式
bindkey -v
export KEYTIMEOUT=1


# ---------------------------------------------------------
# 2. 插件加载
# ---------------------------------------------------------
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ---------------------------------------------------------
# 3. alias
# ---------------------------------------------------------
alias ls="ls -a -G"
alias ll="ls -l -a -G"

# ---------------------------------------------------------
# 4. 初始化 app
# ---------------------------------------------------------
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
