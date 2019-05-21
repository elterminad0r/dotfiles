# FIGMENTIZE: zshrc
#                 .__
# ________  ______|  |__ _______   ____
# \___   / /  ___/|  |  \\_  __ \_/ ___\
#  /    /  \___ \ |   Y  \|  | \/\  \___
# /_____ \/____  >|___|  /|__|    \___  >
#       \/     \/      \/             \/

# Zshrc by Izaak van Dongen/oh-my-zsh/probably some other people
# I no longer use oh-my-zsh as I found it a little too restrictive regarding
# setting some options and variables (HISTSIZE in particular), and also it
# seemed to persistently mess up my locale environment variables like LC_ALL

# define this function so that I can source things with impunity, but my zshrc
# won't break as hard if taken out of context.
source_if_exists() {
    if [[ -f "$1" ]]; then
        source "$1"
    else
        echo "Izaak's zshrc: could not source $1" >&2
    fi
}

source_if_exists "$HOME/.ttyrc"

if [[ "$IZAAK_IS_TTY" != "true" ]]; then
    if [[ -f $HOME/.dir_colors_solarized ]]; then
        if silent command -v dircolors; then
            eval "$(dircolors $HOME/.dir_colors_solarized)"
        else
            echo "dircolors executable not found" 2>&1
        fi
    else
        echo "dircolors file not found" >&2
    fi
else
    echo "no solarized as tty" >&2
fi

source_if_exists "$HOME/.tmuxopenrc"

# transparency in xterm
[[ -n "$XTERM_VERSION" ]] && transset-df --id "$WINDOWID" 0.95 >/dev/null

# provides things like the $fg_bold array
autoload -Uz colors && colors

# killer feature!
# make rprompt go away when I move on. This hugely reduces clutter when you
# resize the screen a lot, as the active rprompt gets redrawn, and means you can
# easily copy/paste etc etc
setopt transient_rprompt

POWERLEVEL_THEME=~/.zplugins/powerlevel10k/powerlevel10k.zsh-theme

if [[ -z "$IZAAK_IS_TTY" && -z "$IZAAK_NO_POWERLINE" && -f "$POWERLEVEL_THEME" ]]; then
    # customisation options for powerline. The implementation I use is powerlevel10k
    # as it's a lot faster.
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode context root_indicator dir_writable dir vcs)
    # BLOAT IS NOT WELCOMe HERE
    # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history time battery)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history)
    POWERLEVEL9K_BATTERY_LOW_FOREGROUND='black'
    POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='black'
    POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='black'
    POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='black'
    POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND=(red3 darkorange3 darkgoldenrod gold3 yellow3 chartreuse2 mediumspringgreen green3 green3 green4 darkgreen)
    POWERLEVEL9K_BATTERY_STAGES="▁▂▃▄▅▆▇█"
    # show current vi mode in prompt
    POWERLEVEL9K_VI_INSERT_MODE_STRING='I'
    POWERLEVEL9K_VI_COMMAND_MODE_STRING='N'
    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
    POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    source $POWERLEVEL_THEME
else
    # alternative prompt without any plugins or fancy fonts. Basically emulates
    # the important bits of my powerline prompt
    autoload -Uz vcs_info
    precmd_vcs_info() { vcs_info }
    precmd_functions+=( precmd_vcs_info )
    setopt prompt_subst
    # RPROMPT=\$vcs_info_msg_0_
    # PROMPT=\$vcs_info_msg_0_'%# '
    # basically ripped from man zshcontrib
    # yet to customize more
    # need to use %%b for bold off
    zstyle ':vcs_info:*' actionformats \
        ' %B%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%u%c%f%%b'
    zstyle ':vcs_info:*' formats       \
        ' %B%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%u%c%f%%b'
    zstyle ':vcs_info:*' stagedstr "*"
    zstyle ':vcs_info:*' unstagedstr "+"
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
    # don't waste time on VCS that nobody uses
    zstyle ':vcs_info:*' enable git cvs svn hg
    zstyle ':vcs_info:*' check-for-changes true

    # precmd() { VIM_PROMPT="%F{blue}(I)%f" }
    # precmd() { VIM_PROMPT="" }
    function zle-line-init zle-keymap-select {
        case "$KEYMAP" in
            main)
                VIM_PROMPT="%F{blue}(I)%f"
                ;;
            vicmd)
                VIM_PROMPT="%F{white}(N)%f"
                ;;
            *)
                VIM_PROMPT="%F{white}($KEYMAP)%f"
                ;;
        esac
        #VIM_PROMPT="$KEYMAP"
        # RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select
    ret_status="%(?:%F{green}:%F{red})"
    RPROMPT="%B%(?.%F{green}OK .%F{red}%? )%(2L.%F{yellow}%L .)%F{white}%h%f%b"
    # two-line prompt, with a blank line behind it.
    PROMPT=$'\n'"%B\$VIM_PROMPT%(!.%F{red}.%F{magenta})%n$ret_status%#%F{yellow}%m$ret_status|%f%F{cyan}%~%b%F{blue}\$vcs_info_msg_0_%f%b"$'\n%B%F{white}->%f%b '
fi

autoload -Uz compinit
# leftover from oh-my-zsh
if [[ $ZSH_DISABLE_COMPFIX == "true" ]]; then
    compinit -u
else
    compinit
fi

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# use basically unlimited history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

# setopts. A number of these are redundant as they are set by default, but
# centralisation and explicitification

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
setopt bang_hist
# remove superfluous whites
setopt hist_reduce_blanks
# don't immediately execute commands with history expansion
setopt hist_verify

# vim mode bindings
bindkey -v
bindkey  "" backward-delete-char
bindkey  "" backward-delete-char
# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

autoload -Uz edit-command-line
zle -N edit-command-line

# V for Vim. This key regrettably does not go into visual block mode in ZLE, so
# a fortunate side effect is that an advanced user looking for this
# functionality gets automatically propelled into zsh.
bindkey -M vicmd '^V' edit-command-line

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
expand-or-complete-with-dots() {
    # toggle line-wrapping off and back on again
    [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
    print -Pn "%{%F{red}......%f%}"
    [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# use fzf for completion
# source_if_exists /usr/share/fzf/key-bindings.zsh
# source_if_exists /usr/share/fzf/completion.zsh

# no thanks
# source_if_exists $ZSH/oh-my-zsh.sh

# this is handled by zsh_env
# source_if_exists "$HOME/.izaak_aliases"
# source_if_exists "$HOME/.bourne_apparix"

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-suffixes true
# zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/home/izaak/.zshrc'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias d='dirs -v | head -10'

# zsh syntax highlighting
source_if_exists /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
