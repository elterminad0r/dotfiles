export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# so that vim and ipython etc know my aliases.
alias lx='print -rl -- ${(ko)commands} ${(ko)functions} ${(ko)aliases} | grep -v "^_"'
source $HOME/.izaak_aliases
