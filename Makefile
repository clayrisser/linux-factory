SHELL := /bin/bash
CWD := $(shell pwd)
DIST := xenial
IMAGE := devbuntu.iso

.PHONY: all
all: cd-image squashfs

.PHONY: chroot
chroot: cd-image squashfs mount
	@sudo cp /etc/resolv.conf ./squashfs/etc/resolv.conf
	@sudo cp ./dbtool.py ./squashfs/usr/bin/dbtool
	@sudo cp ./dbinit.sh ./squashfs/usr/bin/dbinit
	@sudo chmod +x ./squashfs/usr/bin/dbtool
	@sudo chmod +x ./squashfs/usr/bin/dbinit
	@sudo chroot ././squashfs/ /bin/bash

.PHONY: cd-image
cd-image: ._cd_image
._cd_image: ._mnt
	@mkdir -p ./cd-image/
	@sudo cp -r ./mnt/* ./cd-image/
	@sudo cp -r ./mnt/.disk ./cd-image/
	@touch ._cd_image
	@echo mnt extracted to ./cd-image/

.PHONY: squashfs
squashfs: ._squashfs
._squashfs: ._mnt
	@sudo unsquashfs mnt/install/filesystem.squashfs
	@sudo mv ./squashfs-root/ ./squashfs/
	@sudo chown -R $$USER:$$USER ./squashfs/
	@touch ._squashfs
	@echo filesystem unsquashed to ./squashfs/

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
	@sudo mount --bind /dev/ ./squashfs/dev/
	@touch ._mount
	@echo mounted

.PHONY: umount
umount:
	-@sudo umount ./mnt/ || true
	-@sudo umount ./squashfs/dev || true
	-@ rm -rf ./._mount
	@echo umounted

.PHONY: preseed
preseed: cd-image
	@sudo cp ./preseed/* cd-image/preseed/
	@echo preseeded

.PHONY: extras
extras: ._extras
._extras: cd-image
	@sudo mkdir -p ./cd-image/pool/extras/
	-@sudo cp -r ./extras/* ./cd-image/pool/extras/ | true
	@touch ._extras
	@echo extra packages added

.PHONY: keyring
keyring: ubuntu-keyring squashfs
	@echo made ubuntu-keyring
	@sudo cp /usr/share/keyrings/ubuntu-archive-keyring.gpg \
		./squashfs/usr/share/keyrings/ubuntu-archive-keyring.gpg
	@sudo cp /etc/apt/trusted.gpg ./squashfs/etc/apt/trusted.gpg
	@sudo cp /var/lib/apt/keyrings/ubuntu-archive-keyring.gpg \
		./squashfs/var/lib/apt/keyrings/ubuntu-archive-keyring.gpg
	@echo signed ubuntu-keyring
.PHONY: gen_key
gen_key: ._gen_key
._gen_key:
	@gpg --gen-key
	@touch ._gen_key
	@echo generated key
ubuntu-keyring: cd-image gen_key
	@read -p "Name: " _NAME && \
		read -p "Email: " _EMAIL && \
		gpg --list-keys "$$_NAME" && \
		read -p "Key ID: " _KEY_ID && \
		mkdir -p ubuntu-keyring && cd ubuntu-keyring && \
		apt-get source ubuntu-keyring && \
		cd ubuntu-keyring-2012.05.19/keyrings && \
		gpg --import < ubuntu-archive-keyring.gpg && \
		gpg --export FBB75451 437D05B5 C0B21F32 EFE21092 $$_KEY_ID > ubuntu-archive-keyring.gpg && \
		cd ../ && \
		dpkg-buildpackage -rfakeroot -m"$$_NAME <$$_EMAIL>" -k$$_KEY_ID && \
		cd ../ && \
		sudo cp ubuntu-keyring*deb $(CWD)/cd-image/pool/main/u/ubuntu-keyring

.PHONY: squash_resize
squash_resize: squashfs
	@cd ./squashfs/ && \
		sudo du -sx --block-size=1 ./ | cut -f1 > $(CWD)/cd-image/install/filesystem.size
	@echo squash filesystem resized

indices: cd-image
	@mkdir -p ./indices/
	@cd ./indices/ && \
		for SUFFIX in extra.main main main.debian-installer restricted restricted.debian-installer; do \
			wget http://archive.ubuntu.com/ubuntu/indices/override.$(DIST).$$SUFFIX; \
		done
	@echo fetched indices

.PHONY: build
build: keyring indices extras preseed
	@sudo mkdir -p ./cd-image/dists/stable/extras/binary-amd64/
	@sudo apt-ftparchive packages ./cd-image/pool/extras | sudo tee ./cd-image/dists/stable/extras/binary-amd64/Packages
	@sudo gzip -c ./cd-image/dists/stable/extras/binary-amd64/Packages | \
		sudo tee ./cd-image/dists/stable/extras/binary-amd64/Packages.gz > /dev/null
	@sudo apt-ftparchive -c ./apt-ftparchive/release.conf generate ./apt-ftparchive/apt-ftparchive-deb.conf
	@sudo perl extraoverride.pl < ./cd-image/dists/xenial/main/binary-amd64/Packages | sudo tee -a ./indices/override.xenial.extra.main
	@sudo apt-ftparchive -c ./apt-ftparchive/release.conf generate ./apt-ftparchive/apt-ftparchive-udeb.conf
	@sudo apt-ftparchive -c ./apt-ftparchive/release.conf generate ./apt-ftparchive/apt-ftparchive-extras.conf
	@sudo apt-ftparchive -c ./apt-ftparchive/release.conf release ./cd-image/dists/$(DIST) | sudo tee ./cd-image/dists/$(DIST)/Release
	@cd ./cd-image/ && \
		read -p "Name: " _NAME && \
		gpg --list-keys "$$_NAME" && \
		read -p "Key ID: " _KEY_ID && \
		sudo gpg --default-key $$_KEY_ID --output $(CWD)/cd-image/dists/$(DIST)/Release.gpg -ba $(CWD)/cd-image/dists/$(DIST)/Release
	@echo built devbuntu

.PHONY: iso
iso: cd-image md5sum
	@sudo mkisofs -r -V "Devbuntu Install CD" \
		-cache-inodes \
		-J -l -b isolinux/isolinux.bin \
		-c isolinux/boot.cat -no-emul-boot \
		-boot-load-size 4 -boot-info-table \
		-o $(IMAGE) ./cd-image/
	@echo made iso

.PHONY: md5sum
md5sum:
	@rm -rf md5sum.txt
	@cd ./cd-image && md5sum `find . -type f -print | grep -E -v "^(\.\/)(md5sum.txt|isolinux)"` | sudo tee ./md5sum.txt
	@echo generated md5 sum

.PHONY: clean
clean: umount
	-@sudo rm -rf ./squashfs/ \
		./cd-image/ \
		./mnt/ \
		./ubuntu-*.iso \
		./._* \
		./ubuntu-keyring \
		./indices \
		./extras/*.deb \
		./devbuntu.iso
	@echo cleaned
