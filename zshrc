#!/usr/bin/env bash

if [ "$(uname)" = "Darwin" ]; then
    eval $(/usr/local/bin/brew shellenv)

elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    eval $(/bin/brew shellenv)
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'

fi

which direnv > /dev/null && eval "$(direnv hook zsh)"

PROMPT='%m:%1~ %n$ '
ZSH_THEME="agnoster"
PATH="$HOME/.rbenv/bin:$PATH"

alias ls='ls -G'
alias ll='ls -lG'

eval "$(rbenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "/home/eric/.sdkman/bin/sdkman-init.sh" ]] && source "/home/eric/.sdkman/bin/sdkman-init.sh"

eval "$(rbenv init -)"

