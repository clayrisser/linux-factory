#!/bin/sh

sudo calamares
while [ $? -ne 0 ]; do
    sudo calamares
done
