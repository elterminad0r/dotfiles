" Override HTML to have much shorter tabstops. Basically because I only ever
" edit HTML by hand when it's mine, and I much prefer to keep further left than
" having large indents, and it can get away from one quite fast if you're making
" tds within trs within tables within divs within bodies within htmls etc

setlocal tabstop=1 softtabstop=-1 shiftwidth=0
