## Paths
export DOTFILES=$HOME/.dotfiles

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.npm-global/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/

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

setopt auto_pushd
setopt cd_silent
setopt pushd_silent
setopt pushd_to_home

setopt complete_aliases
setopt complete_in_word
setopt correct
setopt extended_glob
setopt no_match

setopt notify
setopt no_beep
setopt prompt_subst

bindkey -v
KEYTIMEOUT=5

## History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

## Export variables for shell
export CLICOLOR=1

export EDITOR=nvim
export BROWSER=firefox
export TERMINAL=alacritty

export LANG='en_US.UTF-8'
export LANGUAGE=$LANG

## FZF
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

## Prompt
source $DOTFILES/ps1.zsh

## Make vim colors work in tmux
[ -n "$TMUX" ] && export TERM=screen-256color

## Aliases
source $DOTFILES/aliases

## Host specific config
[[ -f "$HOME/.morezshrc" ]] && source "$HOME/.morezshrc"
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.morealiases" ]] && source "$HOME/.morealiases"

## Vi
function _set_cursor() { [[ $TMUX = '' ]] && echo -ne $1 || echo -ne "\ePtmux;\e\e$1\e\\" }
function _set_block_cursor() { _set_cursor '\e[1 q' }
function _set_beam_cursor() { _set_cursor '\e[5 q' }
function _use_block_cursor() { [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]] }

function zle-keymap-select { _use_block_cursor && _set_block_cursor  || _set_beam_cursor }
function zle-line-init() { zle -K viins; _set_beam_cursor }
function zle-line-finish() { _set_block_cursor }

zle -N zle-keymap-select
zle -N zle-line-finish

precmd_functions+=(_set_beam_cursor)
