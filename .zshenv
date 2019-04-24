# If you come from bash you might have to change your $PATH.
typeset -U path
path=(~/bin ~/.local/bin $path[@])

if [[ $TERM = xterm ]]; then
    export TERM=xterm-256color
fi

export PYTHONPATH=~/pybin

typeset -U fpath
fpath=(~/.zcomp $fpath[@])

export EDITOR='vim'

export LESS="-R"

export COLUMNS LINES

# so that vim and ipython etc know my aliases.
alias lx='print -rl -- ${(ko)commands} ${(ko)functions} ${(ko)aliases} | grep -v "^_"'
source $HOME/.izaak_aliases

export KEYTIMEOUT=1
