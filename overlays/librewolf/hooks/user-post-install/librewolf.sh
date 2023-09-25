#!/bin/sh

librewolf -headless &
PID=$!
sleep 5
kill $PID
wget -qO- https://gitlab.com/risserlabs/community/firefox-sway-gnome-theme/-/raw/master/scripts/install-by-curl.sh | bash

xdg-settings set default-web-browser librewolf.desktop
