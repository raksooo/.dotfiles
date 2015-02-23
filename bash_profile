[[ -f ~/.bashrc ]] && . ~/.bashrc

## Paths
export DOTFILES=$HOME/.dotfiles

## Export variables for shell
eval $( dircolors -b $HOME/.dotfiles/dircolors-solarized/dircolors.256dark )
export CLICOLOR=1

export EDITOR=vim
export VISUAL=vim

export LANG='en_GB.UTF-8'
export LANGUAGE=$LANG

## Make vim colors work in tmux
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

## Aliases
source $DOTFILES/aliases
source $DOTFILES/aliases_rpi

## LiquidPrompt
source ~/.dotfiles/liquidprompt/liquidprompt

if [ -z "$TMUX" ]; then
    exec tmux
fi
