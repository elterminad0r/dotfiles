"                  __   .__
"   ____  ______ _/  |_ |__|  ____    ____    _____________   ____
"  /  _ \ \____ \\   __\|  | /  _ \  /    \  /  ___/\_  __ \_/ ___\
" (  <_> )|  |_> >|  |  |  |(  <_> )|   |  \ \___ \  |  | \/\  \___
"  \____/ |   __/ |__|  |__| \____/ |___|  //____  > |__|    \___  >
"         |__|                           \/      \/              \/
" FIGMENTIZE: optionsrc

" sub RC file with all the options I set. Similarly to mappingsrc, they are
" ordered roughly by how much I like them.

" Some are not different from the default, but I like things to be explicit and
" in one place.

" Avoid side effects ONLY IF `nocp` already set. THIS IS CRUCIALLY IMPORTANT
" Basically everything breaks if you don't do this
" setting nocompatible is very important as it's no longer 1970.
if &compatible
    set nocompatible
endif

" The following couple of options set Vim to write lots of useful metadata about
" files in directories inside ~/.vim. These should be automatically created by
" my vimrc, with the MkDirP function.
" This obviously isn't always desired - if you're editing files with sensitive
" content, you'll want to disable all of this. Currently I have it set up so I
" have an alias visafe in ~/.goedel_aliases which turns all this crap off to the
" best of its ability.

" enable modelines, for backwards systems like MacOS that disable them by
" default.
set modeline
set modelines=5

" Write backup files. Disk is cheap, write speeds are fast, and you never know.
set backup
set writebackup
set backupdir=~/.vim/backups

" set sessionoptions to not store options - both makes session files much
" smaller, and means that options change. I consider options to be a globally
" evolving thing really, and have no need for old sessions to hang on to the
" past.
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize
if has("terminal")
    set sessionoptions+=terminal
endif

" Automatically write session files. Uniquely identified with a timestamp.
" I have a revim alias in ~/.goedel_aliases to reopen the last session. This is
" more powerful than what you'd get using viminfo, as it can sort of restore
" tabs and window splits.
function! TimeStampSession()
    let l:goedel_session_name = "~/.vim/sessions/" . strftime("%s") . ".vim"
    execute "mksession " . l:goedel_session_name
    echo "wrote " . l:goedel_session_name
endfunction

augroup AutoSession
    autocmd! VimLeave * call TimeStampSession()
augroup end

" Keep swap files out of the way
set directory^=~/.vim/swap

" save 10000 levels of undo
set undolevels=10000
" cache entire buffers under 10000 lines
set undoreload=10000

" Persistent undo history written
set undofile
set undodir=~/.vim/undo

" store :mkview files here
set viewdir=~/.vim/view

" Preserve vim state:
" (lack of %): don't store bufferlist. This means that vim with no arguments
"              opens cleanly, which is nicer generally because sometimes you get
"              weird tempfiles from git commits or command line editing. I
"              automatically write session files to ~/.vim/sessions as well,
"              which provide the functionality of un-closing a vim with a
"              precious bufferlist (among other things). See
"              $ZDOTDIR/goedel_aliases.sh
" '100: store marks for 100 previously edited files
" /100: store 100 previous searches
" :100: store 100 previous commands issued
" <1000000: store at most 1000000 lines of each buffer
" @1000: store 1000 lines of input-line history
" s10000: allow items to be 10000 Kbyte in size
set viminfo='100,/100,:100,<1000000,s10000,@1000,h,n~/.vim/viminfo

" remember 10000 lines of command-line history in memory
set history=10000

" Set up a thesaurus and dictionary
" TODO: add a dutch one (after locating it)
set thesaurus=~/.vim/thesaurus/thesaurus_pkg/thesaurus.txt
" spellcapcheck set to nothing stops vim from whining about capitalisation in
" the middle of sentences.
set spelllang=en_gb,nl spellcapcheck=
" Make files be "text" by default
" augroup TextFileType
"     autocmd! BufEnter * if &filetype == "" | setlocal ft=text | endif
" augroup END
" Enable spelling for these filetypes
set spell
" augroup SpellingFiles
"     autocmd! FileType latex,tex,text,markdown setlocal spell
" augroup END

" don't show mode as the lightline plugin does this already.
set noshowmode

" always show status line, so I can bask in the glory of lightline
set laststatus=2
" Always display the tabline, even if there is only one tab, for consistency's
" sake
set showtabline=2

" Keep 5 lines and 10 cols of context on the screen
set scrolloff=5
set sidescrolloff=10
" When walking off the screen, jump 5 rows or 10 columns at a time. This
" prevents too many redraws when you're making small movements near the edge of
" the screen.
set scrolljump=5
set sidescroll=10

" display current cursor position
set ruler
" display long normal-mode commands as they're typed
set showcmd
" show matches for a search live as you type them
set incsearch
" let visual block mode go off the end
" FIXME: decide if I like "all" or not
set virtualedit=block

" these options provide a kind of crosshair on the cursor. It looks kind of cool
" and can be useful to snap your vision to the cursor, but it can also cause
" slower redrawing.
set cursorline
set cursorcolumn

" Folding settings: show a column indicating where there are folds. Open all
" folds by default (use zM to close, zR to set foldlevel correctly for file)
set foldcolumn=1
set foldenable
" automatically create folds by indent level. I'm a pretty ardent indenter, so
" this normally suffices for me.
set foldmethod=indent
" set foldlevel to the deepest fold in the file
" An alternative autocmd event is BufWinEnter, but this is a little too eager
" for my tastes. Done this way, it shouldn't mess anything up too badly if you
" swap between buffers in one window a lot. Also, files with modelines setting
" foldmethod don't get overridden.
augroup SetFoldLevel
    autocmd! BufReadPost * normal! zR
augroup END

" delays for mappings and keycodes
" make <Esc> work with minimal delay.
set timeout
set nottimeout
" make there be effectively no timeout for mappings
" god help you if you take 100 seconds to type out a mapping
set timeoutlen=100000
" make keycodes (like Escape) be really fast
set ttimeoutlen=10

" prevent langmap from messing up mappings
if has('langmap') && exists('+langnoremap')
    set langnoremap
endif
" Makes % more sophisticated sometimes?
" I'm not sure if this works, and actually mostly it just seems kind of fragile.
" packadd matchit

" line numbers, that are relative to current line
" allegedly lets you judge repetitions of movement commands, and it looks cool
" the set number means that the absolute current line number *is* displayed, but
" the rest are relative.

" Also, they're made absolute again when you go back into insert mode. I think
" that's kind of cool but I don't know if I'll keep it.
set number
set relativenumber
augroup InsertModeLineNos
    autocmd!
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
augroup END

" whitespace
" tab = 4 spaces, and various associated options
set autoindent
set expandtab
set tabstop=4
set shiftwidth=0
set softtabstop=-1
set shiftround

set nojoinspaces
" t: wrap text at text width
" c: autowrap comments
" q: be clever about formatting comments with gq
" j: be clever about formatting comments with J
" r: add a new comment leader when <CR> hit in a comment
" o: add a new comment leader when o hit in normal mode
" n: be clever about formatting numbered lists, eg
"    1. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"    2. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"   - Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"     tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"     + Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"       * Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
"         eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
"   (see also: set formatlistpat)
" l: do not break a line that was already too long before insertion
set formatoptions+=tcqjronl
" this makes the vim auto-formatting recognise unordered 'bullet point' lists
" using -+*, in addition to the default ordered lists with numbers
set formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*\\\|^\\s*[-+*]\\s*
" this makes vim recognise \item s in TeX files
augroup TexListPat
    autocmd! FileType tex
                \ setlocal formatlistpat+=\\\|^\\s*\\item\\(\\[[^\\]]*\\]\\)\\?\\s*
augroup END

" shorten certain types of diagnostic/informational messages more (eg [+]
" instead of "written")
set shortmess=atToO

" when incrementing & decrementing with ^A, ^X
set nrformats=bin,hex,alpha

" Use <Leader>p to toggle paste mode
" actually I'd rather just map this myself, as I don't want it to work in insert
" mode
set pastetoggle=<F2>

" name and shame any actual tabs
set list
" I don't know but this certainly doesn't seem to work on vim 800 on MacOS
if v:version >= 801
    set listchars=tab:<->
else
    set listchars=tab:>-
endif

" show hex characters as codes
set display+=uhex

" text width is 80 and mark it out
set textwidth=80
set colorcolumn=+1

" Settings for line wrapping
set linebreak
set breakindent
set display+=lastline
set showbreak=+++\ 

" backspace, space, ~ can go between lines in normal/visual mode
" also allow <Left> and <Right> to do this, even though I remap these, for the
" sake of gvim users.
set whichwrap=b,s,~,<,>,[,]

" Let backspaces in insert mode delete lines, I think
set backspace=indent,eol,start
" backspace key fix?
set t_kb=

" ignore case in search
set ignorecase
" completion becomes case insensitive if it can't find anything sensitive
set smartcase
" Adjusts completed case to match
set infercase
" set good encryption
set cryptmethod=blowfish2

" This is when vim does stuff with :find or something
set path=.,**
set wildmenu
set wildignorecase
" set wildignore+=*.pyc,*.swp,__pycache__,*.aux
" Prefer suffixes - this just defers files rather than totally ignores them
set suffixes+=*.pyc,*.swp,__pycache__,*.aux
set complete=.,w,b,u,t,i

" Suffixes to try on the "gf" command. This lets me open \include{}-ed files or
" import-ed files.
set suffixesadd+=.tex,.sty.bib,.cls,.py

" Change directory to file being edited. This just aligns with how I like to
" think, I suppose.
set autochdir

" keep buffers not in a window open in memory. preserves undo history for
" buffers etc
set hidden

" If switching to a buffer that's open in another window or tab, just open that
" note that this works with splitting commands only, eg sbm instead of bm, sb
" instead of b
set switchbuf+=useopen,usetab

" tag binary search
set tagbsearch
" fancy business showing entire definition
set showfulltag
" treat casing in TAGS as in the smartcase option
set tagcase=followscs
" tags are relative to the location of the tags file, obviously
set tagrelative

" Automatically reload changed files if they've not been changed within Vim
set autoread

" confirmation dialogue when closing an unsaved file
set confirm

" Don't redraw as eagerly (eg during macro expansion)
set lazyredraw

" Make it so new buffers are opened going to the right and down. We live in a
" society.
set splitright
set splitbelow
