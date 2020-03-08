#!/usr/bin/make -f

all: install_buildenv clean download_extras build

install_buildenv:
	# Install packages required to build the image
	sudo apt install live-build make build-essential wget git xmlstarlet unzip colordiff shellcheck apt-transport-https rename ovmf rsync

##############################

# clear all caches, only required when changing the mirrors/architecture config
clean:
	sudo lb clean --purge

WGET=wget --continue --no-verbose --show-progress --directory-prefix=cache/downloads/
download_extras:
	mkdir -p cache/downloads/
	# https://gitlab.com/nodiscc/plymouth-theme-debian-logo
	-rm -rf config/includes.chroot/usr/share/plymouth/themes/debian-logo cache/downloads/plymouth-theme-debian-logo-1.0
	$(WGET) https://gitlab.com/nodiscc/plymouth-theme-debian-logo/-/archive/1.0/plymouth-theme-debian-logo-1.0.zip
	unzip -q cache/downloads/plymouth-theme-debian-logo-1.0.zip -d cache/downloads/
	mkdir -p config/includes.chroot/usr/share/plymouth/themes/
	mv cache/downloads/plymouth-theme-debian-logo-1.0 config/includes.chroot/usr/share/plymouth/themes/debian-logo
	# https://gitlab.com/nodiscc/cc0-wallpapers
	-rm -rf config/includes.chroot/usr/share/backgrounds/cc0-wallpapers cache/downloads/cc0-wallpapers-1.0
	$(WGET) https://gitlab.com/nodiscc/cc0-wallpapers/-/archive/1.0/cc0-wallpapers-1.0.zip
	unzip -q cache/downloads/cc0-wallpapers-1.0.zip -d cache/downloads/
	mkdir -p config/includes.chroot/usr/share/backgrounds/
	mv cache/downloads/cc0-wallpapers-1.0 config/includes.chroot/usr/share/backgrounds/cc0-wallpapers
	# https://gitlab.com/nodiscc/xfce4-terminal-colorschemes
	-rm -rf config/includes.chroot/usr/share/xfce4/terminal/colorschemes cache/downloads/xfce4-terminal-colorschemes-1.0
	$(WGET) https://gitlab.com/nodiscc/xfce4-terminal-colorschemes/-/archive/1.0/xfce4-terminal-colorschemes-1.0.zip
	unzip -q cache/downloads/xfce4-terminal-colorschemes-1.0.zip -d cache/downloads/
	mkdir -p config/includes.chroot/usr/share/xfce4/terminal/
	mv cache/downloads/xfce4-terminal-colorschemes-1.0 config/includes.chroot/usr/share/xfce4/terminal/colorschemes
	# https://github.com/scopatz/nanorc
	-rm -rf config/includes.chroot/etc/skel/.nano cache/downloads/nano-highlight-master
	$(WGET) https://github.com/scopatz/nanorc/archive/master.zip -O cache/downloads/nanorc-master.zip
	unzip -q cache/downloads/nanorc-master.zip -d cache/downloads/
	mv cache/downloads/nanorc-master config/includes.chroot/etc/skel/.nano

##############################

bump_version:
	@last_tag=$$(git tag | tail -n1); \
	echo "Please set version to $$last_tag in Makefile config/bootloaders/isolinux/live.cfg.in config/bootloaders/isolinux/menu.cfg auto/config"

build:
	# Build the live system/ISO image
	sudo lb clean --all
	sudo lb config
	sudo lb build

##############################

release: checksums sign_checksums release_archive

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

release_archive:
	git archive --format=zip -9 HEAD -o $$(basename $$PWD)-$$(git rev-parse HEAD).zip

################################

tests: download_iso test_kvm_bios test_kvm_uefi

download_iso:
	# download the iso image from a build server
	rsync -avP buildbot.xinit.se:/var/debian-live-config/debian-live-config/iso ./

test_kvm_bios:
	# Run the resulting image in KVM/virt-manager (legacy BIOS mode)
	sudo virt-install --name dlc-test --boot cdrom --disk path=/dlc-test-disk0.qcow2,format=qcow2,size=20,device=disk,bus=virtio,cache=none --cdrom 'iso/dlc-2.1-rc3-debian-buster-amd64.hybrid.iso' --memory 2048 --vcpu 2
	sudo virsh destroy dlc-test
	sudo virsh undefine dlc-test
	sudo rm /dlc-test-disk0.qcow2

test_kvm_uefi:
	# Run the resulting image in KVM/virt-manager (UEFI mode)
	# UEFI support must be enabled in QEMU config for EFI install tests https://wiki.archlinux.org/index.php/Libvirt#UEFI_Support (/usr/share/OVMF/*.fd)
	sudo virt-install --name dlc-test --boot loader=/usr/share/OVMF/OVMF_CODE.fd --disk path=/dlc-test-disk0.qcow2,format=qcow2,size=20,device=disk,bus=virtio,cache=none --cdrom 'iso/dlc-2.1-rc3-debian-buster-amd64.hybrid.iso' --memory 2048 --vcpu 2
	sudo virsh destroy dlc-test
	sudo virsh undefine dlc-test
	sudo rm /dlc-test-disk0.qcow2
