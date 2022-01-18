#!/bin/sh

OS_PATH=../.os

for p in $(cat config/package-lists/*.list.chroot_live 2>/dev/null || true); do
    sed -i 's|  - remove: \[]|  - remove:|g' \
        config/includes.chroot/etc/calamares/modules/packages.conf
    echo "\n      - $p" | $INSERT_CAT \
        config/includes.chroot/etc/calamares/modules/packages.conf \
        '  - remove:' -i
done

for p in $(cat config/package-lists/*.list.install 2>/dev/null || true); do
    sed -i 's|  - install: \[]|  - install:|g' \
        config/includes.chroot/etc/calamares/modules/packages.conf
    echo "\n      - $p" | $INSERT_CAT \
        config/includes.chroot/etc/calamares/modules/packages.conf \
        '  - install:' -i
done
