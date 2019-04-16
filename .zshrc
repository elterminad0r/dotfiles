if [[ $DISPLAY ]]; then
    # If not running interactively, do not do anything
    [[ $- != *i* ]] && return
    [[ -z "$TMUX" ]] && exec tmux
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
if [[ $DISPLAY ]]; then
    ZSH_THEME="powerlevel9k/powerlevel9k"
else
    ZSH_THEME="izaakrussell"
fi

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  colored-manpages
)

source $ZSH/oh-my-zsh.sh

export LC_CTYPE=en_GB.utf8

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

export LESS="-R"

export COLUMNS LINES

#export PAGER='vimpager -u ~/.vim/vimrc'
#alias less=$PAGER
#
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PYTHONSTARTUP=$HOME/.pythonrc

# font size changing in tty

case $(tty) in /dev/tty[0-9]*)
    echo "launching tty setup"
    IZ_VC_FONTSIZE=5;
    ter_fonts=(/usr/share/kbd/consolefonts/ter-1??n.psf.gz);
    izu() {
        if [[ $IZ_VC_FONTSIZE -ge 9 ]] then
            echo "already at max font";
        else
            ((IZ_VC_FONTSIZE++));
            setfont $ter_fonts[$IZ_VC_FONTSIZE];
            echo $ter_fonts[$IZ_VC_FONTSIZE];
        fi
    }
    izd() {
        if [[ $IZ_VC_FONTSIZE -le 1 ]] then
            echo "already at min font";
        else
            ((IZ_VC_FONTSIZE--));
            setfont $ter_fonts[$IZ_VC_FONTSIZE];
            echo $ter_fonts[$IZ_VC_FONTSIZE];
        fi
    }
    izr() {
        IZ_VC_FONTSIZE=5;
        setfont $ter_fonts[$IZ_VC_FONTSIZE];
        echo $ter_fonts[$IZ_VC_FONTSIZE];
    }
    izg() {
        echo $ter_fonts[$IZ_VC_FONTSIZE];
    }
;;
esac

bindkey -v
bindkey  "" backward-delete-char
bindkey -M vicmd e edit-command-line

alias lx='print -rl -- ${(ko)commands} ${(ko)functions} ${(ko)aliases} | grep -v "^_"'
alias z="source ~/.zshrc"

source $HOME/.izaak_aliases
source $HOME/.bourne_apparix

setopt menucomplete
unsetopt CASE_GLOB
setopt globcomplete
setopt extendedglob

# zsh syntax highlighting, with config from https://blog.patshead.com/2012/01/using-and-customizing-zsh-syntax-highlighting-with-oh-my-zsh.html
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
