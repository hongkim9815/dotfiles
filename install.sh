#!/bin/bash
DIRNAME="$(dirname "$0")"
DIR="$(cd "$DIRNAME" && pwd)"

install () {
  OLD="$HOME/.$1"
  NEW="$DIR/$1"
  if [ -f $OLD ]; then
    if [ -L $OLD ]; then
      rm $OLD
    else
      mv $OLD "$OLD.bak"
    fi
  fi
  ln -s $NEW $OLD
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install vim git zsh
    brew update vim git zsh

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update
    sudo apt install -y vim git zsh

fi

install gitignore
install gitconfig
install vimrc
install zshrc
install ideavimrc
install keymap.sh
install theme.zshrc

if [ -d ~/.zsh/zsh-autosuggestions ]; then
  cd ~/.zsh/zsh-autosuggestions && git pull
else
  if [ ! -d ~/.zsh ]; then
    mkdir ~/.zsh
  fi
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ "$1" == "private" ]; then
  if [ -d ~/.dotfiles_private_setting ]; then
    cd ~/.dotfiles_private_setting && git pull
  else
    git clone git@github.com:hongkim9815/dotfiles_private_setting -- ~/.dotfiles_private_setting
  fi
fi

source $HOME/.zshrc

