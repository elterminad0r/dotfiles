# this will only ever execute if something has gone horribly wrong and profile
# hasn't been read yet (eg in a TTY or ssh) leading to a misunderstanding about
# ZDOTDIR.

>&2 echo "Izaak's zshrc: something has gone horribly, but recoverably, wrong"

source "$HOME/.profile"
source "$ZDOTDIR/.zshenv"
source "$ZDOTDIR/.zshrc"
