#!/bin/sh

PRGDIR=$(cd $(dirname $(ls -1 $0)) ; pwd)

zsh_exists=$(which zsh)
if [ -z "$zsh_exists" ] ; then
    echo "Installing zsh with sudo"
    if [ -x "$(which apt-get)" ] ; then
        sudo apt-get install zsh
    elif [ -x "$(which yum)" ] ; then
        sudo yum install zsh
    fi
fi

if [ ! -e ~/.oh-my-zsh ] ; then
    echo "Installing oh-my-zsh"
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# general
ln -sfv ${PRGDIR}/general/profile ~/.profile

# zsh
ln -sfv ${PRGDIR}/zsh/zshrc ~/.zshrc

# git
ln -sfv ${PRGDIR}/git/gitconfig ~/.gitconfig
ln -sfv ${PRGDIR}/git/gitignore ~/.gitignore

# vim
if [ ! -e ~/.vim/bundle/Vundle.vim ] ; then
    echo "Installing vundle"
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/vim/bundle/Vundle.vim
fi
ln -sfv ${PRGDIR}/vim/vimrc ~/.vimrc
ln -sfv ${PRGDIR}/vim/gvimrc ~/.gvimrc
ln -sfv ${PRGDIR}/vim/bundles.vim ~/bundles.vim
