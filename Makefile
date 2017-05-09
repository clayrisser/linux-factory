SHELL := /bin/bash
CWD := $(shell readlink -en $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

.PHONY: all
all: extracted edit

.PHONY: chroot
chroot: extracted edit
	sudo cp /etc/resolv.conf edit/etc/resolv.conf
	sudo cp /usr/bin/zsh edit/usr/bin/zsh
	sudo chroot ./edit

extracted: mnt
	-mkdir -p ./extracted/
	sudo rsync --exclude=/install/filesystem.squashfs -a ./mnt/ ./extracted/

edit: mnt
	sudo unsquashfs mnt/install/filesystem.squashfs
	sudo mv ./squashfs-root/ ./edit/

mnt: ubuntu-16.04.2-server-amd64.iso
	-mkdir -p ./mnt/
	-sudo mount -o loop ubuntu-16.04.2-server-amd64.iso ./mnt/

ubuntu-16.04.2-server-amd64.iso:
	curl -LO http://releases.ubuntu.com/xenial/ubuntu-16.04.2-server-amd64.iso

.PHONY: umount
umount:
	-@sudo umount ./mnt/
	$(info unmounted)

.PHONY: clean
clean: umount
	@sudo rm -rf ./edit ./extracted ./mnt ./ubuntu-*.iso ./._*
	$(info cleaned)
