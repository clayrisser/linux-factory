#!/bin/sh

if (echo $PATH | grep -vq '/usr/local/bin'); then
    export PATH="/usr/local/bin:$PATH"
fi

$(curl --version >/dev/null 2>/dev/null && echo curl -L || echo wget -O-) \
    https://gitlab.com/risserlabs/community/cody/-/raw/main/cody.sh 2>/dev/null | sh -s i cody
cody install cinch
cody install dotstow

if [ -f /etc/skel/.config/sway/startup.sh ]; then
    cat <<EOF >> /etc/skel/.config/sway/startup.sh

if [ ! -f "\${XDG_STATE_HOME:-\$HOME/.local/state}/weasley/dotstow" ]; then
    kitty -e weasley startup
fi
EOF
    cp /etc/skel/.config/sway/startup.sh "/home/$DEFAULT_USER/.config/sway/startup.sh"
    chown $DEFAULT_USER:$DEFAULT_USER "/home/$DEFAULT_USER/.config/sway/startup.sh"
else
    cat <<EOF >> /etc/skel/.profile

if [ ! -f "\${XDG_STATE_HOME:-\$HOME/.local/state}/weasley/dotstow" ]; then
    kitty -e weasley startup
fi
EOF
    cp /etc/skel/.profile "/home/$DEFAULT_USER/.profile"
    chown $DEFAULT_USER:$DEFAULT_USER "/home/$DEFAULT_USER/.profile"
fi
