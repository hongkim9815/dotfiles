#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval $(/usr/local/bin/brew shellenv)

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval $(/bin/brew shellenv)
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'

  alias kt='xmodmap -pke | grep 66'
  alias ks='~/.keymap.sh'

fi


# Zsh
PROMPT='%F{208}%n%f in %F{226}%~%f $ '
ZSH_THEME="agnoster"


# Ruby
PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# Abbreviations
alias ls='ls -G'
alias ll='ls -lG'
alias gst='git status'
alias gad='git add'
alias gps='git push'
alias gpl='git pull'
alias gmo='gitmoji -c'
alias src='source ~/.zshrc'
alias zshrc='vi ~/.zshrc'
alias vimrc='vi ~/.vimrc'


# Mistakes
alias sl='ls -G'


# Workspaces
if [ -d ~/.dotfiles_private_setting ]; then
  source ~/.dotfiles_private_setting/*.zshrc.sh
fi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

