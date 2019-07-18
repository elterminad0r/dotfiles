# vim: ft=sh

#         .__         .__   __
# ___  ___|__|  ____  |__|_/  |_ _______   ____
# \  \/  /|  | /    \ |  |\   __\\_  __ \_/ ___\
#  >    < |  ||   |  \|  | |  |   |  | \/\  \___
# /__/\_ \|__||___|  /|__| |__|   |__|    \___  >
#       \/         \/                         \/
# FIGMENTIZE: xinitrc

systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi

[ -r /etc/xprofile ] && . /etc/xprofile
[ -r ~/.xprofile ] && . ~/.xprofile

exec i3
