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
    brew install vim git zsh curl gnu-which asdf
    brew update vim git zsh curl gnu-which

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update
    sudo apt install -y vim git zsh curl

    if [[ -d ~/.linuxbrew ]]; then
        git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
        mkdir ~/.linuxbrew/bin
        ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
    fi

    brew install asdf
fi

# oh-my-zsh
[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[[ -f ~/.vim/autoload/plug.vim ]] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[[ -d ~/.zsh/zsh-autosuggestions ]] || git clone git@github.com:zsh-users/zsh-autosuggestions -- ~/.zsh/zsh-autosuggestions
[[ "$1" == "private" ]] && [[ ! -d ~/.dotfiles_private_setting ]] && git clone git@github.com:hongkim9815/dotfiles_private_setting -- ~/.dotfiles_private_setting

install gitignore
install gitconfig
install vimrc
install zshrc
install ideavimrc
install keymap.sh
install theme.zshrc

vim +PlugInstall +qall > /dev/null
chsh $USER -s $(which zsh)
exec zsh -l

