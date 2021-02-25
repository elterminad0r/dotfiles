#                                 .__            __   .__
#   ____   ____    _____  ______  |  |    ____ _/  |_ |__|  ____    ____
# _/ ___\ /  _ \  /     \ \____ \ |  |  _/ __ \\   __\|  | /  _ \  /    \
# \  \___(  <_> )|  Y Y  \|  |_> >|  |__\  ___/ |  |  |  |(  <_> )|   |  \
#  \___  >\____/ |__|_|  /|   __/ |____/ \___  >|__|  |__| \____/ |___|  /
#      \/              \/ |__|               \/                        \/
# FIGMENTIZE: completion

autoload -Uz compinit
# leftover from oh-my-zsh
# Sometimes I manually disable security checks, for example to run a zsh as
# root.
if [ "$ZSH_DISABLE_COMPFIX" = "true" ]; then
    compinit -u
else
    compinit
fi

# set up completions for kitty. Bit of a dubious way to package completion code,
# but hey. Also for some incomprehensible reason they seem to have custom
# completion code for files

if >/dev/null 2>&1 command -v kitty; then
    source <(kitty +complete setup zsh)
else
    >&2 echo "zshrc: you should probably install kitty or get rid of this bit"
fi

# define completion for the xcat function
compdef _command_names xcat

# make g complete like git
# https://stackoverflow.com/questions/4221239/zsh-use-completions-for-command-x-when-i-type-command-y
compdef '_dispatch git git' g

# completion insensitive to case and hyphen/underscores
# https://stackoverflow.com/questions/24226685/have-zsh-return-case-insensitive-auto-complete-matches-but-prefer-exact-matches
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'

zstyle ':completion:*' special-dirs true

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
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# don't complete on latex garbage files
zstyle ':completion:*:*:*:files' ignored-patterns \
        "*.aux" "*.lof" "*.log" "*.lot" "*.fls" "*.out" "*.toc" \
        "*.fdb_latexmk" "*.synctex.gz" "*.idx" "*.ilg" "*.ind"

zstyle '*' single-ignored show

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous false
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
    zstyle ':completion:*' list-colors ''
fi
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename "$ZDOTDIR/zshrc"

# Display red dots whilst waiting for completion.
function expand-or-complete-with-dots() {
    print -Pn "%{%F{red}......%f%}"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey -M main "^I" expand-or-complete-with-dots
# Shift-tab to complete backwards
# You should also be able to use ^N and ^P
bindkey -M main '^[[Z' reverse-menu-complete

# auto-expand aliases. Not sure I'm a huge fan
# function expand-alias() {
#     zle _expand_alias
#     zle self-insert
# }
# zle -N expand-alias
# bindkey -M main ' ' expand-alias
