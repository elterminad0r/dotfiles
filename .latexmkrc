# vim: ft=perl

# .__            __                             __
# |  |  _____  _/  |_   ____  ___  ___  _____  |  | __
# |  |  \__  \ \   __\_/ __ \ \  \/  / /     \ |  |/ /
# |  |__ / __ \_|  |  \  ___/  >    < |  Y Y  \|    <
# |____/(____  /|__|   \___  >/__/\_ \|__|_|  /|__|_ \
#            \/            \/       \/      \/      \/
# FIGMENTIZE: latexmk

# Make it so that compilers don't wait for you to type whatever crap it is they
# want if there's an error. Further use shell-escape by default because that's
# useful for listings and things. Security implications: Don't buy LaTeX from
# strangers with ulterior motives.
$latex = "latex -synctex=1  --shell-escape -interaction=nonstopmode -halt-on-error %O %S";
$pdflatex = "pdflatex -synctex=1 -shell-escape -interaction=nonstopmode -halt-on-error %O %S";
$xelatex = "xelatex -synctex=1 -shell-escape -interaction=nonstopmode-halt-on-error %O %S";

$sleep_time = 1;
# PDF mode by default
$pdf_mode = 1;
# Define DVI and PS viewers because why not
$dvi_previewer = 'start xdvi -watchfile 1.5';
$ps_previewer  = 'start gv --watch';

# some magic perl stuff to make this pick a suitable candidate according to
# PATH.
use File::Which qw(which);
foreach my $viewer (split " ", "zathura evince xdg-open mimeopen open") {
    if (defined(which $viewer)) {
        $pdf_previewer = "start $viewer";
        last; # this is basically break
    }
}
