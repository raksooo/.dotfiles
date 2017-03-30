#######################################
# LIQUID PROMPT DEFAULT TEMPLATE FILE #
#######################################

# Available features:
# LP_BATT battery
# LP_LOAD load
# LP_JOBS screen sessions/running jobs/suspended jobs
# LP_USER user
# LP_HOST hostname
# LP_PERM a colon ":"
# LP_PWD current working directory
# LP_VENV Python virtual environment
# LP_PROXY HTTP proxy
# LP_VCS the content of the current repository
# LP_ERR last error code
# LP_MARK prompt mark
# LP_TIME current time
# LP_RUNTIME runtime of last command
# LP_MARK_PREFIX user-defined prompt mark prefix (helpful if you want 2-line prompts)
# LP_PS1_PREFIX user-defined general-purpose prefix (default set a generic prompt as the window title)
# LP_PS1_POSTFIX user-defined general-purpose postfix
# LP_BRACKET_OPEN open bracket
# LP_BRACKET_CLOSE close bracket

# Remember that most features come with their corresponding colors,
# see the README.

# add time, jobs, load and battery
LP_PS1=""
if [[ $LP_ERR ]]; then
    LP_PS1="${LP_PS1}${LP_COLOR_ERR} └─╼━${LP_ERR}"$'\n'
fi
LP_PS1="${LP_PS1} ${LP_PS1_PREFIX}"
LP_PS1="${LP_PS1}${LP_JOBS}"
if [[ "$TERM" == screen* ]]; then
    LP_PS1="${LP_PS1}${LP_BRACKET_OPEN} "
fi

LP_PS1="${LP_PS1}${LP_COLOR_TIME}${LP_PWD}${NO_COL}"

# Add VCS infos
# If root, the info has not been collected unless LP_ENABLE_VCS_ROOT
# is set.
LP_PS1="${LP_PS1}${LP_VCS}"

# add return code and prompt mark
LP_PS1="${LP_PS1}${LP_RUNTIME}${LP_MARK_PREFIX}${LP_MARK}${LP_PS1_POSTFIX}"

# vim: set et sts=4 sw=4 tw=120 ft=sh:

