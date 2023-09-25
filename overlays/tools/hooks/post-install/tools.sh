#!/bin/sh

if which apt-file >/dev/null; then
    apt-file update
fi
