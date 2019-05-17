# vim: ft=perl

# FIGMENTIZE: latexmk
# .__            __                             __
# |  |  _____  _/  |_   ____  ___  ___  _____  |  | __
# |  |  \__  \ \   __\_/ __ \ \  \/  / /     \ |  |/ /
# |  |__ / __ \_|  |  \  ___/  >    < |  Y Y  \|    <
# |____/(____  /|__|   \___  >/__/\_ \|__|_|  /|__|_ \
#            \/            \/       \/      \/      \/

$latex = "latex -synctex=1  --shell-escape -halt-on-error %O %S";
$pdflatex = "pdflatex -synctex=1 -shell-escape -halt-on-error %O %S";
$xelatex = "xelatex -synctex=1 -shell-escape -halt-on-error %O %S";
$sleep_time = 1;
$pdf_mode = 1;
$dvi_previewer = 'start xdvi -watchfile 1.5';
$ps_previewer  = 'start gv --watch';

# TODO: add some magic perl stuff to make this pick a suitable candidate
# according to PATH.
$pdf_previewer = 'start zathura';
