.PHONY: default arch _arch mac _mac reflect_install mirrorlist.uk

# Makefile to store information about the system.

# Generally everything is silent, because I like to run this in a cron job, and
# only have it email me if anything needs my attention.

CFG = git --git-dir ~/.cfg --work-tree ~

ETC_FILES = /etc/locale.gen /etc/locale.conf /etc/profile.d/libreoffice-still.sh /etc/lightdm/lightdm-gtk-greeter.conf /etc/mysql/my.cnf /etc/pacman.conf /etc/pacman.d/mirrorlist /etc/systemd/logind.conf /etc/texmf/web2c/fmtutil.cnf /etc/pam.d/su /etc/pam.d/su-l /etc/postfix/aliases /etc/postfix/master.cf /etc/postfix/main.cf

default:
	$(error "from Goedel: select an explicit target (eg mac or arch)")

mirrorlist.uk:
	reflector -c "United Kingdom" -f 100 --save $@
	@$(CFG) add --verbose $@ >&2

reflect_install:
	cat mirrorlist.uk | sudo tee /etc/pacman.d/mirrorlist > /dev/null

arch: _arch
	@make -B $< > /dev/null
	@$(CFG) add --verbose ~/.lyrics >&2
	@$(CFG) add --verbose Makefile >&2

_arch: pacman.list aur.list slash pip3.list crontab.arch systemd_units groups

mac: _mac
	@make -B $< > /dev/null
	@$(CFG) add --verbose Makefile >&2

_mac: brew.list crontab.mac brew_cask.list

# store user crontab
crontab.arch:
	@crontab -l > $@
	@$(CFG) add --verbose $@ >&2

crontab.mac:
	@crontab -l > $@
	@$(CFG) add --verbose $@ >&2

# this is a simplistic way to keep track of which packages I have
pacman.list: pacman_store
	@./$<
	@$(CFG) add --verbose $@ $< >&2

aur.list:
	@pacman -Qqem > $@
	@$(CFG) add --verbose $@ >&2

brew.list:
	@/usr/local/bin/brew leaves > $@
	@$(CFG) add --verbose $@ >&2

brew_cask.list:
	@/usr/local/bin/brew cask list > $@
	@$(CFG) add --verbose $@ >&2

# this is a very simplistic way to track files in /etc among my dotfiles
slash: etc_store
	@mkdir -p $@
	@./$< $(ETC_FILES)
	@$(CFG) add --verbose $@ $< >&2

groups:
	@groups "$$USER" > $@
	@$(CFG) add --verbose $@ >&2

# TODO: strip frivolities
systemd_units:
	@systemctl list-unit-files --state=enabled > $@
	@$(CFG) add --verbose $@ >&2

pip3.list:
	@python3 -m pip freeze --user > $@
	@$(CFG) add --verbose $@ >&2
