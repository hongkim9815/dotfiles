#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval $(/usr/local/bin/brew shellenv)

  alias ls='ls -Ga'
  alias ll='ls -lGa'
  alias python2='/usr/bin/python'
  alias python='python3.7'
  alias pip='pip3'
  export PYTHONPATH="${PYTHONPATH}:~/usr/local/opt/python@3.7/bin"
  export LDFLAGS="-L/usr/local/opt/python@3.7/lib"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.7/lib/pkgconfig"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval $(/bin/brew shellenv)
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'

  alias kt='xmodmap -pke | grep 66'
  alias ks='~/.keymap.sh'

  alias ls='ls -a --color=auto'
  alias ll='ls -la --color=auto'
  alias python2='/usr/bin/python'
  alias python='/usr/bin/python3'
  alias pip='~/.local/bin/pip3.7'
  export PYTHONPATH="${PYTHONPATH}:~/.local/bin"

  # https://direnv.net/
  which direnv > /dev/null && eval "$(direnv hook zsh)"

fi

# Zsh
autoload -Uz compinit
compinit
setopt interactivecomments
PROMPT='%F{241}[%D{%H:%M:%S.%.}] %F{208}%n%f in %F{226}%~%f'$'\n''$ '
ZSH_THEME="agnoster"

# Ruby
PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Abbreviations
alias gst='git status'
alias gad='git add'
alias gad.='git add .'
alias gps='git push'
alias gpl='git pull'
alias gmo='gitmoji -c'
alias src='source ~/.zshrc'
alias zshrc='vi ~/.zshrc'
alias vimrc='vi ~/.vimrc'
alias keymap='~/.keymap.sh'

# Mistakes
alias sl='ls'
alias iv='vi'

# Workspaces
if [ -d ~/.dotfiles_private_setting ]; then
  source ~/.dotfiles_private_setting/*.zshrc
fi

dotfiles () {
  if [[ $1 == "" ]];
  then echo "Type command";
  else
    pushd ~/.dotfiles > /dev/null; eval $1;
    if [ -d ~/.dotfiles_private_setting ]; then pushd ~/.dotfiles_private_setting > /dev/null; eval $1; fi;
    popd > /dev/null; popd > /dev/null;
  fi
}

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="/usr/local/opt/python@3.7/bin:$PATH"

source <(kubectl completion zsh)
complete -F __start_kubectl kube

