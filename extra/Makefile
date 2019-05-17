.PHONY: package_list etc pip_freeze

CFG = git --git-dir ~/.cfg --work-tree ~

ETC_FILES = /etc/locale.gen /etc/locale.conf /etc/profile.d/libreoffice-still.sh /etc/lightdm/lightdm-gtk-greeter.conf /etc/mysql/my.cnf /etc/pacman.conf /etc/pacman.d/mirrorlist /etc/systemd/logind.conf /etc/texmf/web2c/fmtutil.cnf /etc/pam.d/su /etc/pam.d/su-l

# this is a simplistic way to keep track of which packages I have
package_list:
	pacman -Qqe > package_list
	$(CFG) add package_list

# this is a very simplistic way to track files in /etc among my dotfiles
etc: $(ETC_FILES)
	mkdir -p etc
	cp $(ETC_FILES) etc
	$(CFG) add etc

pip_freeze:
	pip freeze > pip_freeze
	$(CFG) add pip_freeze
