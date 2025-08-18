set nocompatible
set encoding=utf-8


"----Commands-----------------------------------------------------------------"
" Better command-line completion
set wildmenu

" Show partial commands in the last line
set showcmd

" New leader
let mapleader = " "
let maplocalleader = "  "


"----Usability and Functionality----------------------------------------------"
" Yank to clipboard
set clipboard=unnamedplus,autoselect,exclude:cons\\\\|linux

" Capture mouse
" set mouse=r

" Case-insensitive search expt when CAP
set ignorecase
set smartcase

" Backspace over indents, endofline, insrt
set backspace=indent,eol,start

" Confirmation of unsaved changes
set confirm

" split screen and navigation
set splitbelow
set splitright

" split navigation
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Terminal escape
tnoremap <Esc> <C-\><C-n>

"----Style--------------------------------------------------------------------"
" Visual bell instead of audible bell
set visualbell

set cursorline
set cursorcolumn

set colorcolumn=80

" Numbering
set number relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" Color scheme
set termguicolors
set background=dark
colorscheme elflord
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 0
let g:airline_powerline_fonts=0
let g:airline_theme='material'
set term=xterm-256color

" Status Line
set laststatus=2
let g:airline#extensions#tabline#enabled=1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_c = '%F'

" Don't wrap text
set nowrap

" Persistent ruler
set ruler

"----Syntax-------------------------------------------------------------------"
syntax enable

" Search setting
set nohlsearch
set incsearch
set ignorecase

" Use soft tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" Copy indentation from previous line
set autoindent

" Regular Expressions
set magic
