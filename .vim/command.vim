"                                                      .___
"   ____   ____    _____    _____  _____     ____    __| _/_______   ____
" _/ ___\ /  _ \  /     \  /     \ \__  \   /    \  / __ | \_  __ \_/ ___\
" \  \___(  <_> )|  Y Y  \|  Y Y  \ / __ \_|   |  \/ /_/ |  |  | \/\  \___
"  \___  >\____/ |__|_|  /|__|_|  /(____  /|___|  /\____ |  |__|    \___  >
"      \/              \/       \/      \/      \/      \/              \/
" FIGMENTIZE: commandrc

" File to store custom vim commands

" Run the file through figmentize
if executable("figmentize")
    function! Figmentize()
        if &modified
            echoerr "This buffer is modified"
        elseif &readonly
            echoerr "This buffer is readonly"
        else
            silent !figmentize %
            edit
            redraw!
        endif
    endfunction
else
    function! Figmentize()
        echoerr "Figmentize executable not found"
    endfunction
endif

command! Figmentize call Figmentize()

" Insert some text using figlet, adding some prefix
" this function is no longer used in production - instead refer to the
" figmentize script in ~/bin.
" This function for example cannot pass arguments to figlet.
if executable("figlet")
    function! Fig(word, prefix)
        let l:fig_output = map(systemlist("figlet " . a:word)[:-2],
                    \ "a:prefix . ' ' . substitute(v:val, ' *$', '', '')")
        call append(line("."), l:fig_output)
    endfunction
else
    function! Fig(...)
        echoerr("Figlet executable not found")
    endfunction
endif
command! -nargs=+ Fig call Fig(<f-args>)

" Allow saving of files as sudo when I forgot to start vim using sudo.
" It tees the buffer into its name, silently, redirecting stdout to /dev/null,
" and then reloads the file.
" It's a function because I don't know how to do an e after a ! in a command
" It seems like vim-eunuch/SudoWrite does the same thing, but this seems
" portable enough for me
function! W()
    silent w !sudo tee > /dev/null %
    " reload file only if it was written successfully
    if v:shell_error == 0
        edit!
    else
        echohl ErrorMsg
        redraw | echomsg "Could not write file as root"
        echohl None
    endif
endfunction
command! W call W()

" reload/edit configuration files
command! Vrc call ReloadVimConf()
command! Evr e $MYVIMRC " ~/.vim/*rc FIXME - to edit all vimrc files
command! Egr e $MYGVIMRC
command! Ezr e ~/.zshrc
command! Exr e ~/.Xresources
command! Ear e ~/.goedel_aliases
command! E3r e ~/.config/i3/config
command! Efr e ~/fun
command! Etr e ~/Documents/TODO
command! Eur e ~/.tmux.conf

" command to insert output of ex command into buffer
" VIMSCRIPT IS SO COOL
command! -nargs=+ -complete=command Rcom call append(line("."), split(execute(<q-args>), "\n"))

command! MakeScratch setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted

" command to redirect another command into a new buffer
" Opens in a scratch buffer so you can close it without being harassed
command! -nargs=+ -complete=command Redir new |
            \ | call append(line("."), split(execute(<q-args>), "\n"))
            \ | MakeScratch
