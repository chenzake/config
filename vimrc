set nocompatible              " required
filetype plugin indent on    " required
set nu sts=4 ts=4 sw=4 et si ai
set ruler
set hlsearch
syntax on
set pastetoggle=<F2>
set foldmethod=marker
set foldlevel=99
set cms=%s
au FileType python set foldmethod=indent
au FileType perl set foldmarker=#<<<,#>>>
au FileType c,c++,javascript set foldmarker=//<<<,//>>>
let mapleader=","
map <leader>S :%s/\s\+$//<cr>:let @/=''<CR>
map <leader>q :q<CR>
map <leader>s :mks! Session.vim<CR> :w<CR>
autocmd Filetype yaml setlocal sw=2 ts=2 sts=2 et foldmarker={,} foldlevel=99 foldmethod=marker
autocmd Filetype jinjia sw=2 ts=2 sts=2 et  foldmarker={,} foldlevel=99 foldmethod=marker
autocmd Filetype sw=2 ts=2 sts=2 et  foldmarker={,} foldlevel=99 foldmethod=marker