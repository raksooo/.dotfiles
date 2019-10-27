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

    if [[ ahead -gt 0 && behind -gt 0 ]]; then
      commits="(%F{yellow}$ahead%f,%F{red}$behind%f)"
      branchColor="yellow"
    elif [[ ahead -gt 0 ]]; then
      commits="(%F{yellow}$ahead%f)"
      branchColor="yellow"
    elif [[ behind -gt 0 ]]; then
      commits="(%F{red}$behind%f)"
      branchColor="yellow"
    else
      commits=""
      branchColor="green"
    fi

    untrackedCount=$(git ls-files --others --exclude-standard | wc -l)
    untracked=$([[ $untrackedCount -gt 0 ]] && echo "%F{red}*%f" || echo "")

    unstagedCount=$(git ls-files . -m | wc -l)
    unstaged=$([[ $unstagedCount -gt 0 ]] && echo "%F{yellow}*%f" || echo "")

    stagedCount=$(git diff --name-only --staged | wc -l)
    staged=$([[ $stagedCount -gt 0 ]] && echo "%F{green}*%f" || echo "")

    conflict=$([[ $(git diff --name-only --diff-filter=U | wc -l) -gt 0 ]])
    if [[ $conflict ]]; then
      branchColor="red"
    fi


    echo "$RSEP%F{$branchColor}$branch%f$commits$staged$unstaged$untracked"
  fi
}

function precmd() {
  export RPS1="$RETURN$JOBS$(GIT)"
}

