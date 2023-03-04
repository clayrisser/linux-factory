#!/bin/sh

apt-mark hold sway

pip3 install autotiling

if (cat /etc/gdm3/daemon.conf | grep -qE '^DefaultSession='); then
    sed -i 's|^\(DefaultSession=\).*|\1sway|g' /etc/gdm3/daemon.conf
else
    sed -i "$(grep -n '\[daemon\]' /etc/gdm3/daemon.conf | cut -d ':' -f1) a DefaultSession=sway" /etc/gdm3/daemon.conf
fi
