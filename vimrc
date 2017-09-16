set nocompatible              " required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Tagbar'
call vundle#end()            " required
filetype plugin indent on    " required
set nu sts=4 ts=4 sw=4 et si ai
set ruler
set hlsearch
syntax on
filetype plugin on
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
noremap <C-d> "_d
"set syntax=yaml sw=2 ts=2 sts=2 et foldmarker={,} foldlevel=99 foldmethod=marker
"set syntax=jinjia sw=2 ts=2 sts=2 et  foldmarker={,} foldlevel=99 foldmethod=marker
"set syntax=jinjia2 sw=2 ts=2 sts=2 et  foldmarker={,} foldlevel=99 foldmethod=marker
nmap <F8> :TagbarToggle<CR> 
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let NERDChristmasTree=1
let NERDChristmasTree=1
let NERDTreeWinSize=25
nnoremap f :NERDTreeToggle<CR>
map <F9> :!ctags -R --languages=python <CR> 
set tags=tags;/
