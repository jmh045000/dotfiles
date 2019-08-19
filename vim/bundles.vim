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
Plugin 'a.vim'
Plugin 'Modeliner'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'gregsexton/MatchTag'
Plugin 'godlygeek/tabular'
Plugin 'derekwyatt/vim-scala'
Plugin 'w0rp/ale'
Plugin 'junegunn/fzf'
Plugin 'mileszs/ack.vim'
Plugin 'bkad/camelcasemotion'
Plugin 'morhetz/gruvbox'

try
  source ~/bundles.local.vim
catch
endtry

call vundle#end()            " required
filetype plugin indent on    " required

