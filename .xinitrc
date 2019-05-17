# vim: ft=sh

# FIGMENTIZE: xinitrc
#         .__         .__   __
# ___  ___|__|  ____  |__|_/  |_ _______   ____
# \  \/  /|  | /    \ |  |\   __\\_  __ \_/ ___\
#  >    < |  ||   |  \|  | |  |   |  | \/\  \___
# /__/\_ \|__||___|  /|__| |__|   |__|    \___  >
#       \/         \/                         \/

[[ -f /etc/xprofile ]] && . /etc/xprofile
[[ -f ~/.xprofile ]] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec i3
