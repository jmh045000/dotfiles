#!/bin/sh

PRGDIR=$(cd $(dirname $(ls -1 $0)) ; pwd)

( cd ${PRGDIR} ; git pull )

function install_package() {
    local package="$1"
    echo "Installing ${package} with sudo"
    if [ -x "$(which apt-get)" ] ; then
        sudo apt-get install ${package}
    elif [ -x "$(which yum)" ] ; then
        sudo yum install ${package}
    fi
}

zsh_exists=$(which zsh)
if [ -z "$zsh_exists" ] ; then
    install_package zsh
fi

if [ ! -e ~/.oh-my-zsh ] ; then
    echo "Installing oh-my-zsh"
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

fzf_exists=$(which fzf)
if [ -z "$fzf_exists" ] ; then
    install_package fzf
fi

ag_exists=$(which ag)
if [ -z "$ag_exists" ] ; then
    if [ -x "$(which apt-get)" ] ; then
        install_package silversearcher-ag
    elif [ -x "$(which yum)" ] ; then
        install_package the_silver_searcher
    fi
fi

# general
ln -sfv ${PRGDIR}/general/profile ~/.profile

# zsh
ln -sfv ${PRGDIR}/zsh/zshrc ~/.zshrc

# git
ln -sfv ${PRGDIR}/git/gitconfig ~/.gitconfig
ln -sfv ${PRGDIR}/git/gitignore ~/.gitignore

if [ -z "$(git config user.email)" ] ; then
    echo -n "Git Email> "
    read git_email
    git config --file ~/.gitconfig.local user.email $git_email
fi

if [ -z "$(git config user.name)" ] ; then
    echo -n "Git Name > "
    read git_name
    git config --file ~/.gitconfig.local user.name $git_name
fi

# vim
if [ ! -e ~/.vim/bundle/Vundle.vim ] ; then
    echo "Installing vundle"
    mkdir -p ~/.vim/bundle
    git clone https://github.com/vundlevim/vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
ln -sfv ${PRGDIR}/vim/vimrc ~/.vimrc
ln -sfv ${PRGDIR}/vim/gvimrc ~/.gvimrc
ln -sfv ${PRGDIR}/vim/bundles.vim ~/bundles.vim

# i3
mkdir -p ~/.config/i3
ln -sfv "${PRGDIR}/i3/config" ~/.config/i3/config
