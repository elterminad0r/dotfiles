# vim: ft=zsh

# FIGMENTIZE: izaakrussel.zsh-theme
# .__                          __                                          .__                     .__              __   .__
# |__|_____________   _____   |  | _________  __ __  ______  ______  ____  |  |    ________  ______|  |__         _/  |_ |  |__    ____    _____    ____
# |  |\___   /\__  \  \__  \  |  |/ /\_  __ \|  |  \/  ___/ /  ___/_/ __ \ |  |    \___   / /  ___/|  |  \  ______\   __\|  |  \ _/ __ \  /     \ _/ __ \
# |  | /    /  / __ \_ / __ \_|    <  |  | \/|  |  /\___ \  \___ \ \  ___/ |  |__   /    /  \___ \ |   Y  \/_____/ |  |  |   Y  \\  ___/ |  Y Y  \\  ___/
# |__|/_____ \(____  /(____  /|__|_ \ |__|   |____//____  >/____  > \___  >|____//\/_____ \/____  >|___|  /        |__|  |___|  / \___  >|__|_|  / \___  >
#           \/     \/      \/      \/                   \/      \/      \/       \/      \/     \/      \/                    \/      \/       \/      \/

# my zsh prompt theme, based on Stijn van Dongen's taste in bash prompts
# together with the robbyrussell OMZ theme.

# original prompt
#PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})"

# if it's not done like this something weird happens to the autocompletion
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[magenta]%})%n$ret_status%#%{$fg_bold[yellow]%}%m$ret_status|%f%{$fg[cyan]%}%2c%b %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
