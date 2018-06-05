#!/bin/bash

set -e

PRGDIR="$(cd "$(dirname "$(ls -1 "$0")")" && pwd)"

OS=$(uname)

UPDATE="yes"
USER="$(whoami)"
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
        -u|--user)
            USER="$2"
            shift
            shift
            ;;
        --no-update)
            UPDATE="no"
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

if [ "${OS}" = "Darwin" ] ; then
    MD5="md5"
else
    MD5="md5sum"
fi

if [ "${UPDATE}" = "yes" ] ; then
    orig_hash="$(${MD5} "$0")"
    ( cd "${PRGDIR}" && git pull )
    new_hash="$(${MD5} "$0")"
    if [ "$orig_hash" != "$new_hash" ] ; then
        exec "$0" "$*"
    fi
fi

install_package() {
    local package="$1"
    echo "Installing ${package} with sudo"
    if [ -r "/etc/debian-release" ] ; then
        sudo apt-get install "${package}"
    elif [ -r "/etc/redhat-release" ] ; then
        sudo yum install -y "${package}"
    fi
}

# general
mkdir -p ${HOME}/bin
ln -snfv "${PRGDIR}/general/profile" ${HOME}/.profile

# zsh
set +e
zsh_exists=$(which zsh)
set -e
if [ -z "$zsh_exists" ] ; then
    install_package zsh
    sudo chsh $(whoami) -s /bin/zsh
fi

if [ ! -e ${HOME}/.oh-my-zsh ] ; then
    echo "Installing oh-my-zsh"
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
fi
ln -snfv "${PRGDIR}/zsh/zshrc" ${HOME}/.zshrc

# git
ln -snfv "${PRGDIR}/git/gitconfig" ${HOME}/.gitconfig
ln -snfv "${PRGDIR}/git/gitignore" ${HOME}/.gitignore

if [ -n "${EMAIL}" -a "${EMAIL}" != "$(git config user.email)" ] || [ -z "$(git config user.email)" ] ; then
    if [ -z "${EMAIL}" ] ; then
        echo -n "Git Email> "
        read -r EMAIL
    fi
    git config --file ${HOME}/.gitconfig.local user.email "$EMAIL"
fi

if [ -n "${NAME}" -a "${NAME}" != "$(git config user.name)" ] || [ -z "$(git config user.name)" ] ; then
    if [ -z "${NAME}" ] ; then
        echo -n "Git Name > "
        read -r NAME
    fi
    git config --file ${HOME}/.gitconfig.local user.name "$NAME"
fi

if [ -n "${HTTP_SSLVERIFY}" -a "${HTTP_SSLVERIFY}" != "$(git config http.sslVerify)" ] || [ -z "$(git config http.sslVerify)" ] ; then
    if [ -z "${HTTP_SSLVERIFY}" ] ; then
        echo -n "Git SSL verify (0|1) > "
        read -r HTTP_SSLVERIFY
    fi
    git config --file ${HOME}/.gitconfig.local http.sslVerify "$HTTP_SSLVERIFY"
fi

# vim
set +e
fzf_exists=$(which fzf)
set -e
if [ -z "$fzf_exists" ] ; then
    [ ! -d ${HOME}/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
    ${HOME}/.fzf/install --bin
    ln -snfv ${HOME}/.fzf/bin/fzf ${HOME}/bin/
fi

set +e
ag_exists=$(which ag)
set -e
if [ -z "$ag_exists" ] ; then
    install_package the_silver_searcher
fi
if [ ! -e ${HOME}/.vim/bundle/Vundle.vim ] ; then
    echo "Installing vundle"
    mkdir -p ${HOME}/.vim/bundle
    git clone https://github.com/vundlevim/vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
fi
ln -snfv "${PRGDIR}/vim/vimrc" ${HOME}/.vimrc
ln -snfv "${PRGDIR}/vim/gvimrc" ${HOME}/.gvimrc
ln -snfv "${PRGDIR}/vim/bundles.vim" ${HOME}/bundles.vim
mkdir -p ${HOME}/.vim
ln -snfv "${PRGDIR}/vim/ftplugin" ${HOME}/.vim/ftplugin
yes '' | vim +PluginInstall +qall
yes '' | vim +PluginUpdate +qall

# i3
mkdir -p ${HOME}/.config/i3
ln -snfv "${PRGDIR}/i3/config" ${HOME}/.config/i3/config
