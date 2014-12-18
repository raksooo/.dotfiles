## Paths
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export DOTFILES=$HOME/.dotfiles
export JAVA_HOME=$(/usr/libexec/java_home)

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
bindkey -e

## History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

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
source $HOME/.dotfiles/aliases

## LiquidPrompt
source ~/.dotfiles/liquidprompt/liquidprompt
