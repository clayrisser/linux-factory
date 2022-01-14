#!/bin/sh

if [ -d config/includes.installer/root/install/filesystem/boot/grub/themes/default ]; then
    mkdir -p config/includes.binary/boot/grub
    rm -rf config/includes.binary/boot/grub/live-theme
    cp -r config/includes.installer/root/install/filesystem/boot/grub/themes/default \
        config/includes.binary/boot/grub/live-theme
fi

if [ -f config/includes.installer/root/install/filesystem/boot/grub/splash.png ]; then
    mkdir -p config/includes.binary/boot/grub
    cp config/includes.installer/root/install/filesystem/boot/grub/splash.png \
        config/includes.binary/boot/grub/splash.png
elif [ -f config/includes.installer/root/install/filesystem/boot/grub/themes/default/splash.png ]; then
    cp config/includes.installer/root/install/filesystem/boot/grub/themes/default/splash.png \
        config/includes.binary/boot/grub/splash.png
elif [ -f config/includes.installer/root/install/filesystem/boot/grub/themes/default/background.png ]; then
    cp config/includes.installer/root/install/filesystem/boot/grub/themes/default/background.png \
        config/includes.binary/boot/grub/splash.png
fi
