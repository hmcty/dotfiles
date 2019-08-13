" Enable pathogen plugin manager 
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Gutter plugin update time (100ms is recommended)
set updatetime=100

" Add line numbers
set number

" Enable nord theme 
set t_Co=256
colorscheme nord
 
" Set tabing to 2 spaces
filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
