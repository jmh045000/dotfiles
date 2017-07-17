#!/bin/sh

PRGDIR=$(cd $(dirname $(ls -1 $0)) ; pwd)

# general
ln -sfv ${PRGDIR}/general/profile ~/.profile

# zsh
ln -sfv ${PRGDIR}/zsh/zshrc ~/.zshrc

# git
ln -sfv ${PRGDIR}/git/gitconfig ~/.gitconfig
ln -sfv ${PRGDIR}/git/gitignore ~/.gitignore
