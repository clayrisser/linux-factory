export MAKE_CACHE := $(shell pwd)/.make
export PARENT := true
include blackmagic.mk

CWD=$(shell pwd)
CLOC ?= cloc
CSPELL ?= cspell
DPKG_NAME ?= dpkg-name
ISO_FILE ?= live-image-amd64.hybrid.iso
EXPORT_GPG_KEY := sh $(CWD)/export-gpg-key.sh

.PHONY: all
all: build

.PHONY: sudo
sudo:
	@sudo true

ACTIONS += config
CONFIG_DEPS := auto/config config-overrides
CONFIG_TARGET := sudo
$(ACTION)/config:
	@sudo bash auto/config
	@$(MAKE) -s fix-permissions
	@$(MAKE) -s packages
	@$(MAKE) -s fonts
	@for d in $$(ls config-overrides); do \
		mkdir -p config/$$d && \
		if [ "$$(echo $$d | $(SED) 's|\..*||g')" == "includes" ]; then \
			rsync -a config-overrides/$$d/ config/$$d/; \
		else \
			rsync -a --exclude=".*" config-overrides/$$d/ config/$$d/; \
		fi; \
	done
	@$(call done,config)

ACTIONS += build~config
BUILD_DEPS :=
BUILD_TARGET := sudo
$(ACTION)/build:
	@sudo bash auto/build
	@$(call done,build)

.PHONY: prepare
prepare: ;

.PHONY: count
count:
	@$(CLOC) $(shell $(GIT) ls-files)

.PHONY: start +start
start: ~format $(ISO_FILE)
	@$(MAKE) -s +start
+start:
	@sudo kvm -cdrom $(ISO_FILE) -m 2G -serial stdio
$(ISO_FILE): ~build

.PHONY: clean
clean: sudo
	-@$(call clean)
	-@sudo bash auto/clean
	-@sudo $(GIT) clean -fXd \
		-e $(BANG)cache \
		-e $(BANG)cache/ \
		-e $(BANG)cache/**/* $(NOFAIL)

.PHONY: purge
purge: clean
	-@sudo bash auto/clean --purge
	-@$(GIT) clean -fXd

.PHONY: test-lang
test-lang:
	@grep-dctrl -Ftest-lang $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: enhances
enhances:
	@grep-dctrl -FEnhances $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: layouts
layouts:
	@egrep -i '(^!|$(ARGS))' /usr/share/X11/xkb/rules/base.lst

FIX_PERMISSIONS_FILES := config config-overrides
.PHONY: fix-permissions
fix-permissions: sudo
	@sudo chown -R $$(stat -c '%u:%g' Makefile) $(FIX_PERMISSIONS_FILES)


.PHONY: fonts
fonts: config/includes.chroot/usr/share/fonts/*.ttf
config/includes.chroot/usr/share/fonts/*.ttf:
	@FONTS_DIR=$$(echo $@ | $(SED) 's|/[^/]*$$||g') && \
		mkdir -p $$FONTS_DIR && \
		cd $$FONTS_DIR && \
		for f in $$(cat $(CWD)/fonts.list | sed 's|^#.*||g'); do \
			curl -L -o fonts.zip $$f && \
			unzip fonts.zip && \
			rm -rf fonts.zip; \
		done

.PHONY: packages
packages: config/packages.chroot/*.deb
config/packages.chroot/*.deb:
	@DPKG_DIR=$$(echo $@ | $(SED) 's|/[^/]*$$||g') && \
		mkdir -p $$DPKG_DIR && \
		cd $$DPKG_DIR && \
		for p in $$(cat $(CWD)/packages.list | sed 's|^#.*||g'); do \
			curl -L -o package.deb $$p && \
			$(DPKG_NAME) -o package.deb; \
		done

.PHONY: clear-packages
clear-packages:
	@rm -rf config/packages.chroot/*.deb

.PHONY: reset-packages
reset-packages: clear-packages packages

.PHONY: trust-gpg-key
trust-gpg-key:
	@$(EXPORT_GPG_KEY) $(ARGS) config-overrides/archives/$(ARGS).key.chroot

-include $(patsubst %,$(_ACTIONS)/%,$(ACTIONS))

+%:
	@$(MAKE) -e -s $(shell echo $@ | $(SED) 's/^\+//g')

%: ;

CACHE_ENVS += \
	CLOC \
	CSPELL \
	LB 
