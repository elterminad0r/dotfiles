# vim: ft=perl

# FIGMENTIZE: latexmk
#  _         _                          _
# | |  __ _ | |_  ___ __  __ _ __ ___  | | __
# | | / _` || __|/ _ \\ \/ /| '_ ` _ \ | |/ /
# | || (_| || |_|  __/ >  < | | | | | ||   <
# |_| \__,_| \__|\___|/_/\_\|_| |_| |_||_|\_\

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
