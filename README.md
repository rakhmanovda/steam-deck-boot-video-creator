# Steam Deck video creator

This project aims to provide a tool for creating a custom boot videos from slideshow

To use this tool you need:
* enter Desktop mode on your Steam Deck
* create a folder in Dolphin(file manager), where you put you own pictures(for example of your loved ones). *WARNING: those pictures should be in the correct order by their names*
* [optionally] you can add a music track (recommended to be under 10 seconds, if longer - you can check how to enable longer boot videos at [Steam Deck Repo web-site](https://steamdeckrepo.com/) )
* download [steam-deck-video-creator.sh](https://github.com/rakhmanovda/steam-deck-boot-video-creator/releases) file from this repository and put it in the same folder with pictures and music
* right click(left touchpad on steamdeck) inside the folder and open terminal
* in the terminal execute `sh steam-deck-video-creator.sh`

It will take a couple of minutes as this script resizes and compiles pictures into one `deck_startup.webm` video that you should put into `~/.steam/root/config/uioverrides/movies` folder(that needs to be created first)

The length of that video will be the same as music track you supplied in the folder. If you haven't put a music file there it will be 10 seconds.
