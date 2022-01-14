#!/bin/sh

mkdir -p filesystem/live/etc/calamares/branding/debian
cp assets/calamares/*.png filesystem/live/etc/calamares/branding/debian 2>/dev/null || true
