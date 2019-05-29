# this will only ever execute if something has gone horribly wrong and profile
# hasn't been read yet (eg in a TTY) leading to a misunderstanding about
# ZDOTDIR.

source "$HOME/.profile"
source "$ZDOTDIR/.zshenv"
source "$ZDOTDIR/.zshrc"
