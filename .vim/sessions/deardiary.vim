" Vim session file to set up diary editing, and also protect myself from my
" muscle memory to not mess up established tabs and windows

source ~/.vim/sessions/diary_session.vim

nunmap <C-q>
cabbrev q qa
cabbrev wq wqa

augroup DiarySaveSession
    autocmd! VimLeavePre * mksession! ~/.vim/sessions/diary_session.vim
augroup END