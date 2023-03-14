#!/bin/sh

librewolf -headless &; sleep 10 && killall librewolf
curl -L https://gitlab.com/risserlabs/community/firefox-sway-gnome-theme/-/raw/master/scripts/install-by-curl.sh | bash

xdg-settings set default-web-browser librewolf.desktop
