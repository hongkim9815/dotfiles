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

if [[ `uname` == "Darwin" ]]; then
    brew install vim
    brew install git
    brew install gitmoji

elif command apt > /dev/null; then
    sudo apt-get install vim
    sudo apt-get install git
    sudo apt-get install gitmoji

fi

install gitignore
install gitconfig
install vimrc
install zshrc
install ideavimrc

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

