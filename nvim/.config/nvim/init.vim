set nocompatible
let g:mapleader=" "
"automated installation of vimplug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.config/nvim/plugged')

if !has('nvim') && !exists('g:gui_oni') | Plug 'tpope/vim-sensible' | endif
Plug 'rstacruz/vim-opinion'


"plugins here, coc for example
Plug 'neoclide/coc.nvim', { 'branch': 'release' } 
Plug 'jiangmiao/auto-pairs' "automatic closing braces
Plug 'machakann/vim-sandwich' "handle surrounding stuff
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-sleuth' "automatic spacing
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter' "shows diff status

"tpope is the best
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'

"languages
Plug 'elixir-tools/elixir-tools.nvim'

Plug 'sheerun/vim-polyglot' "automatically fetch vim languages


"fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"themes
Plug 'joshdick/onedark.vim'


call plug#end()


source $HOME/.config/nvim/themes/onedark.vim
source $HOME/.config/nvim/plugins/coc.vim
source $HOME/.config/nvim/plugins/fzf.vim



set rnu
set number
set mouse=a
set ruler
set history=10000

if !has('gui_running') | set t_Co=256 | endif



try 
  source ~/.vimrc-shared
catch
  " No such file? No problem; just ignore it.
endtry 
