# Better ls
alias ls='eza --icons=always'

# Detailed listing
alias ll='eza -lh --icons=always --git'

# Detailed listing including hidden files
alias la='eza -lah --icons=always --git'

# Tree view
alias tree='eza --tree --icons=always'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -'  # -- prevents - being parsed as a flag; cd - jumps to previous directory

lf() { # zsh follow lf navigation
    tmp=$(mktemp)
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir=$(cat "$tmp")
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# =========================================================
# Editor
# =========================================================

alias vim='nvim'

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# wt <branch> [path] — create a git worktree and cd into it
# - path defaults to ../repo-branch alongside the current repo
# - creates the branch if it doesn't exist
wt() {
  local branch="${1:?Usage: wt <branch> [path]}"
  local repo_root repo_name worktree_path

  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "wt: not inside a git repo" >&2
    return 1
  }
  repo_name=$(basename "$repo_root")

  # Use provided path, or default to ../repo-branch
  worktree_path="${2:-$(dirname "$repo_root")/${repo_name}-${branch}}"

  # Add worktree; if branch doesn't exist, create it (-b)
  if git show-ref --quiet --verify "refs/heads/${branch}"; then
    git worktree add "$worktree_path" "$branch"
  else
    git worktree add -b "$branch" "$worktree_path"
  fi && builtin cd "$worktree_path"
}

# =========================================================
# Video
# =========================================================

alias stream='mpv av://v4l2:/dev/video4 --fullscreen --demuxer-lavf-o=input_format=mjpeg,framerate=30 --profile=low-latency --untimed'

# =========================================================
# skills
# =========================================================
alias skills='npx skills'
