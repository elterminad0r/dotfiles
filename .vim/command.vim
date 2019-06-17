"                                                      .___
"   ____   ____    _____    _____  _____     ____    __| _/_______   ____
" _/ ___\ /  _ \  /     \  /     \ \__  \   /    \  / __ | \_  __ \_/ ___\
" \  \___(  <_> )|  Y Y  \|  Y Y  \ / __ \_|   |  \/ /_/ |  |  | \/\  \___
"  \___  >\____/ |__|_|  /|__|_|  /(____  /|___|  /\____ |  |__|    \___  >
"      \/              \/       \/      \/      \/      \/              \/
" FIGMENTIZE: commandrc

" File to store custom vim commands

" Run the file through figmentize
function! Figmentize()
    if executable("figmentize")
        if &modified
            echoerr "This buffer is modified"
        elseif &readonly
            echoerr "This buffer is readonly"
        else
            silent !figmentize %
            edit
            redraw!
        endif
    else
        echoerr "Figmentize executable not found"
    endif
endfunction

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
" TODO: some kind of centralised idea
command! Vrc call ReloadVimConf()
command! Evr argadd  ~/.vim/{vimrc,*.vim,gvimrc} | n
" TODO: use $ZDOTDIR and $bASHDOTDIR
command! Ezr argadd ~/.zsh/{zshrc,*.zsh,*.sh,zshenv,zprofile,prompts/*} ~/.bash/* ~/.profile | n
" TODO: this is a workaround to get just files
command! Exr argadd ~/.Xresources ~/.X/**/*.* ~/.xinitrc ~/.xprofile | n
command! E3r argadd ~/.config/i3/config | n
command! Efr argadd ~/fun | n
command! Etr argadd ~/Documents/TODO | n
command! Eur argadd ~/.tmux.conf | n

" command to insert output of ex command into buffer
" VIMSCRIPT IS SO COOL
command! -nargs=+ -complete=command Rcom call append(line("."), split(execute(<q-args>), "\n"))

command! MakeScratch setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted

" command to redirect another command into a new buffer
" Opens in a scratch buffer so you can close it without being harassed
command! -nargs=+ -complete=command Redir new
            \ | call append(line("."), split(execute(<q-args>), "\n"))
            \ | MakeScratch
