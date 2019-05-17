# .profile, mostly to be sourced by other profiles

# FIGMENTIZE: profile
#                      __  _  _
#  _ __   _ __  ___   / _|(_)| |  ___
# | '_ \ | '__|/ _ \ | |_ | || | / _ \
# | |_) || |  | (_) ||  _|| || ||  __/
# | .__/ |_|   \___/ |_|  |_||_| \___|
# |_|

export EDITOR='vim'
export PAGER='less'
# TODO: think of a better solution for this
# export PAGER='vimpager'; export VIMPAGERRC="~/.vim/vimpagerrc"
export TERMINAL='urxvt'
export BROWSER='firefox'
export READER='zathura'
export FILE='ranger'

export XDG_CONFIG_HOME="$HOME/.config"

# make caca programs run in curses, so they're properly in your terminal
export CACA_DRIVER=ncurses

# these need to be continuously set, particularly if oh-my-zsh is around
export LC_CTYPE=en_GB.utf8
export LC_ALL=en_GB.utf8
export LANG=en_GB.utf8

if [[ $TERM = xterm ]]; then
    export TERM=xterm-256color
fi

# use xim with gtk applications. This is mostly so that Xcompose can be used to
# add custom compose sequences.
# TODO: move to something more modern
export GTK_IM_MODULE=xim

export PYTHONPATH=~/pybin

export PYTHONSTARTUP=$HOME/.pythonrc

export LESS="-R"

# expose columns and lines to commands that are run. This is useful
export COLUMNS LINES

# stop <C-[sq]> from killing my flow, and in fact expose them for keybinding
stty -ixon
