#!/bin/sh

firefox-esr -headless &
PID=$!
sleep 5
kill $PID

wget -qO- https://gitlab.com/bitspur/community/firefox-sway-gnome-theme/-/raw/102/scripts/install-by-curl.sh | bash
FIREFOXFOLDER="$HOME/.mozilla/firefox"
PROFILES_FILE="$FIREFOXFOLDER/profiles.ini"
if [ ! -f "$PROFILES_FILE" ]; then
    >&2 echo "unable to find firefox 'profile.ini' at $FIREFOXFOLDER"
    exit 1
fi
PROFILES_PATHS="$(grep -E "^Path=" "$PROFILES_FILE" | tr -d '\n' | sed -e 's/\s\+/SPACECHARACTER/g' | sed 's/Path=/ /g' | tr " " "\n")"
for p in $PROFILES_PATHS; do
    cp "$FIREFOXFOLDER/user.js" "$FIREFOXFOLDER/$p/user.js"
done

xdg-settings set default-web-browser firefox-esr.desktop
