# FIGMENTIZE: tmux
#   __
# _/  |_  _____   __ __ ___  ___
# \   __\/     \ |  |  \\  \/  /
#  |  | |  Y Y  \|  |  / >    <
#  |__| |__|_|  /|____/ /__/\_ \
#             \/              \/

if [ -n "$GOEDEL_START_TMUX" ]; then
    # If not running interactively, do not do anything
    [[ $- != *i* ]] && return
    [ -z "$TMUX" ] && exec sh -c "tmux attach-session || tmux"
fi
