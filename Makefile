export MAKE_CACHE := $(shell pwd)/.make
export PARENT := true
include blackmagic.mk

CLOC ?= cloc
CSPELL ?= cspell
DPKG_NAME ?= dpkg-name
ISO_FILE ?= live-image-amd64.hybrid.iso

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
	@$(MAKE) -s calamares
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

.PHONY: calamares
calamares: config/includes.chroot/etc/calamares/settings.conf \
	config/includes.chroot/usr/lib/calamares/modules/bootloader-config/module.desc
config/includes.chroot/etc/calamares/settings.conf: calamares-settings-debian/COPYING
	@mkdir -p config/includes.chroot/etc
	@cp -r calamares-settings-debian/calamares config/includes.chroot/etc/calamares
config/includes.chroot/usr/lib/calamares/modules/bootloader-config/module.desc: calamares-settings-debian/COPYING
	@mkdir -p config/includes.chroot/usr/lib/calamares
	@cp -r calamares-settings-debian/calamares-modules \
		config/includes.chroot/usr/lib/calamares/modules

.PHONY: submodules
submodules: calamares-settings-debian/COPYING
calamares-settings-debian/COPYING:
	@$(GIT) submodule update --init --recursive --remote
	@cd calamares-settings-debian && git checkout 11.0.4

.PHONY: packages
packages: config/packages.chroot/*.deb
config/packages.chroot/*.deb:
	@mkdir -p $$(echo $@ | $(SED) 's|/[^/]*$$||g')
	@for p in $$(cat packages.list | sed 's|^#.*||g'); do \
		cd config/packages.chroot && \
		curl -L -o package.deb $$p && \
		$(DPKG_NAME) -o package.deb && \
		cd ../..; \
	done

.PHONY: clear-packages
clear-packages:
	@rm -rf config/packages.chroot/*.deb

.PHONY: reset-packages
reset-packages: clear-packages packages

-include $(patsubst %,$(_ACTIONS)/%,$(ACTIONS))

+%:
	@$(MAKE) -e -s $(shell echo $@ | $(SED) 's/^\+//g')

%: ;

CACHE_ENVS += \
	CLOC \
	CSPELL \
	LB 
