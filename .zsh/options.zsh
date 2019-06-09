#                  __   .__
#   ____  ______ _/  |_ |__|  ____    ____    ______
#  /  _ \ \____ \\   __\|  | /  _ \  /    \  /  ___/
# (  <_> )|  |_> >|  |  |  |(  <_> )|   |  \ \___ \
#  \____/ |   __/ |__|  |__| \____/ |___|  //____  >
#         |__|                           \/      \/
# FIGMENTIZE: options

# My zsh setopts. A number of these are redundant as they are set by default,
# but centralisation and explicitification

# Apparently vim is *really* bad at highlighting zsh setopts.

# complete with a menu
setopt menucomplete
# complete globs
setopt globcomplete
# allow completion from inside word
setopt complete_in_word
# jump to end of word when completing
setopt always_to_end
# ensure the path is hashed before completing
setopt hash_list_all
# use different sized columns in completion menu to cut down on space
setopt list_packed

# case insensitive glob
unsetopt case_glob
# zsh regex is case insensitive
unsetopt case_match
# use extended globs
setopt extendedglob
# allow ksh-like qualifiers before parenthetical glob groups
setopt ksh_glob
# allow patterns like programmeren/**.py (recursive without symlinks) and
# programmeren/***.py (recursive with symlinks), as shorthand for **/* and ***/*
setopt glob_star_short
# error if glob does not match
setopt nomatch

# no ^S and ^Q killjoys. This is also done by stty -ixon in ~/.profile, but ah
# well
unsetopt flowcontrol
# do not allow > redirection to clobber files. Must use >! or >|
unsetopt clobber
# allow comments in interactive shell
setopt interactive_comments

# disowned jobs are automatically continued
setopt auto_continue
# check background jobs before exiting
setopt check_jobs

# keeping track of a directory stack.
# Killer feature!
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt auto_cd
# ignore duplicate directories, be silent, treat no argument as HOME
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home

# use basically unlimited history
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

# record timestamp of command in HISTFILE
setopt extended_history
# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_expire_dups_first
# ignore duplicated commands history list
setopt hist_ignore_dups
# ignore commands that start with space
setopt hist_ignore_space
# show command with history expansion to user before running it
setopt hist_verify
# add commands to HISTFILE in order of execution. inc adds them directly at
# execution rather than when the shell exits.
setopt inc_append_history
# share command history data
setopt share_history
# expand ! csh style
unsetopt bang_hist
# remove superfluous whites
setopt hist_reduce_blanks
# don't immediately execute commands with history expansion
setopt hist_verify
