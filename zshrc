#!/usr/bin/env bash


# Zsh
setopt interactivecomments
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


# Zsh Theme
plugins=(git)
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source $HOME/.theme.zshrc


# OS Dependency
if [[ "$OSTYPE" == "darwin"* ]]; then
  eval $(/usr/local/bin/brew shellenv)
  [[ -s "/usr/local/opt/asdf/libexec/asdf.sh" ]] && . /usr/local/opt/asdf/libexec/asdf.sh
  [[ -s "$HOME/.asdf/asdf.sh" ]] && . $HOME/.asdf/asdf.sh

  alias ls='ls -Ga'
  alias ll='ls -lGa'
  alias python2='/usr/bin/python'
  alias python='python3.7'
  alias pip='pip3'
  export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
  export PYTHONPATH="${PYTHONPATH}:~/usr/local/opt/python@3.7/bin"
  export LDFLAGS="-L/usr/local/opt/python@3.7/lib"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.7/lib/pkgconfig"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [[ -d "/home/linuxbrew/.linuxbrew" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  [[ -d "$HOME/.linuxbrew" ]] && eval $($HOME/.linuxbrew/bin/brew shellenv)

  [[ -d "/home/linuxbrew/.linuxbrew" ]] && . /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
  [[ -d "$HOME/.linuxbrew" ]] && . $HOME/.linuxbrew/opt/asdf/libexec/asdf.sh

  alias fn='echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode'
  alias kt='xmodmap -pke | grep 66'
  alias ks='~/.keymap.sh'
  alias ls='ls -a --color=auto'
  alias ll='ls -la --color=auto'
  alias python2='/usr/bin/python'
  alias python='/usr/bin/python3'
  alias pip='~/.local/bin/pip3.7'
  alias mouselag="sudo sh -c 'echo N> /sys/module/drm_kms_helper/parameters/poll; echo \"options drm_kms_helper poll=N\">/etc/modprobe.d/local.conf'"

  export PYTHONPATH="${PYTHONPATH}:~/.local/bin"
  export GOROOT='/usr/local/go'
  export GOPATH="$HOME/go"

fi


# Programs
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
(( $+commands[rbenv] )) && eval "$(rbenv init -)"

export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

which direnv > /dev/null && eval "$(direnv hook zsh)"

export GPG_TTY=$(tty)

# Abbreviations
alias cl='clear'
alias g-='git checkout -'
alias gst='git status'
alias gps='git push'
alias gpso='git push --set-upstream origin ${$(git symbolic-ref HEAD 2> /dev/null)/refs\/heads\/}'
alias gpl='git pull'
alias gmo='gitmoji -c'
alias src='source ~/.zshrc'
alias zshrc='vi ~/.zshrc'
alias vimrc='vi ~/.vimrc'
alias keymap='~/.keymap.sh'


# Mistakes
alias sl='ls'
alias iv='vi'
alias cd..='cd ..'


# Many Methods
function gad { git add $@; gst; }
function gad. { git add .; gst; }
function pushd { builtin pushd $@; ls; }
function popd { builtin popd $@; ls; }


# Private Workspaces
PRIVATE_VARIABLE_01="PRIVATE_VARIABLE_01"
PRIVATE_VARIABLE_02="PRIVATE_VARIABLE_02"
PRIVATE_VARIABLE_03="PRIVATE_VARIABLE_03"
PRIVATE_VARIABLE_04="PRIVATE_VARIABLE_04"

[[ -d "$HOME/.dotfiles_private_setting" ]] && source $HOME/.dotfiles_private_setting/*.zshrc


# Functions

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

