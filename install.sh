#!/bin/bash

DIRNAME="$(dirname "$0")"
DIR="$(cd "$DIRNAME" && pwd)"
PRIVATE_DIR="$HOME/.dotfiles-private"

backup_existing_path () {
  local path="$1"
  local backup="${path}.bak"

  if [[ -L "$path" ]]; then
    rm "$path"
  elif [[ -e "$path" ]]; then
    rm -rf "$backup"
    mv "$path" "$backup"
  fi
}

link_path () {
  local new="$1"
  local old="$2"

  mkdir -p "$(dirname "$old")"
  backup_existing_path "$old"
  ln -s "$new" "$old"
}

setup () {
  OLD="$HOME/.$1"
  NEW="$DIR/$1"
  [[ -s "$PRIVATE_DIR/$1" ]] && NEW="$PRIVATE_DIR/$1"

  link_path "$NEW" "$OLD"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install vim git zsh curl gnu-which mise gitmoji prettier
  brew upgrade vim git zsh curl gnu-which mise gitmoji prettier

  link_path "$DIR/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt-get update
  sudo apt install -y vim git zsh curl gcc build-essential
  (brew --version >> /dev/null 2>&1) || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -d "$HOME/.linuxbrew" ]] || [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    brew install mise gitmoji prettier
    brew upgrade mise gitmoji prettier

  fi
fi


# oh-my-zsh
[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[[ -f ~/.vim/autoload/plug.vim ]] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[[ -d ~/.zsh/zsh-autosuggestions ]] || git clone git@github.com:zsh-users/zsh-autosuggestions -- ~/.zsh/zsh-autosuggestions
[[ "$1" == "private" ]] && [[ ! -d ~/.dotfiles-private ]] && git clone git@github.com:hongkim9815/dotfiles-private -- ~/.dotfiles-private


setup gitignore
setup gitconfig
setup vimrc
setup zshrc
setup ideavimrc
setup theme.zshrc


# Claude settings
[[ -x "$DIR/install-agent.sh" ]] && "$DIR/install-agent.sh"

# Private Claude settings
PRIVATE_CLAUDE_DIR="$HOME/.dotfiles-private"
[[ -x "${PRIVATE_CLAUDE_DIR}/install.sh" ]] && "${PRIVATE_CLAUDE_DIR}/install.sh"

vim +PlugInstall +qall > /dev/null
chsh $USER -s $(which zsh)
exec zsh -l
