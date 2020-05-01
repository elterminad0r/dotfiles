PLAYLIST_NAME = mogul_moves

.PHONY: all playlist

all:
	youtube-dl -f 140 -i -w --download-archive archive.txt "https://www.youtube.com/playlist?list=PLLGT0cEMIAzeqDa_h5pEQI4V2kjS2sxVH"

playlist:
	ls *.m4a | sed "s/^/$$(basename $$PWD)\//" > $$HOME/.config/mpd/playlists/$(PLAYLIST_NAME).m3u
	cat $$HOME/.config/mpd/playlists/$(PLAYLIST_NAME).m3u
