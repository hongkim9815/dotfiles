DEFAULT_BG='000'
CURRENT_BG='NONE'
DEFAULT_FG='015'
CURRENT_FG='NONE'

prompt_echo() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}\ue0b0%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_time() {
  prompt_echo 240 000 "%D{%H:%M:%S.%.}"
}

prompt_status() {
  local -a symbols
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
  [[ -n "$symbols" ]] && prompt_echo 000 015 "$symbols"
}

prompt_context() { prompt_echo 209 000 "%n" }

prompt_dir() {
  if [[ "$(pwd)" = *${PRIVATE_VARIABLE_03}* ]]; then
    dir_bg=196
    dir_fg=231
  elif [[ "$(pwd)" = *${PRIVATE_VARIABLE_04}* ]]; then
    dir_bg=21
    dir_fg=231
  else
    dir_bg=075
    dir_fg=000
  fi

  prompt_echo ${dir_bg} ${dir_fg} '%~'
}

prompt_git() {
  [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]] || return
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
  if [[ "${ref/refs\/heads\/}" = 'master' ]]; then
    prompt_echo 203 000 "\ue0a0 ${ref/refs\/heads\/}"
  elif [[ "${ref/refs\/heads\/}" = 'main' ]]; then
    prompt_echo 203 000 "\ue0a0 ${ref/refs\/heads\/}"
  else
    prompt_echo 155 000 "\ue0a0 ${ref/refs\/heads\/}"
  fi
}

prompt_end() {
  [[ -n $CURRENT_BG ]] && echo -n " %{%K{$DEFAULT_BG}%F{$CURRENT_BG}%}\ue0b0 "
  echo -n "%{%K{$DEFAULT_BG}%F{$DEFAULT_FG}%}"
  CURRENT_BG='NONE'
  CURRENT_FG='NONE'
}


build_prompt() {
  RETVAL=$?
  echo -n "%{%F{$DEFAULT_FG}%K{$DEFAULT_BG}%}"
  prompt_time
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
  echo -n "\n$ "
}

PROMPT='$(build_prompt)'

