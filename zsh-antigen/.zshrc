# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/boris/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if [ -f ~/.shell_common ]; then #common stuff, environment (path/editor) aliases and functions
    . ~/.shell_common
fi

#ALIASES
alias killbg='kill ${${(v)jobstates##*:*:}%=*}' # http://stackoverflow.com/questions/13166544/how-to-kill-all-background-processes-in-zsh

source ~/.antigen.zsh

# Setup
antigen use oh-my-zsh

export DEFAULT_USER=boris #used for some themes

# Theme 

#antigen theme wezm
antigen theme amuse

# Antigen bundles

antigen bundle git

antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle zsh-users/zsh-history-substring-search

antigen-bundle Tarrasch/zsh-colors

#antigen bundle powerline/powerline powerline/bindings/zsh

#zsh stuff
#
autoload -U zmv
