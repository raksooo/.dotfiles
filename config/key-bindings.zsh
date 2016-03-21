function prepend-sudo {
    if [[ $BUFFER != "sudo "* ]]; then
        BUFFER="sudo -E $BUFFER"
        zle end-of-line
    fi
}

function paste {
    BUFFER="$BUFFER$(xclip -selection clipboard -o)"
    zle end-of-line
}

zle -N prepend-sudo
zle -N paste

bindkey "^[§" prepend-sudo
bindkey "^[p" paste

