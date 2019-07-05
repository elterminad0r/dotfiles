" TeX filetype specific configuration

" recognise \item as a list item marker
setlocal formatlistpat+=\\\|^\\s*\\\\item\\%(\\[[^\\]]*\\]\\)\\?\\s*
" for vim-commentary's benefit
setlocal commentstring=%\ %s
