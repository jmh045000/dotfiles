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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# general
ln -sfv ${PRGDIR}/general/profile ~/.profile

# zsh
ln -sfv ${PRGDIR}/zsh/zshrc ~/.zshrc

# git
ln -sfv ${PRGDIR}/git/gitconfig ~/.gitconfig
ln -sfv ${PRGDIR}/git/gitignore ~/.gitignore
