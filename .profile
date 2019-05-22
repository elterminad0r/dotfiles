# .profile, mostly to be sourced by other profiles

# FIGMENTIZE: profile
#                         _____ .__ .__
# ______ _______   ____ _/ ____\|__||  |    ____
# \____ \\_  __ \ /  _ \\   __\ |  ||  |  _/ __ \
# |  |_> >|  | \/(  <_> )|  |   |  ||  |__\  ___/
# |   __/ |__|    \____/ |__|   |__||____/ \___  >
# |__|                                         \/

if [ -n "$IZAAK_VERBOSE" ]; then
    echo "sourcing profile"
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
# TODO: think of a better solution for this
# export PAGER='vimpager'; export VIMPAGERRC="~/.vim/vimpagerrc"
export TERMINAL='urxvt'
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

export LESS="-R"

# expose columns and lines to commands that are run. This is useful
export COLUMNS LINES

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
