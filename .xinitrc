# vim: ft=sh

#         .__         .__   __
# ___  ___|__|  ____  |__|_/  |_ _______   ____
# \  \/  /|  | /    \ |  |\   __\\_  __ \_/ ___\
#  >    < |  ||   |  \|  | |  |   |  | \/\  \___
# /__/\_ \|__||___|  /|__| |__|   |__|    \___  >
#       \/         \/                         \/
# FIGMENTIZE: xinitrc

[[ -f /etc/xprofile ]] && . /etc/xprofile
[[ -f ~/.xprofile ]] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I"$XDOTDIR" ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec i3
