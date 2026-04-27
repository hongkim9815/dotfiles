#!/usr/bin/env bash


# Zsh
setopt interactivecomments
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
  [[ -d "/opt/homebrew" ]] && [[ -s "/opt/homebrew/bin/brew" ]] && eval $(/opt/homebrew/bin/brew shellenv)

  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOMEBREW_DIR/opt/openssl@3/bin:$PATH"
  export PATH="$HOMEBREW_DIR/opt/libxslt/bin:$PATH"

  alias ls='ls -Ga'
  alias ll='ls -lGa'

  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/opt/homebrew/opt/mysql@8.0/lib/pkgconfig"
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/opt/homebrew/opt/mysql-client@8.0/lib/pkgconfig"


elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [[ -d "/home/linuxbrew/.linuxbrew" ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  [[ -d "$HOME/.linuxbrew" ]] && eval $($HOME/.linuxbrew/bin/brew shellenv)

  alias ls='ls -a --color=auto'
  alias ll='ls -la --color=auto'

fi


# Programs
eval "$(mise activate zsh)"
export GPG_TTY=$(tty)

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
alias cc='claude'
alias cx='codex'


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

[[ -d "$HOME/.dotfiles-private" ]] && source $HOME/.dotfiles-private/*.zshrc


# Programs
#   Springboot
alias gradlew='./gradlew'
alias ktlint='./gradlew clean ktlintFormat'
alias tt='./gradlew clean check'


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
    builtin pushd ~/.dotfiles-private > /dev/null; eval $1;
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

alias cws='~/claude-workspace'

upgrade-claude() {
    brew upgrade claude-code@latest
    local claude_bin="$(brew --prefix)/bin/claude"
    [[ -f "$claude_bin" ]] && xattr -d com.apple.quarantine "$claude_bin" 2>/dev/null
    return 0
}

upgrade-codex() {
    brew upgrade codex
    local codex_bin="$(brew --prefix)/bin/codex"
    [[ -f "$codex_bin" ]] && xattr -d com.apple.quarantine "$codex_bin" 2>/dev/null
    return 0
}

