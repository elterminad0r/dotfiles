.PHONY: default all _all

CFG = git --git-dir ~/.cfg --work-tree ~

ETC_FILES = /etc/locale.gen /etc/locale.conf /etc/profile.d/libreoffice-still.sh /etc/lightdm/lightdm-gtk-greeter.conf /etc/mysql/my.cnf /etc/pacman.conf /etc/pacman.d/mirrorlist /etc/systemd/logind.conf /etc/texmf/web2c/fmtutil.cnf /etc/pam.d/su /etc/pam.d/su-l

default:
	$(error from Goedel: select an explicit target or all)

all: _all
	make -B $<

_all: pacman_list etc pip_freeze3 crontab

# store user crontab
crontab:
	crontab -l > $@
	$(CFG) add $@

# this is a simplistic way to keep track of which packages I have
pacman_list:
	pacman -Qqe > $@
	$(CFG) add $@

# this is a very simplistic way to track files in /etc among my dotfiles
etc: $(ETC_FILES)
	mkdir -p etc
	./etc_store $(ETC_FILES)
	$(CFG) add $@

pip_freeze3:
	python3 -m pip freeze --user > $@
	$(CFG) add $@
