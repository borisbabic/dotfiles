# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory autocd extendedglob
bindkey -e

if [ -f ~/.shell_common ]; then #common stuff, environment (path/editor) aliases and functions
    . ~/.shell_common
fi

#ALIASES
alias killbg='kill ${${(v)jobstates##*:*:}%=*}' # http://stackoverflow.com/questions/13166544/how-to-kill-all-background-processes-in-zsh

#keybindings
bindkey '^U' backward-kill-line #fixes ctrl u behavoir

if [  -f ~/.zgen/zgen.zsh ];  then
    source ~/.zgen/zgen.zsh
    if ! zgen saved; then
        zgen oh-my-zsh
        zgen oh-my-zsh plugins/git
        zgen oh-my-zsh plugins/sudo
        zgen oh-my-zsh plugins/command-not-found

        zgen load zsh-users/zsh-syntax-highlighting
        zgen load zsh-users/zsh-completions
        zgen load zsh-users/zsh-history-substring-search
        zgen load zsh-users/zsh-autosuggestions

        zgen load Tarrasch/zsh-colors
        zgen load micha/resty #resty client

        export TERM="xterm-256color"
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
        DEFAULT_USER=boris #used for some themes - removes user part
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time context dir rbenv vcs status)
        zgen load bhilburn/powerlevel9k powerlevel9k

    fi
else 
    echo 'Install zgen. Run git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"'
fi


autoload -U zmv
