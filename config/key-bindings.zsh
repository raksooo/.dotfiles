function prepend-sudo {
    if [[ $BUFFER != "sudo "* ]]; then
        BUFFER="sudo -E $BUFFER"
        zle end-of-line
    fi
}

function paste {
    CLIP=$(xclip -selection clipboard -o 2> /dev/null)
    BUFFER="$BUFFER$CLIP"
    zle end-of-line
}

zle -N prepend-sudo
zle -N paste

bindkey "^[§" prepend-sudo
bindkey "^[p" paste

