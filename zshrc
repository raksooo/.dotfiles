## Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit

## Set options
setopt append_history
setopt auto_cd
setopt complete_aliases
setopt complete_in_word
setopt correct
setopt extended_glob
setopt no_match
setopt notify
setopt no_beep
bindkey -e

## History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

## Export variables for shell
eval $( dircolors -b $HOME/.dotfiles/LS_COLOURS/LS_COLORS )
export CLICOLOR=1

export EDITOR=vim
export VISUAL=less

export LANG='en_GB.UTF-8'
export LANGUAGE=$LANG

## Aliases
source $HOME/.dotfiles/aliases

## LiquidPrompt
source ~/.dotfiles/liquidprompt/liquidprompt
