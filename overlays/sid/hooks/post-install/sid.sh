#!/bin/sh

cat <<EOF > /etc/apt/sources.list
deb http://http.us.debian.org/debian sid main contrib non-free non-free-firmware
deb-src http://http.us.debian.org/debian sid main contrib non-free non-free-firmware
EOF

apt-get update
apt-upgrade
apt-get install -y \
    firmware-iwlwifi \
    firmware-linux \
    firmware-realtek
