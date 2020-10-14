#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval $(/usr/local/bin/brew shellenv)

  alias ls='ls -Ga'
  alias ll='ls -lGa'

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval $(/bin/brew shellenv)
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'

  alias kt='xmodmap -pke | grep 66'
  alias ks='~/.keymap.sh'

  alias ls='ls -a --color=auto'
  alias ll='ls -la --color=auto'

fi

# Zsh
PROMPT='%F{208}%n%f in %F{226}%~%f $ '
ZSH_THEME="agnoster"

# Ruby
PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Abbreviations
alias gst='git status'
alias gad='git add'
alias gps='git push'
alias gpl='git pull'
alias gmo='gitmoji -c'
alias src='source ~/.zshrc'
alias zshrc='vi ~/.zshrc'
alias vimrc='vi ~/.vimrc'
alias keymap='~/.dotfiles/keymap.sh'
alias python2='/usr/bin/python'
alias python='/usr/bin/python3'
alias pip='~/.local/bin/pip3.7'
export PYTHONPATH="${PYTHONPATH}:~/.local/bin"

# Mistakes
alias sl='ls -Ga'
alias iv='vi'

# Workspaces
if [ -d ~/.dotfiles_private_setting ]; then
  source ~/.dotfiles_private_setting/*.zshrc.sh
fi

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

