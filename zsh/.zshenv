if [[ -z "$XDG_CONFIG_HOME" ]]
then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi

if [[ -f "$ZDOTDIR/.zshenv" ]]
then
    source $ZDOTDIR/.zshenv
fi
