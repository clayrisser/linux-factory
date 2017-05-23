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
	@sudo rsync --exclude=/install/filesystem.squashfs -a ./mnt/ ./cd-image/
	@sudo chown -R $$USER:$$USER ./cd-image/
	@sudo chmod -R 755 ./cd-image/
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
preseed:
	@echo preseeded

.PHONY: extras
extras: ._extras
._extras: cd-image
	@mkdir -p ./cd-image/pool/extras/
	-@cp -r ./extras/* ./cd-image/pool/extras/ | true
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
		cp ubuntu-keyring*deb $(CWD)/cd-image/pool/main/u/ubuntu-keyring

.PHONY: squash_resize
squash_resize: squashfs
	@cd ./squashfs/ && \
		du -sx --block-size=1 ./ | cut -f1 > $(CWD)/cd-image/install/filesystem.size
	@echo squash filesystem resized

indices: cd-image
	@mkdir -p ./indices/
	@cd ./indices/ && \
		for SUFFIX in extra.main main main.debian-installer restricted restricted.debian-installer; do \
			wget http://archive.ubuntu.com/ubuntu/indices/override.$(DIST).$$SUFFIX; \
		done
	@echo fetched indices

.PHONY: build
build: keyring indices extras
	@mkdir -p ./cd-image/dists/stable/extras/binary-amd64/
	@apt-ftparchive packages ./cd-image/pool/extras > ./cd-image/dists/stable/extras/binary-amd64/Packages
	@gzip -c ./cd-image/dists/stable/extras/binary-amd64/Packages | \
		tee ./cd-image/dists/stable/extras/binary-amd64/Packages.gz > /dev/null
	@apt-ftparchive -c ./apt-ftparchive/release.conf generate ./apt-ftparchive/apt-ftparchive-deb.conf
	@perl extraoverride.pl < ./cd-image/dists/xenial/main/binary-amd64/Packages >> ./indices/override.xenial.extra.main
	@apt-ftparchive -c ./apt-ftparchive/release.conf generate ./apt-ftparchive/apt-ftparchive-udeb.conf
	@apt-ftparchive -c ./apt-ftparchive/release.conf generate ./apt-ftparchive/apt-ftparchive-extras.conf
	@apt-ftparchive -c ./apt-ftparchive/release.conf release ./cd-image/dists/$(DIST) > ./cd-image/dists/$(DIST)/Release
	@pushd ./cd-image/ && \
		read -p "Name: " _NAME && \
		gpg --list-keys "$$_NAME" && \
		read -p "Key ID: " _KEY_ID && \
		gpg --default-key $$_KEY_ID --output $(CWD)/cd-image/dists/$(DIST)/Release.gpg -ba $(CWD)/cd-image/dists/$(DIST)/Release && \
		find . -type f -print0 | xargs -0 md5sum > md5sum.txt && \
		popd
	@echo built devbuntu

.PHONY: iso
iso:
	mkisofs -r -V "Devbuntu Install CD" \
		-cache-inodes \
		-J -l -b isolinux/isolinux.bin \
		-c isolinux/boot.cat -no-emul-boot \
		-boot-load-size 4 -boot-info-table \
		-o $(IMAGE) ./cd-image
	@echo made iso

.PHONY: clean
clean: umount
	-@sudo rm -rf ./squashfs/ \
		./cd-image/ \
		./mnt/ \
		./ubuntu-*.iso \
		./._* \
		./ubuntu-keyring \
		./indices \
		./md5sum.txt \
		./extras/*.deb \
		./devbuntu.iso
	@echo cleaned
