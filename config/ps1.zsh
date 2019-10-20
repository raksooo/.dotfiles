WD="%F{blue}%~%f"
SIGN="%F{yellow}>%f"

export PROMPT="$WD $SIGN "

RSEP="  "

RETURN="$RSEP%(?..%B%F{red}%?%f%b)"
#S1="%(?..%(1j.$RSEPERATOR.))"
JOBS="$RSEP%(1j.%F{yellow}%j job%(2j.s.)%f.)"

function GIT() {
  branch=$(git branch 2> /dev/null | grep \* | cut -d ' ' -f2)
  if [[ -n $branch ]]; then
    remote=$(git config --get branch.${branch}.remote)

    ahead=$(git rev-list --count $remote..HEAD)
    behind=$(git rev-list --count HEAD..$remote)

    #untrackedCount=$(git ls-files --others --exclude-standard | wc -l)
    #untracked=$([[ $untrackedCount -gt 0 ]] && echo "%F{red}*%f" || "")

    echo "$RSEP%F{green}$branch%f"
  fi
}

function precmd() {
  export RPS1="$RETURN$JOBS$(GIT)"
}

