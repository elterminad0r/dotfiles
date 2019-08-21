# dotfiles

These are my dotfiles, maintained in Git using

<https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/>

	cd
    alias cfg='/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree=$HOME'
    git clone --bare "https://github.com/goedel-gang/dotfiles" "$HOME/.cfg"
    cfg config --local status.showUntrackedFiles no
    cfg checkout || { cfg stash; cfg checkout }
    cfg submodule update --init
	exec zsh

Of course they should be considered an entirely volatile, possibly hostile work
in progress.

![screenshot](https://github.com/goedel-gang/dotfiles/blob/master/.github/README_GRUVBOX.png)

How it has looked at some point in the past:

![screenshot](https://github.com/goedel-gang/dotfiles/blob/master/.github/README_SOLARIZED.png)
![screenshot](https://github.com/goedel-gang/dotfiles/blob/master/.github/README_SOLARIZED_OLD.png)
