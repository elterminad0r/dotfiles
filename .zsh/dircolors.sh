# FIGMENTIZE: dircolors
#     .___.__                        .__
#   __| _/|__|_______   ____   ____  |  |    ____ _______  ______
#  / __ | |  |\_  __ \_/ ___\ /  _ \ |  |   /  _ \\_  __ \/  ___/
# / /_/ | |  | |  | \/\  \___(  <_> )|  |__(  <_> )|  | \/\___ \
# \____ | |__| |__|    \___  >\____/ |____/ \____/ |__|  /____  >
#      \/                  \/                                 \/

# file that sets up pretty ls colours, as best as it can according to what's on
# the system

# TODO make aware of profiles etc
if silent command -v dircolors; then
    if [ "$GOEDEL_IS_TTY" != "true" ]; then
        if [ -f "$HOME/.dir_colors_solarized" ]; then
            eval "$(dircolors "$HOME/.dir_colors_solarized")"
        else
            echo "using default dircolors" >&2
            eval "$(dircolors)"
        fi
    else
        echo "using default dircolors as in tty" >&2
        eval "$(dircolors)"
    fi
else
    echo "dircolors executable not found" >&2
fi
