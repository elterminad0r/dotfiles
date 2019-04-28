#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

alias lx="compgen -A function -abck"

bind '"\t":menu-complete'
bind 'set mark-directories on'

source /usr/share/git/completion/git-completion.bash

# this is where it is on my system. Find a copy at
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source /usr/share/git/git-prompt.sh

# show if there are staged/unstaged changes
GIT_PS1_SHOWDIRTYSTATE=true
# pretty colours
GIT_PS1_SHOWCOLORHINTS=true
# show if there are untracked files
GIT_PS1_SHOWUNTRACKEDFILES=true

exitstatus_prompt() {
    if [[ $? == 0 ]]; then
        tput setaf 2
    else
        tput setaf 1
    fi
}

user_prompt() {
    if [[ $EUID -ne 0 ]]; then
        tput setaf 5
    else
        tput setaf 1
    fi
}

# sets prompt command. the two arguments are the string to appear before the git
# status, and the string to appear after it, using normal Bash prompt syntax.
# also make some pretty colours with tput.
PROMPT_COMMAND='__git_ps1 "$(tput bold)\$(user_prompt)\u\$(exitstatus_prompt)@$(tput setaf 3)\h\$(exitstatus_prompt)|$(tput setaf 4)$(basename "$(dirname "$PWD")")/$(basename "$PWD")$(tput sgr0)" " "'

source $HOME/.izaak_aliases

source $HOME/.bourne_apparix
