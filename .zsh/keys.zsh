#  __
# |  | __  ____  ___.__.  ______
# |  |/ /_/ __ \<   |  | /  ___/
# |    < \  ___/ \___  | \___ \
# |__|_ \ \___  >/ ____|/____  >
#      \/     \/ \/          \/
# FIGMENTIZE: keys

# vim mode bindings
bindkey -v
# alias these widgets so that zsh doesn't do the weird thing where it "protects"
# previously inserted text
# https://unix.stackexchange.com/questions/140770/how-can-i-get-back-into-normal-edit-mode-after-pressing-esc-in-zsh-vi-mode
# TODO WHY DOESN'T THIS WORK
# zle -A backward-kill-line vi-kill-line
# zle -A backward-kill-word vi-backward-kill-word
# zle -A backward-delete-char vi-backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
bindkey "^U" backward-kill-line
bindkey "^W" backward-kill-word

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

bindkey '^E' _expand_alias
bindkey -M vicmd "K" run-help

# load a widget for command-line editing in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
# V for Vim. This key regrettably does not go into visual block mode in ZLE, so
# a fortunate side effect is that an advanced user looking for this
# functionality gets automatically propelled into vim.
bindkey -M vicmd '^V' edit-command-line

# anonymous function in order to temporarily set null_glob
() {
    emulate -L zsh
    setopt null_glob
    FZF_BINDINGS=( /usr/share/fzf/key-bindings.zsh
                   /usr/local/Cellar/fzf/*/shell/key-bindings.zsh )
}

# use fzf for completion
# TODO: make this less intrusive
if source_if_exists $FZF_BINDINGS; then
    source_if_exists "$HOME/.themes/base16-fzf/bash/base16-gruvbox-dark-medium.config"
else
    >&2 echo "defining history-incremental-pattern-search-backward instead"
    bindkey '^R' history-incremental-pattern-search-backward
fi
# TODO: does this do anything?
# source_if_exists /usr/share/fzf/completion.zsh
