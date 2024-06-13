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
  [[ -s "/usr/local/bin/brew" ]] && HOMEBREW_DIR="/usr/local"
  [[ -d "/opt/homebrew" ]] && [[ -s "/opt/homebrew/bin/brew" ]] && HOMEBREW_DIR="/opt/homebrew"

  eval $($HOMEBREW_DIR/bin/brew shellenv)

  [[ -s "/usr/local/opt/asdf/libexec/asdf.sh" ]] && . /usr/local/opt/asdf/libexec/asdf.sh
  [[ -s "$HOMEBREW_DIR/opt/asdf/libexec/asdf.sh" ]] && . $HOMEBREW_DIR/opt/asdf/libexec/asdf.sh
  [[ -s "$HOME/.asdf/asdf.sh" ]] && . $HOME/.asdf/asdf.sh

  export PATH="$HOMEBREW_DIR/opt/openssl@3/bin:$PATH"
  export PATH="$HOMEBREW_DIR/opt/libxslt/bin:$PATH"
  alias ls='ls -Ga'
  alias ll='ls -lGa'
  alias python2='/usr/bin/python'
  alias python='python3.7'
  alias pip='pip3'
  alias nsl='sudo pmset -c disablesleep 1'
  alias ysl='sudo pmset -c disablesleep 0'
  alias emul='./Library/Android/sdk/emulator/emulator -list-avds | xargs ./Library/Android/sdk/emulator/emulator -avd'
  export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
  export PYTHONPATH="${PYTHONPATH}:~/usr/local/opt/python@3.7/bin"
  export LDFLAGS="-L/usr/local/opt/python@3.7/lib"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.7/lib/pkgconfig"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [[ -d "/home/linuxbrew/.linuxbrew" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  [[ -d "$HOME/.linuxbrew" ]] && eval $($HOME/.linuxbrew/bin/brew shellenv)

  [[ -d "/home/linuxbrew/.linuxbrew" ]] && . /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
  [[ -d "$HOME/.linuxbrew" ]] && . $HOME/.linuxbrew/opt/asdf/libexec/asdf.sh

  alias ls='ls -a --color=auto'
  alias ll='ls -la --color=auto'

fi


# Programs
export GPG_TTY=$(tty)
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
(( $+commands[rbenv] )) && eval "$(rbenv init -)"

export SDKMAN_DIR="/home/eric/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

which direnv > /dev/null && eval "$(direnv hook zsh)"

# Abbreviations
alias cl='clear'
alias g-='git checkout -'
alias gst='git status'
alias gps='git push'
alias gpso='git push --set-upstream origin ${$(git symbolic-ref HEAD 2> /dev/null)/refs\/heads\/}'
alias gpl='git pull'
alias gmo='gitmoji -c'
alias gbl='git branch'
alias gbr='git branch -r'
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

function dot {
  if [[ $1 == "" ]];
  then echo "Type command";
  else
    builtin pushd ~/.dotfiles > /dev/null; eval $1;
    builtin popd > /dev/null;
  fi
}

function dps {
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
  fi
}

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools

