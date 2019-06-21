.PHONY: default all _all

# Makefile to store information about the system.

# Generally everything is silent, because I like to run this in a cron job, and
# only have it email me if anything needs my attention.

CFG = git --git-dir ~/.cfg --work-tree ~

ETC_FILES = /etc/locale.gen /etc/locale.conf /etc/profile.d/libreoffice-still.sh /etc/lightdm/lightdm-gtk-greeter.conf /etc/mysql/my.cnf /etc/pacman.conf /etc/pacman.d/mirrorlist /etc/systemd/logind.conf /etc/texmf/web2c/fmtutil.cnf /etc/pam.d/su /etc/pam.d/su-l /etc/postfix/aliases /etc/postfix/master.cf /etc/postfix/main.cf

default:
	$(error from Goedel: select an explicit target)

arch: _arch
	@make -B $< > /dev/null
	@$(CFG) status --porcelain

_arch: pacman_list aur_list etc pip_freeze3 crontab.arch systemd_units

mac: _mac
	@make -B $< > /dev/null
	@$(CFG) status --porcelain

_mac: brew_list crontab.mac

# store user crontab
crontab.arch:
	@crontab -l > $@
	@$(CFG) add $@

crontab.mac:
	@crontab -l > $@
	@$(CFG) add $@

# this is a simplistic way to keep track of which packages I have
pacman_list:
	@pacman -Qqen > $@
	@$(CFG) add $@

aur_list:
	@pacman -Qqem > $@
	@$(CFG) add $@

brew_list:
	@/usr/local/bin/brew leaves > $@
	@$(CFG) add $@

# this is a very simplistic way to track files in /etc among my dotfiles
etc:
	@mkdir -p etc
	@./etc_store $(ETC_FILES)
	@$(CFG) add $@

# TODO: strip frivolities
systemd_units:
	@systemctl list-unit-files --state=enabled > $@
	@$(CFG) add $@

pip_freeze3:
	@python3 -m pip freeze --user > $@
	@$(CFG) add $@
