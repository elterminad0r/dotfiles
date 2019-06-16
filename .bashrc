# zsh-like, keep bashrc in separate directory
# don't use BASHDOTDIR to be on the safe side

>&2 echo "Izaak's bashrc: something has gone horribly wrong"

source "$HOME/.profile"
source "$HOME/.bash/bashrc"
