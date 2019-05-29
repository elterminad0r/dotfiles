# .profile, mostly to be sourced by other profiles

#                         _____ .__ .__
# ______ _______   ____ _/ ____\|__||  |    ____
# \____ \\_  __ \ /  _ \\   __\ |  ||  |  _/ __ \
# |  |_> >|  | \/(  <_> )|  |   |  ||  |__\  ___/
# |   __/ |__|    \____/ |__|   |__||____/ \___  >
# |__|                                         \/
# FIGMENTIZE: profile

if [ -n "$GOEDEL_VERBOSE" ]; then
    echo "sourcing profile"
fi

# set all of these default-y programs
# If you remove any of this, it will probably break most of my i3 binding to
# open things. If you rename them, it will probably just make the bindings to
# weird things.

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
    # TODO: think of a better solution for this
    # export PAGER='vimpager'; export VIMPAGERRC="~/.vim/vimpager.vim"
# default terminal.
# I'm currently kind of stuck between termite and kitty.
# Both have just a solid, modern concept of fonts and encodings libcairo with
# SVG emoji and so on, and an up to date colour palette system. Both have a good
# handle on what should be straightforward things like URLs.
# Termite's vim and url hint modes are really cool, but Kitty has more
# straightforward window titles, seems slightly faster, and the `kitty +kitten
# icat <image>` command is pretty cool.
export TERMINAL='termite'
# various (presumed terminal) commands for more advanced applications are
# defined in ~/bin:
# - ~/bin/TERMINAL_CD
# - ~/bin/TERMINAL_TMUX
# - ~/bin/MUSIC_PLAYER
# - ~/bin/HOUSE_OF_GOEDEL

# I have them not written in terms of "$TERMINAL", because each terminal has,
# annoyingly, subtly different flags (ie -d or -cd to set pwd at startup, and to
# execute you have -e some command vs -e "some command", etc etc
# They can't just be put in variables because because they may need to take
# arguments, or do word splitting.

# TODO: bite the qute bullet
export BROWSER='firefox'
export READER='zathura'
export FILE='ranger'

# make BSD utilities be coloured in
export CLICOLOR=1

export XDG_CONFIG_HOME="$HOME/.config"

# make caca programs run in curses, so they're properly in your terminal
export CACA_DRIVER=ncurses

# these need to be continuously set, particularly if oh-my-zsh is around
export LC_CTYPE=en_GB.utf8
export LC_ALL=en_GB.utf8
export LANG=en_GB.utf8

if [ "$TERM" = xterm ]; then
    export TERM=xterm-256color
fi

# use xim with gtk applications. This is mostly so that Xcompose can be used to
# add custom compose sequences.
# TODO: move to something more modern
export GTK_IM_MODULE=xim

export PYTHONPATH="$HOME"/pybin

export PYTHONSTARTUP="$HOME"/.pythonrc

# something with escape sequences, plus case insensitive search
export LESS="-Ri"

# expose columns and lines to commands that are run. This is useful
export COLUMNS LINES

# where I keep my zsh dotfiles, reduce clutter
export ZDOTDIR="$HOME/.zsh"

export BASHDOTDIR="$HOME/.bash"

export XDOTDIR="$HOME/.X"

# stop <C-[sq]> from killing my flow, and in fact expose them for keybinding
stty -ixon

# add $1 to path if it isn't already in path.
# Be sure that you pass a proper full path to this, rather than a relative one.
add_to_path() {
    case $PATH in
        *"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
            ;;
    esac
}

for bin_dir in "$HOME"/bin "$HOME"/.gem/ruby/2.6.0/bin "$HOME"/.local/bin; do
    add_to_path "$bin_dir"
done
