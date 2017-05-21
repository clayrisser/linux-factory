SHELL := /bin/bash
CWD := $(shell pwd)

.PHONY: all
all: extracted edit

.PHONY: chroot
chroot: extracted edit mount
	@sudo cp /etc/resolv.conf edit/etc/resolv.conf
	@sudo cp ./dbtool.py edit/usr/bin/dbtool
	@sudo cp ./dbinit.sh edit/usr/bin/dbinit
	@sudo chmod +x edit/usr/bin/dbtool
	@sudo chmod +x edit/usr/bin/dbinit
	@sudo chroot ./edit /bin/bash

.PHONY: extracted
extracted: ._extracted
._extracted: ._mnt
	@mkdir -p ./extracted/
	@sudo rsync --exclude=/install/filesystem.squashfs -a ./mnt/ ./extracted/
	@sudo chown -R $$USER:$$USER ./extracted/
	@touch ._extracted
	@echo mnt extracted to ./extracted/

.PHONY: edit
edit: ._edit
._edit: ._mnt
	@sudo unsquashfs mnt/install/filesystem.squashfs
	@sudo mv ./squashfs-root/ ./edit/
	@sudo chown -R $$USER:$$USER ./edit/
	@touch ._edit
	@echo filesystem unsquashed to ./edit/

.PHONY: mnt
mnt: ._mnt
._mnt: ubuntu-16.04.2-server-amd64.iso
	@mkdir -p ./mnt/
	@sudo mount -o loop ubuntu-16.04.2-server-amd64.iso ./mnt/
	@touch ._mnt
	@echo iso mounted to ./mnt/

ubuntu-16.04.2-server-amd64.iso:
	-@if [ -f $$HOME"/Downloads/ubuntu-16.04.2-server-amd64.iso" ]; then \
		cp ~/Downloads/ubuntu-16.04.2-server-amd64.iso ./; \
	else \
		curl -LO http://releases.ubuntu.com/xenial/ubuntu-16.04.2-server-amd64.iso; \
		cp ./ubuntu-16.04.2-server-amd64.iso ~/Downloads/; \
	fi;
	@echo ./ubuntu-16.04.2-server-amd64.iso downloaded

.PHONY: mount
mount: ._mount
._mount:
	@sudo mount --bind /dev/ ./edit/dev/
	@touch ._mount
	@echo mounted

.PHONY: umount
umount:
	-@sudo umount ./mnt/ || true
	-@sudo umount ./edit/dev || true
	-@ rm -rf ./._mount
	@echo umounted

.PHONY: clean
clean: umount
	-@sudo rm -rf ./edit ./extracted ./mnt ./ubuntu-*.iso ./._*
	@echo cleaned
