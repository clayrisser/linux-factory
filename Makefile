#!/usr/bin/make -f

all: install_buildenv

install_buildenv:
	# Install packages required to build the image
	sudo apt install live-build make build-essential wget git xmlstarlet unzip colordiff shellcheck apt-transport-https rename ovmf rsync
