filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

Plugin 'bling/vim-airline'
Plugin 'tomasr/molokai'
Plugin 'a.vim'
Plugin 'Modeliner'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'gregsexton/MatchTag'
Plugin 'kien/ctrlp.vim'
Plugin 'godlygeek/tabular'
Plugin 'git@bbgithub.dev.bloomberg.com:lkisskol/pkgcfg_plugin.git'
Plugin 'derekwyatt/vim-scala'
Plugin 'w0rp/ale'
call vundle#end()            " required
filetype plugin indent on    " required

