set nocompatible
filetype off               

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'

let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
call vundle#end()           
filetype plugin indent on    

set ignorecase
set incsearch
set lazyredraw
set tabpagemax=100
set smartindent

set cursorline

inoremap kj <Esc>

set number

set relativenumber

if has('persistent_undo')
	let target_path = expand('~/.config/vim-persisted-undo')
	if !isdirectory(target_path)
		call system('mkdir -p ' . target_path)
	endif
	let &undodir = target_path
	set undofile
endif
syntax on

set background=dark
colorscheme desert
set showmatch
set hlsearch
set t_Co=256
