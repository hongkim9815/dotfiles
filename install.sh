#!/bin/bash

DIRNAME="$(dirname "$0")"
DIR="$(cd "$DIRNAME" && pwd)"

setup () {
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
  brew install vim git zsh curl gnu-which asdf gitmoji
  brew update vim git zsh curl gnu-which asdf gitmoji

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt-get update
  sudo apt install -y vim git zsh curl
  (brew --version >> /dev/null 2>&1) || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


  if [[ -d "$HOME/.linuxbrew" ]] || [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    brew install asdf gitmoji
    brew update asdf gitmoji

  fi
fi


# oh-my-zsh
[[ -d ~/.oh-my-zsh ]] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[[ -f ~/.vim/autoload/plug.vim ]] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[[ -d ~/.zsh/zsh-autosuggestions ]] || git clone git@github.com:zsh-users/zsh-autosuggestions -- ~/.zsh/zsh-autosuggestions
[[ "$1" == "private" ]] && [[ ! -d ~/.dotfiles_private_setting ]] && git clone git@github.com:hongkim9815/dotfiles_private_setting -- ~/.dotfiles_private_setting


setup gitignore
setup gitconfig
setup vimrc
setup zshrc
setup ideavimrc
setup keymap.sh
setup theme.zshrc
[[ "$OSTYPE" == "linux-gnu"* ]] && setup xinitrc


vim +PlugInstall +qall > /dev/null
chsh $USER -s $(which zsh)
exec zsh -l

