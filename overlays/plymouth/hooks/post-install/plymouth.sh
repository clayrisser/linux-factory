#!/bin/sh

echo apt-mark hold gdm3
apt-mark hold gdm3

echo plymouth-set-default-theme {{ overlay.config.theme }}
echo update-initramfs -u

if (cat /etc/gdm3/daemon.conf | grep -qE '^PlymouthTheme='); then
    sed -i 's|^\(PlymouthTheme=\).*|\1{{ overlay.config.theme }}|g' /etc/gdm3/daemon.conf
else
    sed -i "$(grep -n '\[daemon\]' /etc/gdm3/daemon.conf | cut -d ':' -f1) a PlymouthTheme={{ overlay.config.theme }}" /etc/gdm3/daemon.conf
fi
plymouth-set-default-theme {{ overlay.config.theme }}
update-initramfs -u
