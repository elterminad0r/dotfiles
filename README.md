These are my dotfiles, maintained in Git using

https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

    git init --bare $HOME/.cfg
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    config config --local status.showUntrackedFiles no
    echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc

    alias config='/usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree=$HOME'
    echo ".cfg" >> .gitignore
    git clone --recursive --bare "https://github.com/goedel-gang/dotfiles" "$HOME"/.cfg
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    config checkout
