#!/bin/sh

curl -L https://gitlab.com/risserlabs/community/firefox-sway-gnome-theme/-/raw/master/scripts/auto-install.sh | bash

xdg-settings set default-web-browser librewolf.desktop
