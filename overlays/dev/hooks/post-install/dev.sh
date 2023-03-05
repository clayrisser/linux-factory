#!/bin/sh

$(curl --version >/dev/null 2>/dev/null && echo curl -L || echo wget -O-) \
    https://gitlab.com/risserlabs/community/cody/-/raw/main/cody.sh 2>/dev/null | sh -s i cody
/usr/local/bin/cody install cinch
/usr/local/bin/cody install dotstow

cat <<EOF >> /etc/skel/.profile
if [ -f "\${XDG_STATE_HOME:-\$HOME/.local/state}/weasley/dotstow" ]; then
    kitty -e weasley startup
fi
EOF
cp /etc/skel/.profile "/home/$DEFAULT_USER/.profile"
chown $DEFAULT_USER:$DEFAULT_USER "/home/$DEFAULT_USER/.profile"
