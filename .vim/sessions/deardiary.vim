" Vim session file to set up diary editing, and also protect myself from my
" muscle memory to not mess up established tabs and windows

if filereadable(expand('~/.vim/sessions/diary_session.vim'))
    source ~/.vim/sessions/diary_session.vim
else
    echom 'Starting new diary session'
endif

nunmap <C-q>
cabbrev q qa
cabbrev wq wqa

augroup DiarySaveSession
    autocmd! VimLeavePre * mksession! ~/.vim/sessions/diary_session.vim
augroup END
