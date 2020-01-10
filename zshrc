## Paths
export DOTFILES=$HOME/.dotfiles

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.npm-global/bin

export npm_config_prefix=~/.npm-global

## Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit

fpath=(/usr/local/share/zsh-completions $fpath)

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
setopt prompt_subst
bindkey -e

## History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

## Export variables for shell
export CLICOLOR=1

export EDITOR=nvim
export BROWSER=firefox
export TERMINAL=termite

export LANG='en_US.UTF-8'
export LANGUAGE=$LANG

## FZF
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

## Prompt
source ~/.config/ps1.zsh

## Make vim colors work in tmux
[ -n "$TMUX" ] && export TERM=screen-256color

## Aliases & keybindings
source $DOTFILES/aliases
source $DOTFILES/key-bindings.zsh

## Start X
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    startx
fi

