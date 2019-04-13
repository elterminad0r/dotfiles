$latex = "latex -synctex=1  --shell-escape -halt-on-error %O %S";
$pdflatex = "pdflatex -synctex=1 -shell-escape -halt-on-error %O %S";
$xelatex = "xelatex -synctex=1 -shell-escape -halt-on-error %O %S";
$sleep_time = 1;
$pdf_mode = 1;
$dvi_previewer = 'start xdvi -watchfile 1.5';
$ps_previewer  = 'start gv --watch';
$pdf_previewer = 'start evince';
