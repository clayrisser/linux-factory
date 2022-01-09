include ../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/mkchain
include $(MKPM)/dotenv
include upstream.mk

export CLOC ?= cloc
export CSPELL ?= cspell
export DPKG_NAME ?= dpkg-name
export ISO_FILE ?= live-image-amd64.hybrid.iso
export EXPORT_GPG_KEY := sh $(PROJECT_ROOT)/export-gpg-key.sh

export RSYNC ?= rsync
export CURL ?= curl

ACTIONS += upstream
$(ACTION)/upstream: $(UPSTREAMS) ##

ACTIONS += patch~upstream
$(ACTION)/patch: $(PATCHES) ##
	@$(MAKE) -s patch-apply

ACTIONS += config~patch
CONFIG_TARGET := sudo
$(ACTION)/config: auto/config config-overrides ##
	@sudo bash auto/config
	@$(MAKE) -s fix-permissions
	@$(MAKE) -s packages
	@$(MAKE) -s fonts
	@for d in $$(ls config-overrides); do \
		$(MKDIR) -p config/$$d && \
		if [ "$$($(ECHO) $$d | $(SED) 's|\..*||g')" = "includes" ]; then \
			$(RSYNC) -a config-overrides/$$d/ config/$$d/; \
		else \
			$(RSYNC) -a --exclude=".*" config-overrides/$$d/ config/$$d/; \
		fi; \
	done
	@$(call done,config)

ACTIONS += build~config
BUILD_TARGET := sudo
$(ACTION)/build: ##
	@$(SUDO) bash auto/build
	@$(call done,build)

.PHONY: count
count: ## count lines of code
	@$(CLOC) $(shell $(GIT) ls-files)

.PHONY: start +start
start: $(ISO_FILE) ##
	@$(MAKE) -s +start
+start:
	@$(SUDO) kvm -cdrom $(ISO_FILE) -m 2G -serial stdio
$(ISO_FILE): ~build

.PHONY: clean
clean: sudo ##
	-@$(MKCACHE_CLEAN)
	-@$(SUDO) bash auto/clean
	-@$(SUDO) $(GIT) clean -fXd \
		$(MKPM_GIT_CLEAN_FLAGS) \
		$(call git_clean_flags,cache) \
		$(NOFAIL)

.PHONY: purge
purge: clean ##
	-@$(SUDO) bash auto/clean --purge
	-@$(GIT) clean -fXd

.PHONY: test-lang
test-lang: ##
	@grep-dctrl -Ftest-lang $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: enhances
enhances: ##
	@grep-dctrl -FEnhances $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: layouts
layouts: ##
	@egrep -i '(^!|$(ARGS))' /usr/share/X11/xkb/rules/base.lst

FIX_PERMISSIONS_FILES := config config-overrides
.PHONY: fix-permissions
fix-permissions: sudo ##
	@$(SUDO) chown -R $$(stat -c '%u:%g' Makefile) $(FIX_PERMISSIONS_FILES)

.PHONY: fonts
fonts: config/includes.chroot/usr/share/fonts/*.ttf ##
config/includes.chroot/usr/share/fonts/*.ttf:
	@FONTS_DIR=$$($(ECHO) $@ | $(SED) 's|/[^/]*$$||g') && \
		$(MKDIR) -p $$FONTS_DIR && \
		$(CD) $$FONTS_DIR && \
		for f in $$(cat $(PROJECT_ROOT)/fonts.list | sed 's|^#.*||g'); do \
			$(CURL) -L -o fonts.zip $$f && \
			$(UNZIP) fonts.zip && \
			$(RM) -rf fonts.zip; \
		done

.PHONY: packages
packages: config/packages.chroot/*.deb ##
config/packages.chroot/*.deb:
	@DPKG_DIR=$$(echo $@ | $(SED) 's|/[^/]*$$||g') && \
		$(MKDIR) -p $$DPKG_DIR && \
		$(CD) $$DPKG_DIR && \
		for p in $$(cat $(PROJECT_ROOT)/packages.list | sed 's|^#.*||g'); do \
			$(CURL) -L -o package.deb $$p && \
			$(DPKG_NAME) -o package.deb; \
		done

.PHONY: clear-packages
clear-packages: ##
	@rm -rf config/packages.chroot/*.deb

.PHONY: reset-packages
reset-packages: clear-packages packages ##

.PHONY: trust-gpg-key
trust-gpg-key: ##
	@$(EXPORT_GPG_KEY) $(ARGS) config-overrides/archives/$(ARGS).key.chroot

-include $(call actions)

CACHE_ENVS += \
	CLOC \
	CSPELL \
	LB 

endif
