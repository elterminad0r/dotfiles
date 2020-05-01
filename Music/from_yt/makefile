.PHONY: default tags_archive

CFG = git --git-dir ~/.cfg --work-tree ~

default: tags_archive
	youtube-dl -a list.txt -f 140 --download-archive archive.txt

tags_archive:
	./gen_tags_archive.sh
	$(CFG) add $@/*
