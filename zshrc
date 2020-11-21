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
  [[ -s "/bin/brew" ]] && eval $(/bin/brew shellenv)
  [[ -d "/bin/linuxbrew" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'

  alias kt='xmodmap -pke | grep 66'
  alias ks='~/.keymap.sh'

  alias ls='ls -a --color=auto'
  alias ll='ls -la --color=auto'
  alias python2='/usr/bin/python'
  alias python='/usr/bin/python3'
  alias pip='~/.local/bin/pip3.7'
  export PYTHONPATH="${PYTHONPATH}:~/.local/bin"

fi


# Zsh
which direnv > /dev/null && eval "$(direnv hook zsh)"
setopt interactivecomments
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


# Zsh Theme
plugins=(git)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source $HOME/.theme.zshrc


# Programs
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
(( $+commands[rbenv] )) && eval "$(rbenv init -)"

export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Abbreviations
alias gst='git status'
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


# Many Methods
function gad { git add $@; gst; }
function gad. { git add .; gst; }
function pushd { builtin pushd $@; ls; }
function popd { builtin popd $@; ls; }


# Private Workspaces
PRIVATE_VARIABLE_01="PRIVATE_VARIABLE_01"
PRIVATE_VARIABLE_02="PRIVATE_VARIABLE_02"

[[ -d "$HOME/.dotfiles_private_setting" ]] && source $HOME/.dotfiles_private_setting/*.zshrc

function dot () {
  if [[ $1 == "" ]];
  then echo "Type command";
  else
    builtin pushd ~/.dotfiles > /dev/null; eval $1;
    builtin popd > /dev/null;
  fi
}

function dps () {
  if [[ $1 == "" ]];
  then echo "Type command";
  else
    builtin pushd ~/.dotfiles_private_setting > /dev/null; eval $1;
    builtin popd > /dev/null;
  fi
}


# alias functions
function cd {
  PREVIOUS_PATH=$(pwd)
  builtin cd "$@"
  if [[ $(pwd) != $PREVIOUS_PATH ]]; then
    ls
    if [[ $PREVIOUS_PATH != "$PRIVATE_VARIABLE_01"* && $(pwd) == "$PRIVATE_VARIABLE_01"* ]];
    then
      source <(kubectl completion zsh)
      complete -F __start_kubectl $PRIVATE_VARIABLE_02
    fi
  fi
}

