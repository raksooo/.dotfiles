#!/bin/sh

## Path
export DOTFILES=$HOME/.dotfiles

## Export variables for shell
eval $( dircolors -b $DOTFILES/dircolors-solarized/dircolors.256dark )
export CLICOLOR=1

export EDITOR=vim
export VISUAL=vim

export LANG='en_US.UTF-8'
export LANGUAGE=$LANG

export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export PATH=$PATH:~/.cabal/bin

## Make vim colors work in tmux
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

source $DOTFILES/aliases
source liquidprompt

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

