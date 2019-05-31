#   __     __
# _/  |_ _/  |_  ___.__._______   ____
# \   __\\   __\<   |  |\_  __ \_/ ___\
#  |  |   |  |   \___  | |  | \/\  \___
#  |__|   |__|   / ____| |__|    \___  >
#                \/                  \/
# FIGMENTIZE: ttyrc

# this file does some set up on a tty to easy fontsize changing

case $(tty) in
    /dev/tty[0-9]*)
        echo "launching tty setup"
        # I prepend goedel to things because of the feeling of security it gives
        # me
        GOEDEL_IS_TTY=true
        IZ_VC_FONTSIZE=5
        ter_fonts=(/usr/share/kbd/consolefonts/ter-1??n.psf.gz)
            izu() {
                if [[ $IZ_VC_FONTSIZE -ge 9 ]]; then
                    >&2 echo "already at max font"
                else
                    ((IZ_VC_FONTSIZE++))
                    setfont $ter_fonts[$IZ_VC_FONTSIZE]
                    echo $ter_fonts[$IZ_VC_FONTSIZE]
                fi
            }
        izd() {
            if [[ $IZ_VC_FONTSIZE -le 1 ]]; then
                >&2 echo "already at min font"
            else
                ((IZ_VC_FONTSIZE--))
                setfont $ter_fonts[$IZ_VC_FONTSIZE]
                echo $ter_fonts[$IZ_VC_FONTSIZE]
            fi
        }
        izr() {
            IZ_VC_FONTSIZE=5
            setfont $ter_fonts[$IZ_VC_FONTSIZE]
            echo $ter_fonts[$IZ_VC_FONTSIZE]
        }
        izg() {
            echo $ter_fonts[$IZ_VC_FONTSIZE]
        }
        ;;
    *)
        GOEDEL_IS_TTY=
        ;;
esac
