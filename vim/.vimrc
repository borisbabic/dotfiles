set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"general
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimfiler'
Plugin 'Shougo/vimproc'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'

"Haskell

Plugin 'raichoo/haskell-vim'

"PHP
Plugin 'spf13/PIV'

"javascript
Plugin 'moll/vim-node'
Plugin 'jelera/vim-javascript-syntax'

"scala
Plugin 'derekwyatt/vim-scala'

"colorschemes
Plugin 'flazz/vim-colorschemes'

"snipmate 
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'tomtom/tlib_vim'

"Plugin 'xolox/vim-easytags'
"Plugin 'xolox/vim-misc'

call vundle#end()            " required
filetype plugin indent on    " required

""""" OPTIONS

let mapleader="\<space>"


colorscheme mustang

" search
set incsearch     " incremental search as you type
set ignorecase    " ignore case on search
set smartcase     " don't ignore case when there is a capital letter
set hlsearch      " highlight the current search
" tabs
set tabstop=4     " number spaces for tabs
set expandtab     " use spaces for tabs
set shiftwidth=4  " number of tabs for authindent
" misc
set nowrap        " no wrapping on long lines
set rnu           " relative numbers 
set number        " absolute current
set mouse=a       " turn on mouse

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif
""" PLUGINS

"" PIV
let g:DisableAutoPHPFolding = 1

"" haskell-vim

let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1

"" unite

if executable('ag')
    let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
endif

"" easy-tags

" asznc easytags
let g:easytags_async=1

""""" MAPPINGS

""" tagbar

nnoremap <F8> :TagbarToggle<CR>

""" unite

nnoremap <C-p> :Unite -start-insert file_rec/async<CR>

""" vimfiler
nnoremap <leader>n :VimFilerExplorer<CR>

""" gundo

nnoremap <F5> :GundoToggle<CR>

""" macro-ish stuff

"aligns a php array by =>
nnoremap <leader>a Vi(:Tabularize /=><CR>

"puts text into a php try catch
vnoremap <leader>tc dOtry {}P=i{k_f{%a catch (\Exception $exception) {}

"surrounds text in a line with var_dump();die;
nnoremap <leader>vdd Ivar_dump(<ESC>A);die;<ESC>F)
vnoremap <leader>vdd davar_dump()<ESC>PA;die;<ESC>F)

"aligns selected by =
vnoremap <leader>= :Tabularize /=<CR>

"sorts a block of stuff
nnoremap <leader>sb )kV(:sort<CR>

"something which works but I'm not sure how " todo: remember what this does
vnoremap <leader>a :Tabularize /\$[a-zA-Z_]*/<CR> 

"surrounds text in a line with console.log();
nnoremap <leader><leader>cl Iconsole.log(<ESC>A);<ESC>F)

""" Windows

" window focus switching
nnoremap <Up>        <C-W>k
nnoremap <Down>      <C-W>j
nnoremap <Left>      <C-W>h
nnoremap <Right>     <C-W>l

" window position changing

nnoremap <S-Up>      <C-W>K
nnoremap <S-Down>    <C-W>J
nnoremap <S-Left>    <C-W>H
nnoremap <S-Right>   <C-W>L


""""" AUTOCOMMANDS

""" php

" removes spaces at the end of lines
autocmd FileType php autocmd BufWritePre <buffer> :%s/\s\+$//e
