#!/usr/bin/env bash

# Setting for MacOS
if [ "$(uname)" = "Darwin" ]; then
    eval $(/usr/local/bin/brew shellenv)
    export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Setting for Linux
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    eval $(/bin/brew shellenv)
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'

fi

which direnv > /dev/null && eval "$(direnv hook zsh)"

PROMPT='%m:%1~ %n$ '
ZSH_THEME="agnoster"

alias ls='ls -G'
alias ll='ls -lG'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "/home/eric/.sdkman/bin/sdkman-init.sh" ]] && source "/home/eric/.sdkman/bin/sdkman-init.sh"

PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

