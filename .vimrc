set nocompatible

filetype off

" Load plugins here

syntax on

filetype plugin indent on

set number
set ruler
set visualbell
set encoding=utf-8
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:>
runtime! macros/matchit.vim

nnoremap j gj
nnoremap k gk

set hidden

set ttyfast

set laststatus=2

set showmode
set showcmd

map <leader><space> :let @/=''<cr> " clear search

inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
map <leader>l :set list!<CR> " Toggle tabs and EOL

set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
let g:indentLine_char = '⦙'
