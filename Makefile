#!/usr/bin/make -f

all: install_buildenv build

install_buildenv:
	# Install packages required to build the image
	sudo apt install live-build make build-essential wget git xmlstarlet unzip colordiff shellcheck apt-transport-https rename ovmf rsync

bump_version:
	@last_tag=$$(git tag | tail -n1); \
	echo "Please set version to $$last_tag in Makefile config/bootloaders/isolinux/live.cfg.in config/bootloaders/isolinux/menu.cfg auto/config"

build:
	# Build the live system/ISO image
	#sudo lb clean --purge #only required when changing the mirrors/architecture config
	sudo lb clean --all
	sudo lb config
	sudo lb build

##############################

release: checksums sign_checksums

checksums:
	# Generate checksums of the resulting ISO image
	@mkdir -p iso/
	mv *.iso iso/
	last_tag=$$(git tag | tail -n1); \
	cd iso/; \
	rename "s/live-image/dlc-$$last_tag-debian-buster/" *; \
	sha512sum *.iso  > SHA512SUMS; \

sign_checksums:
	# Sign checksums with a GPG private key
	cd iso; \
	gpg --detach-sign --armor SHA512SUMS; \
	mv SHA512SUMS.asc SHA512SUMS.sign
