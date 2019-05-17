# FIGMENTIZE: zshenv
#            _
#  ____ ___ | |__    ___  _ __ __   __
# |_  // __|| '_ \  / _ \| '_ \\ \ / /
#  / / \__ \| | | ||  __/| | | |\ V /
# /___||___/|_| |_| \___||_| |_| \_/

source $HOME/.profile

# add various directories to path. This is done through zsh typeset mechanism,
# setting path to be a unique array.
# Killer feature!
typeset -U path
path=(~/bin ~/.gem/ruby/2.6.0/bin ~/.local/bin $path[@])

# similar for function path
typeset -U fpath
fpath=(~/.zcomp $fpath[@])

# "List Xecutables" - excludes completion functions.
alias lx='print -rl -- ${(ko)commands} ${(ko)functions} ${(ko)aliases} | grep -v "^_"'


# make escape key go faster. I think this is a number of centiseconds? wth
export KEYTIMEOUT=5

# so that vim and ipython etc know my aliases.
source $HOME/.izaak_aliases
