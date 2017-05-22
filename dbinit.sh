#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Must have root privileges"
  exit 1
fi

apt-get update
(echo) | apt-get install python software-properties-common
add-apt-repository main
add-apt-repository universe
add-apt-repository multiverse
apt-get update
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
echo initialized devbuntu
