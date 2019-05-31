# My basic configuration for powerlevel10(9)k
# for a prettier one, see purepower (which is not my own)

# mostly colours are given as numbers, which is to assure me in my mind that I'm
# using the basic 16 terminal colours. I have the executable ~/bin/p256 to give
# me a quick hint of what each colour looks like, and would recommend investing
# in something similar if you're messing around with colours in terminals

if [[ "$GOEDEL_COLORSCHEME" == light ]]; then
    POWERLEVEL9K_COLOR_SCHEME='light'
else
    POWERLEVEL9K_COLOR_SCHEME='dark'
fi

# customisation options for powerline. The implementation I use is
# powerlevel10k as it's a lot faster.

function p9k_shlvl_prompt {
    print -P "%(2L.%L.)"
}

POWERLEVEL9K_CUSTOM_SHLVL="p9k_shlvl_prompt"
POWERLEVEL9K_CUSTOM_SHLVL_BACKGROUND=003

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status custom_shlvl background_jobs history)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context root_indicator dir_writable dir vcs)

POWERLEVEL9K_ROOT_ICON=!
POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=003
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=001
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND=003
POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND=001
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=001
POWERLEVEL9K_CONTEXT_REMOTE_BACKGROUND=002
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND=005
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND=000
POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND=003
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=003
POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=000
# POWERLEVEL9K_CONTEXT_SUDO_BOLD=true
# POWERLEVEL9K_CONTEXT_ROOT_BOLD=true
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND=000
POWERLEVEL9K_HISTORY_BACKGROUND=blue
# red and green, of course
POWERLEVEL9K_CONTEXT_REMOTE_SUDO_BACKGROUND=005
# BLOAT IS NOT WELCOMe HERE
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history time battery)
# I try to use just the colours 1-8 so that they change along with colour
# schemes.
POWERLEVEL9K_BATTERY_LOW_FOREGROUND=000
POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND=000
POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND=000
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=000
POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND=(red3 darkorange3 darkgoldenrod gold3 yellow3 chartreuse2 mediumspringgreen green3 green3 green4 darkgreen)
POWERLEVEL9K_BATTERY_STAGES="▁▂▃▄▅▆▇█"
# show current vi mode in prompt
POWERLEVEL9K_VI_INSERT_MODE_STRING='I'
POWERLEVEL9K_VI_COMMAND_MODE_STRING='N'
# POWERLEVEL9K_VI_VISUAL_MODE_STRING='V'
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND=005
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=005
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND=005
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND=005
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# adapted and trimmed down a little from romkatv's purepower configuration. I
# understand the very broad principles behind what's happening, but please don't
# ask me to explain it.
# I think this requires p10k extensions, but honestly in this day and age who
# actually uses p9k
local vi_ins="%F{cyan}"
local vi_cmd="%F{magenta}"
local vi_c='${${${KEYMAP:-0}:#vicmd}:+${${vi_ins}}}${${$((!${#${KEYMAP:-0}:#vicmd})):#0}:+${${vi_cmd}}}'
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="$vi_c╔═%f"
 POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="$vi_c╚═%f "
source "$POWERLEVEL_THEME"
# TODO: doesn't work
PROMPT2=".. "
RPROMPT2="%K{cyan} %_ %k"
