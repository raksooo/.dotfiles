function prepend {
    if [[ $BUFFER != "$1"* ]]; then
        BUFFER="$1 $BUFFER"
        zle end-of-line
    fi
}

function paste {
    CLIP=$(xclip -selection clipboard -o 2> /dev/null)
    BUFFER="$BUFFER$CLIP"
    zle end-of-line
}

function prepend-sudo {
    prepend "sudo"
}

function prepend-sudoE {
    prepend "sudo -E"
}

zle -N prepend-sudoE
zle -N prepend-sudo
zle -N paste

bindkey "^[§" prepend-sudo
bindkey "^[½" prepend-sudoE
bindkey "^[p" paste

