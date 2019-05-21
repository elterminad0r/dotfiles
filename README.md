These are my dotfiles, maintained in Git using

https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

    alias cfg='/usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree=$HOME'
    git clone --recursive --bare "https://github.com/goedel-gang/dotfiles" "$HOME"/.cfg
    cfg checkout

![screenshot](https://github.com/goedel-gang/dotfiles/blob/master/README_PICTURE.png)
