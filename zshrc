eval $(/bin/brew shellenv)
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# https://direnv.net/
which direnv > /dev/null && eval "$(direnv hook zsh)"

PROMPT='%m:%1~ %n$ '

