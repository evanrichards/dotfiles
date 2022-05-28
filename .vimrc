set nocompatible

" Vim-plug
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

    " https://github.com/tpope/vim-sensible
    Plug 'tpope/vim-sensible'
    " https://github.com/github/copilot.vim
    Plug 'github/copilot.vim'
    " code formatting
    Plug 'google/vim-maktaba'
    Plug 'google/vim-codefmt'
    " remove reflections
    Plug 'dracula/vim', { 'as': 'dracula' }
    " https://github.com/kamykn/spelunker.vim
    " spell checking, use Zl for list of replacements, Zg to add, Zt to toggle
    Plug 'kamykn/spelunker.vim'
    Plug 'kamykn/popup-menu.nvim'
    " kitty syntax highligting, way overkill
    Plug 'fladson/vim-kitty'
    " auto-close parens, quotes, and brackets; auto-formats with new lines
    Plug 'cohama/lexima.vim'
    " show git status on lines
    Plug 'mhinz/vim-signify'
    " wide ranging language support
    Plug 'sheerun/vim-polyglot'
    " Git support
    Plug 'tpope/vim-fugitive'
    " Github support, :Gbrowse and <C-X><C-O> for omnicomplete
    Plug 'tpope/vim-rhubarb'
    " navigate tmux panes with <C-movement> keys
    Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" cop that vlad fit
colorscheme dracula

" turn on syntax highlighting
syntax on

" turn on file-type specific features
filetype on
filetype indent on
filetype plugin on

" show the line number the cursor is on and relatve line numbers in
" either direction
set number relativenumber
" shhhh
set visualbell
set noerrorbells
" wrap lines when they are too long
set wrap

" Maximum width of text that is being inserted.  A longer line will be
" broken after white space to get this width.  A zero value disables
" this.
set textwidth=79
" Show a line at 80 chars
set colorcolumn=80
" tabs should look like 4 spaces
set tabstop=4
" treat tabs like 4 spaces when editing
set softtabstop=4
" auto indent width
set shiftwidth=4
set smartindent
" turn tabs into spaces
set expandtab
" use case insensitive search...
set ignorecase
" ... unless there is a capital in the search
set smartcase
" turn off native spell checking
set nospell
" show the mode at the bottom if not normal mode
set showmode
" show dimensions of selection in visual mode
set showcmd

" Cursor motion
" start scrolling the screen when the cursor is 8 lines from the edge
set scrolloff=8
set backspace=indent,eol,start
" add < > to % matching
set matchpairs+=<:>

" Disabling the directional keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" if you open a new vim buffer, hide the old, dont throw it away
set hidden

" set leader key to comma
let g:mapleader = ","

" clear search highlighting with ,+<space>
map <leader><space> :let @/=''<cr>

" set up autoformatting for certain file types through vim-codefmt
augroup autoformat_settings
  autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType rust AutoFormatBuffer rustfmt
augroup END

" format styntax highlight primsa files like typescript
autocmd BufNewFile,BufRead *.prisma set syntax=typescript
" delete trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
