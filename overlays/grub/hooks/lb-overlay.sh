#!/bin/sh

if [ -d config/includes.chroot/root/install/filesystem/boot/grub/themes/default ]; then
    mkdir -p config/includes.binary/boot/grub
    rm -rf config/includes.binary/boot/grub/live-theme
    cp -r config/includes.chroot/root/install/filesystem/boot/grub/themes/default \
        config/includes.binary/boot/grub/live-theme
    rm -rf config/includes.binary/boot/grub/splash.png
fi

if [ -f config/includes.chroot/root/install/filesystem/boot/grub/splash.png ]; then
    mkdir -p config/includes.binary/boot/grub
    cp config/includes.chroot/root/install/filesystem/boot/grub/splash.png \
        config/includes.binary/boot/grub/splash.png
fi
