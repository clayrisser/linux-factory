#!/bin/sh

if [ -d config/includes.installer/root/install/filesystem/boot/grub/themes/default ]; then
    mkdir -p config/includes.binary/boot/grub
    rm -rf config/includes.binary/boot/grub/live-theme
    cp -r config/includes.installer/root/install/filesystem/boot/grub/themes/default \
        config/includes.binary/boot/grub/live-theme
fi
