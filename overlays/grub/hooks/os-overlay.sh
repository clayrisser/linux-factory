#!/bin/sh

if [ -f assets/grub/theme.tar ] || [ -d assets/grub/theme ]; then
    if [ -f assets/grub/theme.tar ]; then
		rm -rf filesystem/installed/boot/grub/themes/default
        mkdir -p filesystem/installed/boot/grub/themes/default
        CWD=$(pwd)
        ( \
            cd filesystem/installed/boot/grub/themes/default && \
                tar -xvf $CWD/assets/grub/theme.tar \
        )
    elif [ -d assets/grub/theme ]; then
		rm -rf filesystem/installed/boot/grub/themes/default
        mkdir -p filesystem/installed/boot/grub/themes
        cp -r assets/grub/theme \
            filesystem/installed/boot/grub/themes/default
    fi
    mkdir -p filesystem/installed/etc/default
    cat <<EOF > filesystem/installed/etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

SWAP_UUID=\$(blkid | grep 'TYPE="swap"' | \
    grep \$(cat /proc/swaps | grep '^/dev/' | cut -d' ' -f1 | cut -d'/' -f3) | \
    sed 's|.\+\sUUID="\([^"]\+\).\+|\1|g')

GRUB_DEFAULT="0"
GRUB_TIMEOUT="5"
GRUB_DISTRIBUTOR="\`lsb_release -i -s 2> /dev/null || echo $OS_SHORT_NAME\`"
GRUB_CMDLINE_LINUX_DEFAULT="quiet\$([ "\$SWAP_UUID" = "" ] || echo " resume=UUID=\$SWAP_UUID")"
GRUB_CMDLINE_LINUX=""
GRUB_THEME="/boot/grub/themes/default/theme.txt"

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL="console"

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command \`vbeinfo'
GRUB_GFXMODE="1920x1080"

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID="true"

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"
EOF
fi

if [ -f assets/grub/splash.png ]; then
    mkdir -p filesystem/installed/boot/grub
    cp assets/grub/splash.png \
        filesystem/installed/boot/grub/splash.png
    mkdir -p filesystem/binary/boot/grub
    cp assets/grub/splash.png \
        filesystem/binary/boot/grub/splash.png
fi
if [ "<% $OS_DEBUG %>" = "false" ] && [ -f assets/isolinux/splash.png ]; then
    mkdir -p filesystem/binary/isolinux
    cp assets/isolinux/splash.png \
        filesystem/binary/isolinux/splash.png
fi
