" FIGMENTIZE: mappingsrc
"                                  .__            ____
"   _____  _____   ______  ______  |__|  ____    / ___\  _____________   ____
"  /     \ \__  \  \____ \ \____ \ |  | /    \  / /_/  >/  ___/\_  __ \_/ ___\
" |  Y Y  \ / __ \_|  |_> >|  |_> >|  ||   |  \ \___  / \___ \  |  | \/\  \___
" |__|_|  /(____  /|   __/ |   __/ |__||___|  //_____/ /____  > |__|    \___  >
"       \/      \/ |__|    |__|             \/              \/              \/

" This is a file of all my vim mappings. They might be in decreasing order of
" favouritism (ie, if I can be bothered, I will put my more useful mappings
" nearer the top. Some inspiration from
" https://github.com/anowlcalledjosh/dotfiles/blob/master/.vimrc
" and
" https://github.com/tpope/vim-sensible

" self explanatory
function! LaughManiacally()
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
" TODO: similar mapping for normal mode? (probably redundant due to ^R^O+)
nnoremap <Leader>p :set paste!<CR>

" crap, these turn the scrollwheel into a
" weapon  of mass destruction.
" " Up and down to move lines around
" " noremap <Up> ddkP
" " noremap <Down> ddp

" Shortcut to turn highlighting on or off
nnoremap <silent> <CR> :call ToggleHighlight()<CR>
inoremap <silent> <F3> <C-o>:call IToggleHighlight()<CR>

" Store the original carriage return for the CR fans
nnoremap g<CR> <CR>

" However, in the command-line window I do want CR to be a normal CR, so I
" automatically unset and reset this mapping.
augroup CmdWinCRRestore
    autocmd!
    autocmd CmdwinEnter * nunmap <CR>
    autocmd CmdwinLeave * nnoremap <CR> :call ToggleHighlight()<CR>
augroup END

" Search for selected text. This makes * and # work for visual selections, so
" you can search for things that aren't a unit of text as defined by * and # by
" default. It seems fairly black magicky, it comes from
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
let s:save_cpo = &cpo | set cpo&vim
if !exists('g:VeryLiteral')
    let g:VeryLiteral = 0
endif
function! s:VSetSearch(cmd)
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
  \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
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
function! RepeatChar(char, count)
    return repeat(a:char, a:count)
endfunction
nnoremap S :exec "normal! i".RepeatChar(nr2char(getchar()), v:count1)<CR>
" and similar for append single character
nnoremap <Leader>S :exec "normal! a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" Am I crazy?? this makes much more sense. nG is used to go to line, ngg is
" used to go to character, G is EOF, gg is SOF, and g[oO] are these mad useful
" bindings
nnoremap go o<Esc>
nnoremap gO O<Esc>
noremap gg go<Esc>

" automatically show more information with ^G. Careful not to bind this in
" mapmode-x, as there it is used to switch from [Visual] to [Selection]
nnoremap <C-g> 2<C-g>

" remap these to go between buffers. Not like there are any keys to substitute
" their normal behaviour
nmap <C-p> :bp<CR>
nmap <C-n> :bn<CR>

" remap these to go between splits
" <C-[hjk]> were useless anyway, and we store <C-l> in g<C-l>
" I have obtained the use of <C-q> by running stty -ixon
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Easily close a window
nnoremap <C-q> <C-w>q

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

" replace these with the screen versions. This means that if you some tab width,
" it replaces that many characters rather than a single one, ensuring that
" characters on the screen don't jump around.
" Of course, you can still access the originals as they're just swapped
noremap R gR
noremap r gr
noremap gR R
noremap gr r

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
nmap <Leader>q :bd<CR>

" A quick way to strip trailing whiteSpace. Select an area in visual mode, and
" hit <Leader>s.
" TODO: make this a proper operator
map <Leader>s :s/\s\+$//<CR>

" similar mapping to make text titlecase
map <Leader>t :s/\v<(.)(\w*)/\u\1\L\2/g<CR>

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
nmap <SID>(wresize) <Nop>

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
nmap <SID>(horscroll) <Nop>

" Indent/dedent by a single space
" I think this is probably pretty kludgey, but it seems to work
" FIXME: v10<Right><Esc>. doesn't work to repeat the motion.
function! IndentOne(type, ...)
    let l:goedel_shiftwidth_store = &shiftwidth
    set shiftwidth=1
    if a:0
        exec "normal! gv" . v:count1 . ">"
    else
        exec "normal! '[" . v:count1 . ">']"
    endif
    exec "set shiftwidth=" . l:goedel_shiftwidth_store
endfunction

function! DedentOne(type, ...)
    let l:goedel_shiftwidth_store = &shiftwidth
    set shiftwidth=1
    if a:0
        exec "normal! gv" . v:count1 . "<"
    else
        exec "normal! '[" . v:count1 . "<']"
    endif
    exec "set shiftwidth=" . l:goedel_shiftwidth_store
endfunction

nnoremap <silent> <expr> <Right> ":<C-U>set operatorfunc=IndentOne<CR>" . v:count1 . "g@"
nnoremap <silent> <expr> <Right><Right> ":<C-U>set operatorfunc=IndentOne<CR>" . v:count1 . "g@g@"
xnoremap <silent> <Right> :<C-U>call IndentOne(visualmode(), v:count1)<CR>gv

nnoremap <silent> <expr> <Left> ":<C-U>set operatorfunc=DedentOne<CR>" . v:count1 . "g@"
nnoremap <silent> <expr> <Left><Left> ":<C-U>set operatorfunc=DedentOne<CR>" . v:count1 . "g@g@"
xnoremap <silent> <Left> :<C-U>call DedentOne(visualmode(), v:count1)<CR>gv

" Experimental demonstration proof of concept of a lockdown mode for when you
" want to confuse people. Enter with <Leader>~, exit with ^6
nmap <Leader>~ :enew<CR>:MakeScratch<CR>iPASTA<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space>q Actually,<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space><Esc> HAHA,<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space>w I<Space>would<Space>like<Space>to<Space>interject<Space>for<Space>a<Space>moment.<CR><SID>(pasta)<Space>
imap <script> <SID>(pasta)<Space><C-^> <Esc>u:bd<CR>
imap <SID>(pasta)<Space> <Nop>

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

" Toggle extra transparency, with a mapping prefix in the style of tpope's
" unimpaired. This is because for example in URXVT I only have a transparent
" background, and my statusline and crosshairs are solid, but I can't decide
" whether or not I like it.
nnoremap yot :silent exec "!transset-df --id $WINDOWID -t 0.98"<CR><C-l>