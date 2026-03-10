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
  # [[ -s "/usr/local/bin/brew" ]] && eval $(/usr/local/bin/brew shellenv)
  [[ -d "/opt/homebrew" ]] && [[ -s "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

  [[ -s "/usr/local/opt/asdf/libexec/asdf.sh" ]] && . /usr/local/opt/asdf/libexec/asdf.sh
  [[ -s "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]] && . /opt/homebrew/opt/asdf/libexec/asdf.sh
  [[ -s "$HOME/.asdf/asdf.sh" ]] && . $HOME/.asdf/asdf.sh

  export PATH="$HOMEBREW_DIR/opt/openssl@3/bin:$PATH"
  export PATH="$HOMEBREW_DIR/opt/libxslt/bin:$PATH"
  alias ls='ls -Ga'
  alias ll='ls -lGa'

  alias python='python3'
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/opt/homebrew/opt/mysql@8.0/lib/pkgconfig"
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/opt/homebrew/opt/mysql-client@8.0/lib/pkgconfig"

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
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
(( $+commands[rbenv] )) && eval "$(rbenv init -)"

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
alias c='claude'


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
PRIVATE_VARIABLE_03="PRIVATE_VARIABLE_03"
PRIVATE_VARIABLE_04="PRIVATE_VARIABLE_04"

[[ -d "$HOME/.dotfiles_private_setting" ]] && source $HOME/.dotfiles_private_setting/*.zshrc


# Programs
#   Python
alias python='python3'
alias pip='pip3'
#   Springboot
alias gradlew='./gradlew'
alias ktlint='./bin/ktlint'
alias tt='./bin/test'


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



