# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory autocd extendedglob
bindkey -e

#ALIASES
alias killbg='kill ${${(v)jobstates##*:*:}%=*}' # http://stackoverflow.com/questions/13166544/how-to-kill-all-background-processes-in-zsh

#keybindings
bindkey '^U' backward-kill-line #fixes ctrl u behavoir

if [  -f ~/.zgenom/zgenom.zsh ];  then
    source ~/.zgenom/zgenom.zsh
    if ! zgenom saved; then
        zgenom oh-my-zsh
        zgenom oh-my-zsh plugins/git
        zgenom oh-my-zsh plugins/sudo
        zgenom oh-my-zsh plugins/command-not-found

        zgenom load zsh-users/zsh-syntax-highlighting
        zgenom load zsh-users/zsh-completions
        zgenom load zsh-users/zsh-history-substring-search
        zgenom load zsh-users/zsh-autosuggestions

        zgenom load Tarrasch/zsh-colors

        export TERM="xterm-256color"
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
        DEFAULT_USER=boris #used for some themes - removes user part
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time context dir rbenv vcs status)
        zgenom load bhilburn/powerlevel9k powerlevel9k

    fi
else
    echo 'Install zgenom. Run git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"'
fi


autoload -U zmv

if [ -f ~/.shell_common ]; then #common stuff, environment (path/editor) aliases and functions
    . ~/.shell_common
fi


if command -v direnv >/dev/null 2>/dev/null; then
    eval "$(direnv hook zsh)"

fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
