# FIGMENTIZE: bashrc
# ___.                    .__
# \_ |__  _____     ______|  |__ _______   ____
#  | __ \ \__  \   /  ___/|  |  \\_  __ \_/ ___\
#  | \_\ \ / __ \_ \___ \ |   Y  \|  | \/\  \___
#  |___  /(____  //____  >|___|  /|__|    \___  >
#      \/      \/      \/      \/             \/

# Bashrc. I don't actively use bash, so it's not been very well tested, but it's
# got a couple of the features I consider critical to make bash usable.

# It doesn't make much of an attempt to be compatible with anything. It uses
# cutting edge readline features with gay abandon, so you'll probably need at
# least bash 4.something, idk ask someone who uses bash.

# define this function so that I can source things with impunity, but my bashrc
# won't break as hard if taken out of context.
# it goes through all of its arguments, stopping as soon as it can source any
# one of them.
# I only use this a handful of times so that I can source backup versions of
# files I have duplicated in my dotfiles that are also located on my system.
source_if_exists() {
    for sfile in "$@"; do
        if [[ -f "$sfile" ]]; then
            source "$sfile"
            return 0
        fi;
    done
    echo "Izaak's bashrc: could not source any of $*" >&2
}

# assert that bash version is at least $1 $2 $3
version_assert() {
    for i in {1..3}; do
        if ((BASH_VERSINFO[$(($i - 1))] > ${!i})); then
            return 0
        elif ((BASH_VERSINFO[$(($i - 1))] < ${!i})); then
            echo "Your bash is older than $1.$2.$3"
            return 1
        fi
    done
    return 0
}

source_if_exists "$HOME/.profile"

# all my shell-y aliases
source_if_exists "$HOME/.izaak_aliases"

# this relies on too much zsh stuff for now. I've extracted the important bits
# source_if_exists "$HOME/.ttyrc"
case $(tty) in
    /dev/tty[0-9]*)
        IZAAK_IS_TTY=true
        ;;
    *)
        IZAAK_IS_TTY=false
        ;;
esac

source_if_exists "$HOME/.dircolorsrc"

source_if_exists "$HOME/.tmuxopenrc"

# List Xecutables - print all possible things that could act like a command -
# that is, Aliases, Builtins, Commands, Keywords
alias lx="compgen -A function -abck | grep -v '^_'"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

# use good bash completion.
# The script I have bundled probably required a new-ish bash.
if version_assert 4 1 0; then
    source_if_exists /usr/share/bash-completion/bash_completion "$HOME/.bash_scripts/bash_completion"
else
    echo "Not sourcing bash completion"
fi

# tab completion and some directory thing for readline
bind '"\t":menu-complete'
bind 'set mark-directories on'

# there are also several other readline related options in ~/.inputrc.

# to stop bash being confused by zsh
export HISTFILE="$HOME/.bash_history"
# do not limit history
export HISTSIZE=-1
export HISTFILESIZE=-1
# configuration for how history is saved:
# lines starting with a space are not saved
# a line that is the same as the previous one is not saved
# when a line is added, all previous matches to that line are removed
export HISTCONTROL=ignorespace:ignoredups:erasedups

# tab completion for git
# The one I have bundled probably required a new-ish bash
if version_assert 3 2 57; then
    source_if_exists /usr/share/git/completion/git-completion.bash "$HOME/.bash_scripts/git-completion.bash"
else
    echo "Not sourcing git completion" 2>&1
fi

source_if_exists "$HOME/.bashpromptrc"

# shopts. Some of these are already set by default but I like to keep everything
# explicit and in one place.

# fail if any component of a piped command fails
set -o pipefail

if version_assert 4 0 0; then
    # if a command is not recognised, try to treat it as a directory to cd to
    shopt -s autocd
    # zsh-like: prevent exit if there are any attached jobs
    shopt -s checkjobs
    # allow the ** glob, indicating "any subdirectory", recursively. THIS IS USEFUL.
    # eg: $ ldir programmeren/**; will do a listing of everything.
    shopt -s globstar
else
    echo "Not setting autocd, checkjobs, globstar :(" 2>&1
fi
# update LINES and COLUMNS
shopt -s checkwinsize
# save big commands in one go in history file, and preserve newlines where
# possible
shopt -s cmdhist
shopt -s lithist
# extended globbing. idk what it does but it sounds good.
shopt -s extglob
# $'' and $"" expansions in ${}
shopt -s extquote
# empty globs cause errors
shopt -s failglob
# don't overwrite history, but append instead
shopt -s histappend
# # comments work in interactive mode
shopt -s interactive_comments
# do not complete empty lines for every possible executable
shopt -s no_empty_cmd_completion
# case insensitive globs and case statements
shopt -s nocaseglob
shopt -s nocasematch
# completion on aliases? it doesn't seem to work. TODO
# shopt -s progcomp
# shopt -s progcomp_alias
# the prompt string undergoes variable expansion/command substitution/etc
shopt -s promptvars

# source "$HOME/.bourne_apparix"
source_if_exists "$HOME/.bourne-apparish"
