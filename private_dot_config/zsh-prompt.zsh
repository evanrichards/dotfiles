autoload -Uz vcs_info add-zsh-hook
setopt prompt_subst


zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ''
zstyle ':vcs_info:*' unstagedstr '+'

zstyle ':vcs_info:*' actionformats '(%b|%a)'

zstyle ':vcs_info:git*' formats '(%b%u)'
precmd () {
  if [[ $? -eq 0 ]]; then
      LAST_FAILED=''
      LAST_SUCCESS=''
  else
      LAST_FAILED=''
      LAST_SUCCESS=''
  fi
  vcs_info
}
# set success of last command to a global variable
export PROMPT='%1/ %F{blue}${vcs_info_msg_0_}%f %F{red}${LAST_FAILED}%f%F{green}${LAST_SUCCESS}%f '

# things to look into here: virtualenvs and right justified time of last command
# this is also cool: https://spaceship-prompt.sh/
