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
source_if_exists() {
    if [[ -f "$1" ]]; then
        source "$1"
    else
        echo "Izaak's bashrc: could not source $1" >&2
    fi
}

source_if_exists $HOME/.profile

# add $1 to path if it isn't already in path.
add_to_path() {
    local add_dir="$(realpath $1)"
    case $PATH in
        *$add_dir:*)
            ;;
        *)
            export PATH=$add_dir:$PATH
            ;;
    esac
}

add_to_path ~/bin
add_to_path ~/.gem/ruby/2.6.0/bin
add_to_path ~/.local/bin

# all my shell-y aliases
source_if_exists $HOME/.izaak_aliases

# List Xecutables - print all possible things that could act like a command -
# that is, Aliases, Builtins, Commands, Keywords
alias lx="compgen -A function -abck | grep -v '^_'"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

# tell the readline library to show a vi mode indicator.
# this could go in inputrc, but I have my reasons that make it more
# straightforward to just do it here, for Bash.
# also, doing it here allows for command substitutions, which means I can use
# tput /o/
bind "set show-mode-in-prompt on"
# TODO: is there way to make this work nicely with search mode?
# also TODO: can I put colours in here without breaking my prompt? who knows. it
# doesn't seem to understand \[ and \]. Ideally I would have it act the way my
# "pzsh" prompt looks, but I don't think it will be feasibly. Therefore, I have
# it go between a character and no character for maximum visibility
bind "set vi-ins-mode-string \"< >\""
bind "set vi-cmd-mode-string \"<N>\""
# this would colour in the matching part of what you're completing on
# bind "set colored-completion-prefix"

# use good bash completion
source_if_exists /usr/share/bash-completion/bash_completion

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

source_if_exists /usr/share/git/completion/git-completion.bash

# this is where it is on my system. Find a copy at
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source_if_exists /usr/share/git/git-prompt.sh

# show if there are staged/unstaged changes
GIT_PS1_SHOWDIRTYSTATE=true
# pretty colours
GIT_PS1_SHOWCOLORHINTS=true
# show if there are untracked files
GIT_PS1_SHOWUNTRACKEDFILES=true
# show if you have stashed changes
GIT_PS1_SHOWSTASHSTATE=true
# show relationship with upstream repository
GIT_PS1_SHOWUPSTREAM=auto

# function which returns a code to make text green if exit status was
# successful, and red otherwise
exitstatus_prompt() {
    if [[ $? == 0 ]]; then
        tput setaf 2
    else
        tput setaf 1
    fi
}

# function which returns red if the user has root privileges, and pink otherwise
user_prompt() {
    if [[ $EUID -ne 0 ]]; then
        tput setaf 5
    else
        tput setaf 1
    fi
}

# function to build a pretty looking prompt, inspired by Stijn van Dongen's
# taste in prompts, but with more colours.
izaak_prompt() {
    # sub-components of the prompt, mostly using tput to generate ANSI escape
    # sequences. This is really just to avoid the prompt becoming a ghastly 500
    # byte one-liner
    # always wrap nonprinting characters in \[ and \] in bash prompts, so that
    # bash knows how to draw the prompt properly when redrawing (eg if cycling
    # through history or tab completing)
    local iz_exit="\[$(exitstatus_prompt)\]"
    local iz_bold="\[$(tput bold)\]"
    local iz_user="\[$(user_prompt)\]"
    local iz_yellow="\[$(tput setaf 3)\]"
    local iz_cyan="\[$(tput setaf 6)\]"
    local iz_reset="\[$(tput sgr0)\]"
    # a little logic to make directory behave correctly in / and /*/, and also
    # handle home directory with a little extra logic
    local iz_dir_base="$(basename "$PWD")"
    local iz_dir_dir="$(basename "$(dirname "$PWD")")"
    if [[ "$PWD" = "$HOME" ]]; then
        local iz_dir="~"
    elif [[ "$(dirname "$PWD")" = "$HOME" ]]; then
        local iz_dir="~/$iz_dir_base"
    elif [[ "$iz_dir_base" = "/" ]]; then
        local iz_dir="/"
    elif [[ "$iz_dir_dir" = "/" ]]; then
        local iz_dir="/$iz_dir_base"
    else
        local iz_dir="$iz_dir_dir/$iz_dir_base"
    fi
    # This last part uses __git_ps1 to inject some information about dirty
    # states and branches when in a git repository. This can be made much
    # prettier using just vanilla zsh, with the vcs_info autoload function.
    __git_ps1 "$iz_bold$iz_user\u$iz_exit@$iz_yellow\h$iz_exit|$iz_cyan$iz_dir$iz_reset" " "
}

# sets prompt command. the two arguments are the string to appear before the git
# status, and the string to appear after it, using normal Bash prompt syntax.
# also make some pretty colours with tput.
PROMPT_COMMAND='resize &>/dev/null; izaak_prompt'

# shopts. Some of these are already set by default but I like to keep everything
# explicit and in one place.

# if a command is not recognised, try to treat it as a directory to cd to
shopt -s autocd
# zsh-like: prevent exit if there are any attached jobs
shopt -s checkjobs
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
# allow the ** glob, indicating "any subdirectory", recursively. THIS IS USEFUL.
# eg: $ ldir programmeren/**; will do a listing of everything.
shopt -s globstar
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

# source $HOME/.bourne_apparix
