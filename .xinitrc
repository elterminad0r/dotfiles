# vim: ft=sh

# FIGMENTIZE: xinitrc
#        _         _  _
# __  __(_) _ __  (_)| |_  _ __  ___
# \ \/ /| || '_ \ | || __|| '__|/ __|
#  >  < | || | | || || |_ | |  | (__
# /_/\_\|_||_| |_||_| \__||_|   \___|

[[ -f /etc/xprofile ]] && . /etc/xprofile
[[ -f ~/.xprofile ]] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec i3
