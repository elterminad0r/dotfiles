" FIGMENTIZE: nvimrc
"               .__
"   ____ ___  __|__|  _____ _______   ____
"  /    \\  \/ /|  | /     \\_  __ \_/ ___\
" |   |  \\   / |  ||  Y Y  \|  | \/\  \___
" |___|  / \_/  |__||__|_|  /|__|    \___  >
"      \/                 \/             \/

" This is my rc file for nvim. It was copied over from an old version of my
" vimrc file and is not properly maintained.

" note to self ":set rl": this is funny

" delete all previous autocmds. This is probably pure paranoia but the horrors
" I've endured...
autocmd!

" Powerline configuration. Make sure vim stays usable when in a TTY
if &term != "linux"
"     source ~/.vim/bundle/powerline/powerline/bindings/vim/plugin/powerline.vim
    " don't show mode as powerline does this
    set noshowmode
endif

" show status lines
set laststatus=2
" Always display the tabline, even if there is only one tab
set showtabline=2

" vimtex options
let g:vimtex_view_method = 'zathura'
let g:vimtex_latexmk_progname = 'vim'
" FIXME this is basically still super broken. This is supposed to be a fix for
" the quickfix thing, but it still just sends you to the "master" file
let g:vimtex_quickfix_method = 'pplatex'

" for some reason we should stop
if v:progname =~? "evim"
    finish
endif

" " use this to manage plugins or something
" execute pathogen#infect()
" " generate help files
" Helptags
" " basically, let vim load plugins for filetypes.
" This is pretty essential to any vim user's quality of life
filetype plugin indent on
" tell vim-commentary what comments to use in tex files
augroup TexComments
    autocmd! FileType tex setlocal commentstring=%\ %s
augroup END
" tell vimtex i'm not a total nutjob
let g:tex_flavor = 'latex'

" TODO
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-b>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"

" Keep 5 lines and 10 cols of context on the screen
set scrolloff=5
set sidescroll=1
set sidescrolloff=10

" Avoid side effects if `nocp` already set. THIS IS CRUCIALLY IMPORTANT
" Basically everything breaks if you don't do this
if &compatible
    set nocompatible
endif
" Let backspaces in insert mode delete lines, I think
set backspace=indent,eol,start
" remember 10000 lines of command-line history
set history=10000
" display current cursor position
set ruler
" display long normal-mode commands as they're typed
set showcmd
" show matches for a search live as you type them
set incsearch
" let visual block mode go off the end
set virtualedit=block

" delay for mappings
set timeoutlen=1000
" make <Esc> work without delay.
set ttimeoutlen=10

" colour-related options, wrapped in some conditions just to be on the safe side
if &t_Co > 2 || has("gui_running")
    syntax enable
    set hlsearch
    noh
    set background=dark
    if &term != "linux"
        let g:solarized_termtrans = 1
        " colorscheme solarized
    endif
    " makes it so I can see what I'm highlighting
    highlight Visual cterm=reverse ctermbg=NONE
endif

" maybe this fixed something once, a long time ago
if has('langmap') && exists('+langnoremap')
    set langnoremap
endif
" Makes % more sophisticated
" packadd matchit

" line numbers, that are relative to current line
" allegedly lets you judge repetitions of movement commands, and it looks cool
set number
set relativenumber
" whitespace
" tab = 4 spaces
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=-1
set shiftround
set nojoinspaces
set formatoptions+=j
set expandtab

" when incrementing & decrementing with ^A, ^X
set nrformats=bin,hex,alpha

" name and shame any actual tabs
set list
set listchars=tab:>-

" similarly name and shame trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" text width is 80 and mark it out
set textwidth=80
set colorcolumn=+1

set showbreak=+++\ 

" ignore case in search
set ignorecase
" completion becomes case insensitive if it can't find anything sensitive
set infercase
" backspace key fix?
set t_kb=
" set good encryption
" set cryptmethod=blowfish2

" This is when vim does stuff with :find or something
set path=.,**
set wildmenu
set wildignorecase
set complete=.,w,b,u,t,i

" preserves undo history for buffers by not properly closing things
set hidden

" Persistent undo history
set undofile
" set undodir=$HOME/.vim/undo

" save 10000 levels of undo
set undolevels=10000
" cache entire buffers under 10000 lines
set undoreload=10000

" auto-generate ctags when writing certain files
if executable("ctags")
    function MakeTags()
        " basically only try this when I'm inside my home directory a little
        " way.
        if getcwd() =~ "^" . $HOME . "/"
            redraw | echo "RUNNING CTAGS"
            silent !ctags -R -o newtags; mv -f newtags tags &
            redraw | echo "RAN CTAGS"
        endif
    endfunction
    augroup CTagsAutoWrite
        autocmd! BufWritePost *.py,*.c,*.cpp,*.h,*.tex call MakeTags()
    augroup END
    " tag binary search
    set tagbsearch
endif

" Write backup files. Disk is cheap and uou never know
set backup
set writebackup
" set backupdir=~/.vim/backups

" Preserve vim state:
" '100: store marks for 100 previously edited files
" /100: store 100 previous searches
" :100: store 100 previous commands issued
" <1000000: store at most 1000000 lines of each buffer
" @1000: store 1000 lineso f input-line history
" s1000: allow items to be 10000 Kbyte in size
" set viminfo=%,'100,/100,:100,<1000000,s10000,@1000,h,n~/.vim/viminfo

" Keep swap files out of the way
" set directory^=~/.vim/swap

" Set up a thesaurus and dictionary
" set thesaurus=~/.vim/thesaurus/thesaurus_pkg/thesaurus.txt
set spelllang=en_gb,nl spellcapcheck=
" Make files be "text" by default
augroup TextFileType
    autocmd! BufEnter * if &filetype == "" | setlocal ft=text | endif
augroup END
" Enable spelling for these filetypes
augroup SpellingFiles
    autocmd! FileType latex,tex,text,markdown set spell
augroup END

" Personal mappings and definitions. Some inspiration from
" " https://github.com/anowlcalledjosh/dotfiles/blob/master/.vimrc
" and
" https://github.com/tpope/vim-sensible

" Allow saving of files as sudo when I forgot to start vim using sudo.
" It tees the buffer into its name, silently, redirecting stdout to /dev/null,
" and then reloads the file.
" It's a function because I don't know how to do an e after a ! in a command
function W()
    silent w !sudo tee > /dev/null %
    e
endfunction
command W call W()

" Shortcut to turn highlighting back off, but it also still does a normal
" carriage return.
nnoremap <silent> <CR> :noh<CR><CR>
" Alternative that only turns highlighting off
nnoremap <silent> g<CR> :noh<CR>

" Repeated indentation in visual mode
xnoremap > >gv
xnoremap < <gv

" a bit of tough love
imap <Left> <Nop>
imap <Right> <Nop>
imap <Up> <Nop>
imap <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" This seems more sensible than having W be the exact same as w, to me.
noremap W b
noremap E ge

" make ctrl-c "abort" current insertion. It's consistent with the
" characterisation of ctrl-c in unix lore, and sometimes you're just angry at
" what you've written, y'know
inoremap <C-c> <Esc>u

" mapping to insert a single character, from
" https://vim.fandom.com/wiki/Insert_a_single_character
" It doesn't repeat properly with ".", however.
nnoremap <Space> i_<Esc>r

" Am I crazy?? this makes much more sense. n_G is used to go to line, n_gg is
" used to go to character, G is EOF, gg is SOF, and g[oO] are these mad useful
" bindings
noremap go o<Esc>
noremap gO O<Esc>
noremap gg go<Esc>

" remap these to go between buffers. Not like there are any keys to substitute
" their normal behaviour
map <C-p> :bp<CR>
map <C-n> :bn<CR>

" remap these to go between splits
" <C-[hjk]> were useless anyway, and we store <C-l> in g<C-l>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap g<C-l> <C-l>

" swap the eefault behaviour of g[jk] and [jk]. This means that j and k traverse
" the screen, rather than the file (particularly, going up or down on a wrapped
" line keeps you inside the line)
" I also remove them for operator-pending mode, so that eg dj and gk still work
" properly.
noremap k gk
noremap j gj
ounmap k
ounmap j
noremap gk k
noremap gj j

" select previously inserted text
map gV `[v`]

map ]q :cn<CR>
map [q :cp<CR>

" Make Q repeat the `qq` macro, rather than enter ex mode.
noremap Q @q
" Instead use gQ for ex-mode, discarding the weird fake ex-mode
noremap gQ Q

map <Leader>wq :w<CR>:bd<CR>
map <Leader>q :bd<CR>

" reload/edit configuration files
command Vrc source $MYVIMRC
command Evr e $MYVIMRC
command Ezr e ~/.zshrc
command Exr e ~/.Xresources
command Ear e ~/.goedel_aliases
command E3r e ~/.config/i3/config
command Efr e ~/fun
command Etr e ~/Documents/TODO
command Eur e ~/.tmux.conf
map <Leader>vv :Evr<CR>
map <Leader>vz :Ezr<CR>
map <Leader>vx :Exr<CR>
map <Leader>va :Ear<CR>
map <Leader>v3 :E3r<CR>
map <Leader>vf :Efr<CR>
map <Leader>vt :Etr<CR>
map <Leader>vu :Eur<CR>
" reload vimrc when written
augroup ConfigReloadVim
    " the nested makes things not break - see autocmd-nested
    autocmd! BufWritePost $MYVIMRC nested source $MYVIMRC | redraw |
        \ echo "reloaded vimrc"
augroup END
augroup ConfigReloadTmux
    autocmd! BufWritePost ~/.tmux.conf !tmux source-file ~/.tmux.conf
augroup END

" command to redirect another command into a new buffer
" https://vi.stackexchange.com/questions/8378/dump-the-output-of-internal-vim-command-into-buffer
command! -nargs=+ -complete=command Redir let s:reg = @@ | redir @"> |
    \ silent execute <q-args> | redir END | new | pu | 1,2d_ | let @@ = s:reg
