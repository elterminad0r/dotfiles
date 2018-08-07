# original prompt
#PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})"

# if it's not done like this something weird happens to the autocompletion
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[magenta]%})%n$ret_status%#%{$fg_bold[yellow]%}%m$ret_status|%f%{$fg[cyan]%}%2c%b %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
