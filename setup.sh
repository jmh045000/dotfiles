#!/bin/bash

PRGDIR="$(cd "$(dirname "$(ls -1 "$0")")" && pwd)"

while [[ $# -gt 0 ]] ; do
    key="$1"
    case "$key" in
        -e|--email)
            EMAIL="$2"
            shift
            shift
            ;;
        -n|--name)
            NAME="$2"
            shift
            shift
            ;;
        -s|--http-sslverify)
            HTTP_SSLVERIFY="$2"
            shift
            shift
            ;;
        *)
            echo "Unsupported argument $key"
            echo "Usage:"
            echo "    $0 [-e|--email <git email>] [-n|--name <git name>] [-s|--http-sslverify <0|1>]"
            exit 1
            ;;
    esac
done

( cd "${PRGDIR}" && git pull )

install_package() {
    local package="$1"
    echo "Installing ${package} with sudo"
    if [ -r "/etc/debian-release" ] ; then
        sudo apt-get install "${package}"
    elif [ -r "/etc/redhat-release" ] ; then
        sudo yum install "${package}"
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
ln -sfv "${PRGDIR}/general/profile" ~/.profile

# zsh
ln -sfv "${PRGDIR}/zsh/zshrc" ~/.zshrc

# git
ln -sfv "${PRGDIR}/git/gitconfig" ~/.gitconfig
ln -sfv "${PRGDIR}/git/gitignore" ~/.gitignore

if [ -n "${EMAIL}" ] || [ -z "$(git config user.email)" ] ; then
    if [ -z "${EMAIL}" ] ; then
        echo -n "Git Email> "
        read -r EMAIL
    fi
    git config --file ~/.gitconfig.local user.email "$EMAIL"
fi

if [ -n "${NAME}" ] || [ -z "$(git config user.name)" ] ; then
    if [ -z "${NAME}" ] ; then
        echo -n "Git Name > "
        read -r NAME
    fi
    git config --file ~/.gitconfig.local user.name "$NAME"
fi

if [ -n "${HTTP_SSLVERIFY}" ] || [ -z "$(git config http.sslVerify)" ] ; then
    if [ -z "${HTTP_SSLVERIFY}" ] ; then
        echo -n "Git SSL verify (0|1) > "
        read -r HTTP_SSLVERIFY
    fi
    git config --file ~/.gitconfig.local http.sslVerify "$HTTP_SSLVERIFY"
fi

# vim
if [ ! -e ~/.vim/bundle/Vundle.vim ] ; then
    echo "Installing vundle"
    mkdir -p ~/.vim/bundle
    git clone https://github.com/vundlevim/vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
ln -sfv "${PRGDIR}/vim/vimrc" ~/.vimrc
ln -sfv "${PRGDIR}/vim/gvimrc" ~/.gvimrc
ln -sfv "${PRGDIR}/vim/bundles.vim" ~/bundles.vim

# i3
mkdir -p ~/.config/i3
ln -sfv "${PRGDIR}/i3/config" ~/.config/i3/config
