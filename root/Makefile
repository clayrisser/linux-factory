# File: /Makefile
# Project: root
# File Created: 10-01-2022 04:56:09
# Author: Clay Risser
# -----
# Last Modified: 13-01-2022 07:55:37
# Modified By: Clay Risser
# -----
# BitSpur Inc (c) Copyright 2021 - 2022
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include ../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/envcache
include $(MKPM)/dotenv

LB_PATH=$(PROJECT_ROOT)/lb
SCRIPTS_PATH=$(PROJECT_ROOT)/scripts

export DPKG_NAME ?= dpkg-name
export NODE ?= node
export RSYNC ?= rsync
export YQ ?= yq
export CLEAN_PACKAGES ?= $(NODE) -e 'require("$(SCRIPTS_PATH)/packages.js").clean()'
export CLEAN_REPOS ?= $(NODE) -e 'require("$(SCRIPTS_PATH)/repos.js").clean()'
export LOAD_PACKAGES ?= $(NODE) -e 'require("$(SCRIPTS_PATH)/packages.js").load()'
export LOAD_REPOS ?= $(NODE) -e 'require("$(SCRIPTS_PATH)/repos.js").load()'

NAME ?= DEB Distro
WEBSITE ?= https://bitspur.com
EMAIL ?= email@bitspur.com
ARCHITECTURES ?= $(ARCH)
LOCALE ?= en_US
KEYBOARD_LAYOUT ?= us
MIRROR ?= http://deb.debian.org/debian/
MIRROR_SECURITY ?= http://security.debian.org/
DISTRIBUTION ?= bullseye
ifeq ($(DISTRIBUTION),bullseye)
	SECURITY ?= false
endif
SECURITY ?= true
ifeq ($(ARCH),i386)
	LINUX_FLAVOURS ?= 686-pae
endif
LINUX_FLAVOURS ?= $(ARCH)
KERNEL_VERSION ?=
ifneq (,$(KERNEL_VERSION))
	LINUX_PACKAGES ?= linux-image-$(KERNEL_VERSION) linux-headers-$(KERNEL_VERSION)
endif
LINUX_PACKAGES ?= linux-image linux-headers
APT ?= apt
APT_INDICES ?= true
APT_OPTIONS ?= -y
APT_RECOMMENDS ?= true
APT_SOURCE_ARCHIVES ?= true
ARCHITECTURES ?= $(ARCHITECTURES)
ARCHIVE_AREAS ?= main contrib non-free
BACKPORTS ?= true
BINARY_IMAGES ?= iso-hybrid
BOOTAPPEND_LIVE ?= boot=live components username=live locales=$(LOCALE).UTF-8 keyboard-layouts=$(KEYBOARD_LAYOUT)
CACHE ?= true
CHECKSUMS ?= sha256
DEBIAN_INSTALLER ?= netinst
DEBIAN_INSTALLER_GUI ?= true
DEBOOTSTRAP_OPTIONS ?= --include=apt-transport-https,ca-certificates,openssl
DEBUG ?= true
INITSYSTEM ?= systemd
ISO_APPLIECHOION ?= $(NAME)
ISO_PUBLISHER ?= $(NAME); $(WEBSITE); $(EMAIL)
ISO_VOLUME ?= $(NAME)
MIRROR_BOOTSTRAP ?= $(MIRROR)
MIRROR_DEBIAN_INSTALLER ?= $(MIRROR)
MODE ?= debian
PARENT_DEBIAN_INSTALLER_DISTRIBUTION ?= $(DISTRIBUTION)
PARENT_DISTRIBUTION ?= $(DISTRIBUTION)
PARENT_MIRROR_CHROOT ?= $(MIRROR)
PARENT_MIRROR_CHROOT_SECURITY ?= $(MIRROR_SECURITY)
SYSTEM ?= live
UPDATES ?= true
WIN32_LOADER ?= true

.PHONY: env
env:
	@$(RM) $(LB_PATH)/.env $(NOFAIL)
	@$(ECHO) 'APT=$(APT)' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_INDICES=$(APT_INDICES)' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_OPTIONS=$(APT_OPTIONS)' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_RECOMMENDS=$(APT_RECOMMENDS)' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_SOURCE_ARCHIVES=$(APT_SOURCE_ARCHIVES)' >> $(LB_PATH)/.env
	@$(ECHO) 'ARCHITECTURES=$(ARCHITECTURES)' >> $(LB_PATH)/.env
	@$(ECHO) 'ARCHIVE_AREAS=$(ARCHIVE_AREAS)' >> $(LB_PATH)/.env
	@$(ECHO) 'BACKPORTS=$(BACKPORTS)' >> $(LB_PATH)/.env
	@$(ECHO) 'BINARY_IMAGES=$(BINARY_IMAGES)' >> $(LB_PATH)/.env
	@$(ECHO) 'BOOTAPPEND_LIVE=$(BOOTAPPEND_LIVE)' >> $(LB_PATH)/.env
	@$(ECHO) 'CACHE=$(CACHE)' >> $(LB_PATH)/.env
	@$(ECHO) 'CHECKSUMS=$(CHECKSUMS)' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBIAN_INSTALLER=$(DEBIAN_INSTALLER)' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBIAN_INSTALLER_GUI=$(DEBIAN_INSTALLER_GUI)' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBOOTSTRAP_OPTIONS=$(DEBOOTSTRAP_OPTIONS)' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBUG=$(DEBUG)' >> $(LB_PATH)/.env
	@$(ECHO) 'DISTRIBUTION=$(DISTRIBUTION)' >> $(LB_PATH)/.env
	@$(ECHO) 'INITSYSTEM=$(INITSYSTEM)' >> $(LB_PATH)/.env
	@$(ECHO) 'ISO_APPLICATION=$(ISO_APPLICATION)' >> $(LB_PATH)/.env
	@$(ECHO) 'ISO_PUBLISHER=$(ISO_PUBLISHER)' >> $(LB_PATH)/.env
	@$(ECHO) 'ISO_VOLUME=$(ISO_VOLUME)' >> $(LB_PATH)/.env
	@$(ECHO) 'LINUX_FLAVOURS=$(LINUX_FLAVOURS)' >> $(LB_PATH)/.env
	@$(ECHO) 'LINUX_PACKAGES=$(LINUX_PACKAGES)' >> $(LB_PATH)/.env
	@$(ECHO) 'MIRROR_BOOTSTRAP=$(MIRROR_BOOTSTRAP)' >> $(LB_PATH)/.env
	@$(ECHO) 'MIRROR_DEBIAN_INSTALLER=$(MIRROR_DEBIAN_INSTALLER)' >> $(LB_PATH)/.env
	@$(ECHO) 'MODE=$(MODE)' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_DEBIAN_INSTALLER_DISTRIBUTION=$(PARENT_DEBIAN_INSTALLER_DISTRIBUTION)' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_DISTRIBUTION=$(PARENT_DISTRIBUTION)' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_MIRROR_CHROOT=$(PARENT_MIRROR_CHROOT)' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_MIRROR_CHROOT_SECURITY=$(PARENT_MIRROR_CHROOT_SECURITY)' >> $(LB_PATH)/.env
	@$(ECHO) 'SECURITY=$(SECURITY)' >> $(LB_PATH)/.env
	@$(ECHO) 'SYSTEM=$(SYSTEM)' >> $(LB_PATH)/.env
	@$(ECHO) 'UPDATES=$(UPDATES)' >> $(LB_PATH)/.env
	@$(ECHO) 'WIN32_LOADER=$(WIN32_LOADER)' >> $(LB_PATH)/.env

.PHONY: config
config: env
	@$(MAKE) -sC $(LB_PATH) config

DEBS := $(shell ls packages/*.deb $(NOFAIL))
PACKAGES := $(shell ls packages/*.yaml $(NOFAIL))
.PHONY: load-packages
load-packages:
	@$(CLEAN_PACKAGES)
	@for p in $(PACKAGES); do \
		$(CAT) $$p | $(YQ) | $(LOAD_PACKAGES); \
	done
	@$(RM) -rf $(MKPM_TMP)/debs
	@$(MKDIR) -p $(MKPM_TMP)/debs
	@for d in $(DEBS); do \
		export MOVED_PATH=$$( \
			eval $(ECHO) $$( \
				$(DPKG_NAME) -s $(MKPM_TMP)/debs -o $$d | \
				$(SED) 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | \
				$(SED) 's|dpkg-name:\s.\+moved\s.\+\sto\s||g' \
			) \
		) && \
		$(CP) $$MOVED_PATH $$d && \
		$(ECHO) loaded package $$($(ECHO) $$MOVED_PATH | \
			$(GREP) -oE '[^/]+$$' | $(GREP) -oE '^[^_]+'); \
	done

REPOS := $(shell ls repos/*.yaml $(NOFAIL))
.PHONY: load-repos
load-repos:
	$(CLEAN_REPOS)
	@for p in $(REPOS); do \
		$(CAT) $$p | $(YQ) | $(LOAD_REPOS); \
	done

.PHONY: load-filesystem
load-filesystem:
	@$(RSYNC) -a filesystem/binary/ $(LB_PATH)/config/includes.binary/ $(NOFAIL)
	@$(RSYNC) -a filesystem/live/ filesystem/live_installed/ filesystem/installed_live/ \
		$(LB_PATH)/config/includes.chroot/ $(NOFAIL)
	$(MKDIR) -p $(LB_PATH)/config/includes.installer/root/install/filesystem
	@$(RSYNC) -a filesystem/installed/ filesystem/live_installed/ filesystem/installed_live/ \
		$(LB_PATH)/config/includes.installer/root/install/filesystem $(NOFAIL)
	@$(MKDIR) -p $(LB_PATH)/config/includes.chroot/root/install/filesystem
	@$(RSYNC) -a filesystem/installed/ filesystem/live_installed/ filesystem/installed_live/ \
		$(LB_PATH)/config/includes.chroot/root/install/filesystem $(NOFAIL)

.PHONY: load-lb
load-lb:
	@$(RSYNC) -a lb/ $(LB_PATH)/config/ $(NOFAIL)

.PHONY: load
load: | config load-packages load-repos load-filesystem load-lb

.PHONY: build +build
build: | load +build
+build:
	@$(MAKE) -sC $(LB_PATH) +build

.PHONY: clean
clean: sudo
	@$(MAKE) -sC $(LB_PATH) clean

.PHONY: purge
purge: sudo clean
	@$(SUDO) $(GIT) clean -fXd

endif
