"                                  .__            ____
"   _____  _____   ______  ______  |__|  ____    / ___\  _____________   ____
"  /     \ \__  \  \____ \ \____ \ |  | /    \  / /_/  >/  ___/\_  __ \_/ ___\
" |  Y Y  \ / __ \_|  |_> >|  |_> >|  ||   |  \ \___  / \___ \  |  | \/\  \___
" |__|_|  /(____  /|   __/ |   __/ |__||___|  //_____/ /____  > |__|    \___  >
"       \/      \/ |__|    |__|             \/              \/              \/
" FIGMENTIZE: mappingsrc

" This is a file of all my vim mappings. They might be in decreasing order of
" favouritism (ie, if I can be bothered, I will put my more useful mappings
" nearer the top. Some inspiration from
" https://github.com/anowlcalledjosh/dotfiles/blob/master/.vimrc
" and
" https://github.com/tpope/vim-sensible

" self explanatory
function! LaughManiacally() abort
    echohl ErrorMsg
    echo "Mwahahahahahahahaha"
    echohl None
endfunction

" a bit of tough love. <Up> and <Down> are used for scrolling, so it's a bad
" idea to remap them to something non movement related, as that's a little too
" much of a mind f. However, scrolling is not hardcore and you should use any of
" ^[YEUDBF] instead, as they're faster and more ergonomic
" I use <Left> and <Right> with ultisnips, so I don't remap those.
" Discourage scrolling or otherwise using up and own.
inoremap <Up> <C-o>:call LaughManiacally()<CR>
inoremap <Down> <C-o>:call LaughManiacally()<CR>
nnoremap <Up> :call LaughManiacally()<CR>
nnoremap <Down> :call LaughManiacally()<CR>
" don't mess up anything in operator mode
onoremap <Up> <Nop>
onoremap <Down> <Nop>

" Repeated indentation in visual mode
xnoremap > >gv
xnoremap < <gv

" the classic shortcut to Copy to clipboard, but only in visual mode where ^C
" won't really be missed.
" Paste from normal mode with "+p, paste in insert mode through your terminal,
" or, better, by using ^R(^R|^O|^P)+, giving more control over indentation etc
xnoremap <C-c> "+y

" Toggle Paste mode
nnoremap <Leader>p :set paste! <bar> set paste?<CR>

" crap, these turn the scrollwheel into a
" weapon of mass destruction.
" " Up and down to move lines around
" " noremap <Up> ddkP
" " noremap <Down> ddp

" Shortcut to turn highlighting on or off
nnoremap <silent> <CR> :call ToggleHighlight()<CR>

" Store the original carriage return for the CR fans
nnoremap g<CR> <CR>

" However, in the command-line window I do want CR to be a normal CR, so I
" automatically unset and reset this mapping.
augroup CmdWinCRRestore
    autocmd! CmdWinEnter * nnoremap <buffer> <CR> <CR>
augroup END

nnoremap <silent> <F3> :call ToggleHighlight()<CR>
inoremap <silent> <F3> <C-o>:call IToggleHighlight()<CR>
" TODO: go left and right with this
map <F4> m'<Plug>CommentaryLine``
imap <F4> <C-o>m'<C-o><Plug>CommentaryLine<C-o>``

" FIGMENTOFF
nnoremap <F5> AFIGMENTIZE:<Space><C-r>%<Esc>
" FIGMENTOFF
inoremap <F5> FIGMENTIZE:<Space><C-r>%

" Toggle the vimack search on or off
nnoremap <F6> :call GoedelToggleSearch()<CR>
inoremap <F6> <C-o>:call GoedelToggleSearch()<CR>

" Essential to any man's vimrc
nnoremap <F7> AWE'RE<Space>GOING<Space>TO<Space>THE<Space>EMMIES<ESC>
inoremap <F7> WE'RE<Space>GOING<Space>TO<Space>THE<Space>EMMIES

" Search for selected text. This makes * and # work for visual selections, so
" you can search for things that aren't a unit of text as defined by * and # by
" default. It seems fairly black magicky, it comes from
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
let s:save_cpo = &cpo | set cpo&vim
if !exists('g:VeryLiteral')
    let g:VeryLiteral = 0
endif
function! s:VSetSearch(cmd) abort
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    normal! gvy
    if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
        let @/ = @@
    else
        let pat = escape(@@, a:cmd.'\')
        if g:VeryLiteral
            let pat = substitute(pat, '\n', '\\n', 'g')
        else
            let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
            let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
            let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
        endif
        let @/ = '\V'.pat
    endif
    " normal! gV
    call setreg('"', old_reg, old_regtype)
endfunction
xnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR>
xnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>/<CR>
" vmap <kMultiply> *
nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
  \ <bar> echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
" if !hasmapto("<Plug>VLToggle")
"   nmap <unique> <Leader>vl <Plug>VLToggle
" endif
let &cpo = s:save_cpo | unlet s:save_cpo

" FIXME work out if this is useful/correct (see <Del>)
" map CTRL-V <BS>   CTRL-V <Del>

" make ctrl-c "abort" current insertion. It's consistent with the
" characterisation of ctrl-c in unix lore, and sometimes you're just angry at
" what you've written, y'know
inoremap <C-c> <Esc>u

" mapping to insert a single character, from
" https://vim.fandom.com/wiki/Insert_a_single_character
" remap S as it's equivalent to cc, which is the line command that fits with dd,
" and yy.
function! RepeatChar(char, count) abort
    return repeat(a:char, a:count)
endfunction
" TODO: 2Sx doesn't work
nnoremap S :exec "normal! i".RepeatChar(nr2char(getchar()), v:count1)<CR>
" and similar for append single character
nnoremap <Leader>S :exec "normal! a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" map Y so it behaves like D and C
nnoremap Y y$

" Am I crazy?? this makes much more sense. nG is used to go to line, ngg is
" used to go to character, G is EOF, gg is SOF, and g[oO] are these mad useful
" bindings
nnoremap go o<Esc>
nnoremap gO O<Esc>
nnoremap gg go

" automatically show more information with ^G. Careful not to bind this in
" mapmode-x, as there it is used to switch from [Visual] to [Selection]
nnoremap <C-g> 2<C-g>

" remap these to go between buffers or tabs, if available. (It's not like there are
" any keys to substitute their normal behaviour)
function! CNTabCycle() abort
    if tabpagenr("$") == 1
        bnext
    else
        tabnext
        echom "Cycled to tab " . tabpagenr()
    endif
endfunction

function! CPTabCycle() abort
    if tabpagenr("$") == 1
        bprevious
    else
        tabprevious
        echom "Cycled to tab " . tabpagenr()
    endif
endfunction

nnoremap <C-n> :call CNTabCycle()<CR>
nnoremap <C-p> :call CPTabCycle()<CR>

" remap these to go between splits
" <C-[hjk]> were useless anyway, and we store <C-l> in g<C-l>
" I have obtained the use of <C-q> by running stty -ixon
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" <C-q> and <C-s> obtained by disabling flow control (stty -ixon)

" Easily close a window
nnoremap <C-q> <C-w>q

" Easily save all, but only actually write if there were changes
nnoremap <C-s> :wa<CR>

nnoremap g<C-l> <C-l>

" Actually, I think this is a bad idea.
" swap the default behaviour of g[jk] and [jk]. This means that j and k traverse
" the screen, rather than the file (particularly, going up or down on a wrapped
" line keeps you inside the line)
" I also remove them for operator-pending mode, so that eg dj and gk still work
" properly.
" noremap k gk
" noremap j gj
" ounmap k
" ounmap j
" noremap gk k
" noremap gj j

" select previously inserted text
nmap gV `[v`]

" superseded by the unimpaired plugin. Highly recommend
" map ]q :cn<CR>
" map [q :cp<CR>

" Make Q repeat the `qq` macro, rather than enter ex mode.
noremap Q @q
" Instead use gQ for ex-mode, discarding the weird fake ex-mode
noremap gQ Q

" map <Leader>wq :w<CR>:bd<CR>
" A nice and easy mapping to close a buffer, without closing vim
nnoremap <Leader>q :bd<CR>

" A quick way to strip trailing whitespace. Select an area in visual mode, or
" go to a line in normal mode, and hit <Leader>s
" TODO: make this an operator
nnoremap <Leader>s :.s/\s\+$//<CR>
xnoremap <Leader>s :s/\s\+$//<CR>

" similar mapping to make text titlecase
nnoremap <Leader>t :.s/\v<(.)(\w*)/\u\1\L\2/g<CR>
xnoremap <Leader>t :s/\v<(.)(\w*)/\u\1\L\2/g<CR>

" Converting to and from hex or binary dumps
" xxd should have been packaged together with vim, and xxd-bin-hex is a Python
" script in my ~/bin.
nnoremap <Leader>gx :.!xxd<CR>
xnoremap <Leader>gx :!xxd<CR>
nnoremap <Leader>gX :.!xxd -r<CR>
xnoremap <Leader>gX :!xxd -r<CR>
nnoremap <Leader>ggx :%!xxd<CR>
nnoremap <Leader>ggX :%!xxd -r<CR>
nnoremap <Leader>gb :.!xxd -b<CR>
xnoremap <Leader>gb :!xxd -b<CR>
nnoremap <Leader>gB :.!xxd-bin-hex <bar> xxd -r -p<CR>
xnoremap <Leader>gB :!xxd-bin-hex <bar> xxd -r -p<CR>
nnoremap <Leader>ggb :%!xxd -b<CR>
nnoremap <Leader>ggB :%!xxd-bin-hex <bar> xxd -r -p<CR>
nnoremap <Leader>gtx :.!xxd-bin-hex <bar> xxd -r -p <bar> xxd<CR>
xnoremap <Leader>gtx :!xxd-bin-hex <bar> xxd -r -p <bar> xxd<CR>
nnoremap <Leader>ggtx :%!xxd-bin-hex <bar> xxd -r -p <bar> xxd<CR>
nnoremap <Leader>gtb :.!xxd -r <bar> xxd -b<CR>
xnoremap <Leader>gtb :!xxd -r <bar> xxd -b<CR>
nnoremap <Leader>ggtb :%!xxd -r <bar> xxd -b<CR>

" mappings for cApItAlIsAtIoN
" TODO: make a proper operator of this
nnoremap <Leader>gu :.!b-cAt<CR>
nnoremap <Leader>ggu :%!b-cAt<CR>
xnoremap <Leader>gu :!b-cAt<CR>
nnoremap <Leader>gU :.!b-cAt -r<CR>
nnoremap <Leader>ggU :%!b-cAt -r<CR>
xnoremap <Leader>gU :!b-cAt -r<CR>

" mappings for Alignment of github markdown tables
nnoremap <Leader>gga :%!ghmdpp<CR>
xnoremap <Leader>ga :!ghmdpp<CR>

" E x p a n d
" TODO: again, operate
"       and make this higher IQ - it's not very adaptive
"       really it deserves its own executable
if has("python3")
    nnoremap <Leader>ge :.py3do return " ".join(line)<CR>
    nnoremap <Leader>gge :%py3do return " ".join(line)<CR>
    xnoremap <Leader>ge :py3do return " ".join(line)<CR>
    nnoremap <Leader>gE :.py3do return line[::2]<CR>
    nnoremap <Leader>ggE :%py3do return line[::2]<CR>
    xnoremap <Leader>gE :py3do return line[::2]<CR>
elseif has("python")
    nnoremap <Leader>ge :.pydo return " ".join(line)<CR>
    nnoremap <Leader>gge :%pydo return " ".join(line)<CR>
    xnoremap <Leader>ge :%pydo return " ".join(line)<CR>
    nnoremap <Leader>gE :.pydo return line[::2]<CR>
    nnoremap <Leader>ggE :%pydo return line[::2]<CR>
    xnoremap <Leader>gE :pydo return line[::2]<CR>
else
    noremap <Leader>ge :echo "my anaconda don't"<CR>
    noremap <Leader>gE :echo "my anaconda don't"<CR>
endif

if executable("jq")
    nnoremap <Leader>gj :.!jq<CR>
    nnoremap <Leader>ggj :%!jq<CR>
    xnoremap <Leader>gj :!jq<CR>
    nnoremap <Leader>gJ :.!jq -c<CR>
    nnoremap <Leader>ggJ :%!jq -c<CR>
    xnoremap <Leader>gJ :!jq -c<CR>
elseif executable("python")
    " TODO: gj mappings here
    nnoremap <Leader>gj :.!python -m json.tool<CR>
    nnoremap <Leader>ggj :%!python -m json.tool<CR>
    xnoremap <Leader>gj :!python -m json.tool<CR>
else
    noremap <Leader>gj :echo "my system don't"<CR>
endif

nnoremap <Leader>gr :.!rev<CR>
nnoremap <Leader>ggr :%!rev<CR>
xnoremap <Leader>gr :!rev<CR>

" easier window resizing with ^W+++++ and ------ and <<<<<< and >>>>>
" https://www.vim.org/scripts/script.php?script_id=2223
" TODO: implement some framework to automate this
" TODO: figure out how this works and to what extent <script> is necessary
nmap <C-W>+ <C-W>+<SID>(wresize)
nmap <C-W>- <C-W>-<SID>(wresize)
nmap <C-W>> <C-W>><SID>(wresize)
nmap <C-W>< <C-W><<SID>(wresize)
nnoremap <script> <SID>(wresize)+ <C-W>+<SID>(wresize)
nnoremap <script> <SID>(wresize)- <C-W>-<SID>(wresize)
nnoremap <script> <SID>(wresize)> <C-W>><SID>(wresize)
nnoremap <script> <SID>(wresize)< <C-W><<SID>(wresize)
nnoremap <script> <SID>(wresize)= <C-W>=<SID>(wresize)
nmap <script> <SID>(wresize) <Nop>

" easier horizontal scrolling with zllllll and LLLL and hhh and HHHHH
" as seen in "easier window resizing"
nmap zh zh<SID>(hscroll)
nmap zl zl<SID>(hscroll)
nmap zH zH<SID>(hscroll)
nmap zL zL<SID>(hscroll)
nnoremap <script> <SID>(hscroll)h zh<SID>(hscroll)
nnoremap <script> <SID>(hscroll)l zl<SID>(hscroll)
nnoremap <script> <SID>(hscroll)H zH<SID>(hscroll)
nnoremap <script> <SID>(hscroll)L zL<SID>(hscroll)
nmap <script> <SID>(hscroll) <Nop>

" Commentary functions but explicitly set commentstring to /*%s*/
" TODO: make work
function! StarCommentarySetup() abort
    let b:goedel_star_commentstring_store =  &commentstring
    setlocal commentstring=/*%s*/
endfunction

function! StarCommentaryTeardown() abort
    let &l:commentstring = b:goedel_star_commentstring_store
endfunction

" nmap <Leader>*gcu :call StarCommentary() <bar> call StarCommentary()<CR>
nmap <Leader>*gcc :call StarCommentarySetup()<CR><Plug>CommentaryLine:call StarCommentaryTeardown()<CR>
" omap <Leader>*gc :call StarCommentary()<CR>
" nmap <Leader>*gc :call StarCommentary()<CR>
" xmap <Leader>*gc :call StarCommentarySetup()<CR><Plug>Commentary:call StarCommentaryTeardown()<CR>

" Indent/dedent by a single space
" I think this is probably pretty kludgey, but it seems to work
" FIXME: v10<Right><Esc>. doesn't work to repeat the motion.
function! IndentOne(type, ...) abort
    let l:goedel_shiftwidth_store = &shiftwidth
    " set local to minimise destructive potential
    setlocal shiftwidth=1
    if a:0
        exec "normal! gv" . v:count1 . ">"
    else
        exec "normal! '[" . v:count1 . ">']"
    endif
    exec "setlocal shiftwidth=" . l:goedel_shiftwidth_store
endfunction

function! DedentOne(type, ...) abort
    let l:goedel_shiftwidth_store = &shiftwidth
    setlocal shiftwidth=1
    if a:0
        exec "normal! gv" . v:count1 . "<"
    else
        exec "normal! '[" . v:count1 . "<']"
    endif
    exec "setlocal shiftwidth=" . l:goedel_shiftwidth_store
endfunction

nnoremap <silent> <expr> <Right> ":<C-U>set operatorfunc=IndentOne<CR>" . v:count1 . "g@"
nnoremap <silent> <expr> <Right><Right> ":<C-U>set operatorfunc=IndentOne<CR>" . v:count1 . "g@g@"
xnoremap <silent> <Right> :<C-U>call IndentOne(visualmode(), v:count1)<CR>gv

nnoremap <silent> <expr> <Left> ":<C-U>set operatorfunc=DedentOne<CR>" . v:count1 . "g@"
nnoremap <silent> <expr> <Left><Left> ":<C-U>set operatorfunc=DedentOne<CR>" . v:count1 . "g@g@"
xnoremap <silent> <Left> :<C-U>call DedentOne(visualmode(), v:count1)<CR>gv

" Experimental demonstration proof of concept of a lockdown mode for when you
" want to confuse people. Enter with <Leader>~, exit with ^6
" TODO what was the space for again
nmap <Leader>~ :enew<CR>:MakeScratch<CR>iPASTA<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space>q Actually,<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space><Esc> HAHA,<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space><C-c> hehe,<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space>w I<Space>would<Space>like<Space>to<Space>interject<Space>for<Space>a<Space>moment.<CR><SID>(pasta)<Space>
" doesn't work because this script is greedy on prefixes, I think
" imap <script> <SID>(pasta)<Space><F7> I<Space>just<Space>need<Space>to<Space>axe<Space>you<Space>a<Space>few<Space>questions<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space><C-^> <Esc>u:bd<CR>
imap <script> <SID>(pasta)<Space> <Nop>

" open various config files in Vim (eg Vim Vimrc, Vim Gvimrc)
nmap <Leader>vv :Evr<CR>
nmap <Leader>vg :Egr<CR>
nmap <Leader>vz :Ezr<CR>
nmap <Leader>vx :Exr<CR>
nmap <Leader>va :Ear<CR>
nmap <Leader>v3 :E3r<CR>
nmap <Leader>vf :Efr<CR>
nmap <Leader>vt :Etr<CR>
nmap <Leader>vu :Eur<CR>

nnoremap yo@ :call ToggleUHex()<CR>
nnoremap yo` :call ToggleColumn()<CR>

" Toggle extra transparency, with a mapping prefix in the style of tpope's
" unimpaired. This is because for example in URXVT I only have a transparent
" background, and my statusline and crosshairs are solid, but I can't decide
" whether or not I like it.
nnoremap yot :silent exec "!transset-df --id $WINDOWID -t 0.98"<CR><C-l>
