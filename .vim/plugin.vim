"         .__            ____  .__
" ______  |  |   __ __  / ___\ |__|  ____ _______   ____
" \____ \ |  |  |  |  \/ /_/  >|  | /    \\_  __ \_/ ___\
" |  |_> >|  |__|  |  /\___  / |  ||   |  \|  | \/\  \___
" |   __/ |____/|____//_____/  |__||___|  /|__|    \___  >
" |__|                                  \/             \/
" FIGMENTIZE: pluginrc

" This sets up all the plugins I use, using vim-plug
" https://github.com/junegunn/vim-plug
" To install all plugins, run :PlugInstall

" My essential plugins shortlist, in decreasing order of favouritism. I have
" first grouped together the ''passive'' plugins, that mostly mind their own
" business until they're summoned:
" vim-plug: the plugin manager behind it all. Can clone plugin repositories in
"   parallel.
" vim-commentary: comment toggle with gc[motion]. supports text objects and
"   really everything else that you could ever want.
" vim-surround: allows changing the surrounding of a text object. eg
"   cs({ changes surrounding () to {}, or dst deletes surrounding HTML.
" easymotion: provides mappings like \\w to jump to a word in a piddling number
"   of keystrokes.
" vim-fugitive: provides vim commands to use Git. (eg Gblame shows a blame in a
"     scrollbound buffer, Gcommit, Gdiff...)
" vim-indent-object: provides textobjects ii, ai, iI, aI to use with indented
"   blocks of text. I find it supersedes several other types of text object.
" vim-textobj-line: provides a line textobject (eg gUil)
" vim-textobj-entire: provides textobj for entire buffer (eg guag)
"   I personally have this mapped to ag, as gg and G are the start/end.
" vim-textobj-fold: provides textobject for a fold.
" undotree: visualizes the undotree much more accessibly in a cute little side
"   window
" vim-vinegar: use netrw as a sort of little nerdtree thing
" vim-eunuch: vim command interface for UNIX shell commands. mostly just to
"             provide :Rename and :Move
" Goyo : provides a distraction-free editing mode through :Goyo. Interfaces well
"   with lightline.
" ultisnips (together with vim-snippets): snippet engine and manager. Lets you
"   do things like type for<C-s> or GPL3<C-s> to expand snippets.
" vim-Verdin: provides omnicomplete for VimL files (i_^X^O)
" python-syntax: provides cleverer syntax highlighting for Python (eg that's
"   aware of format strings, and doesn't highlight "file")

" Active plugins:
" quick-scope: highlight characters in the current line that can be "scoped"
"   with [ftFT]
" airline with airline-themes: a nicer statusline, and a tabline that
"   lists buffers.
" rainbow: coherent highlighting of nested delimiter pairs

" FIXME: decide: Do I like the normie bloat plugins:
" syntastic, gitgutter, YCM, ale, tagbar
call plug#begin('~/.vim/bundle')
    " Completion for unicode type things with ^X^Z
    " friendlier completion for digraphs with ^X^G
    " Plug 'chrisbra/unicode.vim'

    " Plug plug itself in order to generate documentation for it
    Plug 'junegunn/vim-plug'

    " enhance netrw to be a bit prettier
    " TODO: probably phase this out into just personal config
    Plug 'tpope/vim-vinegar'

    " Git stuff
    Plug 'tpope/vim-fugitive'

    " Tmux stuff
    Plug 'tpope/vim-tbone'

    " ^A^X work with dates and times
    Plug 'tpope/vim-speeddating'

    " Get unix utils like rm as vim commands. Less of the !rm and !chmod etc
    Plug 'tpope/vim-eunuch'

    " plugin to remove distractions in order to do some writing
    Plug 'junegunn/goyo.vim'

    " provide motions like \\w that enable highly shannon efficient jumps throughout
    " buffers. This is pretty darn cool
    Plug 'easymotion/vim-easymotion'

    " support for fzf
    " TODO start using this (:Files, :Buffers, :GFiles)
    Plug 'junegunn/fzf.vim'

    " this might be useful idk
    " TODO figure out which bits i need
    Plug 'godlygeek/tabular'

    " remap + for easyalign. I use ga more often than I might think.
    nmap + <Plug>(EasyAlign)
    xmap + <Plug>(EasyAlign)
    " plugin to do text alignment
    Plug 'junegunn/vim-easy-align'

    " " solarized colorscheme for vim
    let g:solarized_termtrans = 0
    "  let g:solarized_termcolors = 16
    "  let g:solarized_contrast="high"
    Plug 'altercation/vim-colors-solarized'
    " let g:gruvbox_termcolors=300
    " let g:gruvbox_undercurl = 1
    let g:gruvbox_italic = 1
    " mnemonic: toggle slant
    nnoremap yo/ :let g:gruvbox_italic = !g:gruvbox_italic <bar> colorscheme gruvbox<CR>
    Plug 'morhetz/gruvbox'

    let g:airline_detect_modified=1

    " enable paste detection >
    let g:airline_detect_paste=1
    " enable crypt detection >
    let g:airline_detect_crypt=1

    " enable spell detection >
    let g:airline_detect_spell=1

    " display spelling language when spell detection is enabled
    " (if enough space is available) >
    let g:airline_detect_spelllang=1
    " enable iminsert detection >
    let g:airline_detect_iminsert=1
    " determine whether inactive windows should have the left section collapsed to
    " only the filename of that buffer.  >
    " let g:airline_inactive_collapse=0
    " Use alternative separators for the statusline of inactive windows >
    " let g:airline_inactive_alt_sep=1
    " themes are automatically selected based on the matching colorscheme. this
    " can be overridden by defining a value. >
    " let g:airline_theme='cool'
    " let g:airline_theme='gruvbox'

    " let g:airline_theme_patch_func = 'AirlineThemePatch'
    " function! AirlineThemePatch(palette)
    "     if g:airline_theme == 'badwolf'
    "         for colors in values(a:palette.inactive)
    "             let colors[3] = 245
    "         endfor
    "     endif
    " endfunction

    let g:airline_mode_map = {
        \ '__' : '------',
        \ 'c'  : 'C',
        \ 'i'  : 'I',
        \ 'ic' : 'I C',
        \ 'ix' : 'I C',
        \ 'n'  : 'N',
        \ 'ni' : '(I)',
        \ 'no' : 'O',
        \ 'R'  : 'R',
        \ 'Rv' : 'V R',
        \ 's'  : 'S',
        \ 'S'  : 'S-L',
        \ '' : 'S-B',
        \ 't'  : 'T',
        \ 'v'  : 'V',
        \ 'V'  : 'V-L',
        \ '' : 'V-B',
        \ }

    function! AirlineViewThemes()
        for theme in airline#util#themes("")
            execute "AirlineTheme " . theme
            redraw!
            echomsg theme
            call getchar()
        endfor
    endfunction

    " show buffer numbers in bufferline in tabline
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#buffer_nr_format = '%s '

    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    if $GOEDEL_NO_POWERLINE != "true"
        let g:airline_symbols_powerline = 1
        let g:airline_powerline_fonts = 1
        " copy dirty symbol from p9k
        let g:airline_symbols.dirty = ' ●'
    else
    "     let g:airline_symbols.maxlinenr = 'L'
    "     let g:airline_symbols.dirty = '!'
        let g:airline_symbols_ascii = 1
        let g:airline_symbols.branch = '|/'
        let g:airline_symbols.readonly = 'RO'
        let g:airline_symbols.notexists = '[?]'
        let g:airline_symbols.linenr = ''
        let g:airline_symbols.maxlinenr = 'L'
        let g:airline_symbols.whitespace = 'W'
        let g:airline_symbols.crypt = '[X]'
    endif

    " unicode symbols
    " let g:airline_left_sep = '»'
    " let g:airline_left_sep = '▶'
    " let g:airline_right_sep = '«'
    " let g:airline_right_sep = '◀'
    " let g:airline_symbols.crypt = '🔒'
    " let g:airline_symbols.linenr = '☰'
    " let g:airline_symbols.linenr = '␊'
    " let g:airline_symbols.linenr = '␤'
    " let g:airline_symbols.linenr = '¶'
    " let g:airline_symbols.maxlinenr = ''
    " let g:airline_symbols.maxlinenr = '㏑'
    " let g:airline_symbols.branch = '⎇'
    " let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'P'
    " let g:airline_symbols.paste = '∥'
    let g:airline_symbols.spell = 'S'
    " let g:airline_symbols.notexists = 'Ɇ'
    " let g:airline_symbols.whitespace = 'Ξ'
    " let g:airline_symbols.linenr = 'ln'
    " let g:airline_symbols.crypt = 'CRYPT'
    " let g:airline_symbols.whitespace = 'WS'

    " define the set of text to display for each mode.  >
    " let g:airline_mode_map = {} " see source for the defaults

    let g:airline_filetype_overrides = {
        \ 'help':  [ 'Help', '%f' ],
        \ 'vim-plug': [ 'Plugins', '' ],
        \ }

    " * Do not draw separators for empty sections (only for the active window) >
    let g:airline_skip_empty_sections = 1
    " <
    " This variable can be overriden by setting a window-local variable with
    " the same name (in the correct window): >
    " let w:airline_skip_empty_sections = 0
    " <
    " * Caches the changes to the highlighting groups, should therefore be faster.
    " Set this to one, if you experience a sluggish Vim: >
    let g:airline_highlighting_cache = 1
    " <
    " * disable airline on FocusLost autocommand (e.g. when Vim loses focus): >
    " let g:airline_focuslost_inactive = 1
    " <
    " * configure the fileformat output
    " By default, it will display something like 'utf-8[unix]', however, you can
    " skip displaying it, if the output matches a configured string. To do so, set >
    let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
    " <
    " * Display the statusline in the tabline (first top line): >
    " let g:airline_statusline_ontop = 1

    let g:airline#extensions#tabline#enabled = 1
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-airline/vim-airline'
    " Plug 'bling/vim-bufferline'

    " visualise the undo tree in a tree, rather than a flat list, using
    " :UndoTreeToggle
    Plug 'mbbill/undotree'

    " Text objects for indented blocks, with ii, iI, ai, aI
    Plug 'michaeljsmith/vim-indent-object'

    " redefine word motions to go inside of underscore_cased or CamelCased phrases.
    " top tip: use the "aw" textobject to operate on vanilla words
    " W, E, B, gE also remain unaffected.
    " if you want  to Change Word, use ce.
    " eh, this causes some kind of weird behaviour, particularly with iw and
    " jumping over some kinds of punctuation etc.
    Plug 'bkad/CamelCaseMotion'
    map <silent> <Leader>w <Plug>CamelCaseMotion_w
    map <silent> <Leader>b <Plug>CamelCaseMotion_b
    " map <silent> e <Plug>CamelCaseMotion_e
    " map <silent> ge <Plug>CamelCaseMotion_ge
    " " use these so that ciw, diw, cw, dw etc act like normal
    omap <silent> i<Leader>w <Plug>CamelCaseMotion_ie
    xmap <silent> i<Leader>w <Plug>CamelCaseMotion_ie
    " omap <silent> cw c<Plug>CamelCaseMotion_e
    " xmap <silent> cw c<Plug>CamelCaseMotion_e
    " don't set these because I value my textobject suffix entropy
    " omap <silent> ib <Plug>CamelCaseMotion_ib
    " xmap <silent> ib <Plug>CamelCaseMotion_ib
    " " these conflict with latex and i'm not sure what they're for anyway.
    " " omap <silent> ie <Plug>CamelCaseMotion_ie
    " " xmap <silent> ie <Plug>CamelCaseMotion_ie
    " omap <silent> iE <Plug>CamelCaseMotion_ie
    " xmap <silent> iE <Plug>CamelCaseMotion_ie

    " Note-taking in vim
    " vim-misc is a sort of supplementary standard library for vimscript, by xolox,
    " for xolox
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-notes'

    " nifty little plugin to show what the targets of f, t, F, T are.
    Plug 'unblevable/quick-scope'

    " better syntax highlighting for Python (eg f-strings)
    let g:python_highlight_all = 1
    Plug 'vim-python/python-syntax', { 'for': 'python' }

    " let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
    " make all of my parentheses look like clown vomit
    " see :h cterm-colors
    let g:rainbow_conf = {
        \ 'guifgs': ['Grey', 'LightBlue', 'LightGreen', 'LightCyan', 'LightMagenta', 'LightYellow', 'White'],
        \ 'ctermfgs': ['Grey', 'LightBlue', 'LightGreen', 'LightCyan', 'LightMagenta', 'LightYellow', 'White'],
        \ }
    Plug 'luochen1990/rainbow'
    nnoremap yo( :RainbowToggle<CR>

    " vimgrep-like thing but with ack, but actually with ag
    if executable('ag')
        let g:ackprg = 'ag --vimgrep'
    endif
    Plug 'mileszs/ack.vim'

    " makes gc comment-uncomment lines
    Plug 'tpope/vim-commentary'

    " allow operations on the surround bits of text objects with the 's' prefix.
    " eg cs({ changes () to {}
    " Disable the weird <C-s> mapping to insert surround things in insert mode
    let g:surround_no_insert_mappings = 1
    Plug 'tpope/vim-surround'
    " make . repeat some compatible <Plug> commands,
    " and provide some infrastructure to do this myself in other places.
    Plug 'tpope/vim-repeat'

    " mappings for ex commands like :cnext, :cprevious, etc
    " also the yo* mappings toggle things (eg yox to toggle crosshairs)
    Plug 'tpope/vim-unimpaired'

    " This is a dependency for some of the other textobject related plugins
    Plug 'kana/vim-textobj-user'

    " Access lines as text objects with 'l'
    Plug 'kana/vim-textobj-line'

    " textobjects for folds
    Plug 'kana/vim-textobj-fold'

    " makes modern objfpc .pas files be highlighted properly (eg understand //
    " commnents and the `result` variable)
    " FIXME various extensions (.dpr, .lpr) not recognised
    Plug 'rkennedy/vim-delphi', { 'for': 'pascal' }

    " autocompletion for vim files
    Plug 'machakann/vim-Verdin', { 'for': 'vim' }

    " I want e to be a LaTeX environment, so will use g instead.
    let g:textobj_entire_no_default_key_mappings=1
    Plug 'kana/vim-textobj-entire'

    xmap ag <Plug>(textobj-entire-a)
    omap ag <Plug>(textobj-entire-a)

    if has("python") || has("python3")
        " Set of snippets for ultisnips to use
        Plug 'honza/vim-snippets'

        " Snippet engine for vim
        let g:UltiSnipsExpandTrigger="<C-s>"
        let g:UltiSnipsJumpForwardTrigger="<Right>"
        let g:UltiSnipsJumpBackwardTrigger="<Left>"
        let g:UltiSnipsEditSplit="vertical"
        " mnemonic: "help"
        " this used to be a backspace, but we have a key for that nowadays
        " this does, however, break xterm
        let g:UltiSnipsListSnippets="<C-h>"
        " let g:UltiSnipsSnippetsDir = $HOME.'/vimfiles/bundle/vim-snippets/UltiSnips'
        " let g:UltiSnipsSnippetDirectories = ['UltiSnips']
        Plug 'SirVer/ultisnips'
        " TODO: maybe move away from this, it's a little intrusive
    endif

    " " vimtex options
    " let g:vimtex_view_method = 'zathura'
    " let g:vimtex_latexmk_progname = 'vim'
    "  FIXME this is basically still super broken. This is supposed to be a fix
    "  for the quickfix thing, but it still just sends you to the "master" file
    " let g:vimtex_quickfix_method = 'pplatex'
    " " tell vimtex i'm not a total nutjob
    " let g:tex_flavor = 'latex'
    " Plug 'lervag/vimtex'

call plug#end()
