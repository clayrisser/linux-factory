# File: /Makefile
# Project: deb-distro
# File Created: 09-01-2022 11:10:46
# Author: Clay Risser
# -----
# Last Modified: 13-01-2022 06:45:04
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

include mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/envcache

export OS_PATH := $(PROJECT_ROOT)/.os
export SCRIPTS_PATH := $(PROJECT_ROOT)/scripts

export CLOC ?= cloc
export CSPELL ?= cspell
export DPKG_NAME ?= dpkg-name
export EXPORT_GPG_KEY := sh $(SCRIPTS_PATH)/export-gpg-key.sh
export GIT_DOWNLOAD := sh $(SCRIPTS_PATH)/git-download.sh
export INSERT_CAT := node $(SCRIPTS_PATH)/insert-cat.js
export PARSE_CONFIG := sh $(SCRIPTS_PATH)/parse-config.sh
export TMPL := sh $(SCRIPTS_PATH)/tmpl.sh
export YQ ?= yq

.PHONY: root +root
root: | +root
+root:
	@$(RM) -rf $(OS_PATH) $(NOFAIL)
	@$(MKDIR) -p $(OS_PATH)
	@$(CD) root && \
		$(call tmpl,$(OS_PATH))

.PHONY: overlays +overlays
overlays: | root +overlays
+overlays:
	@$(RM) -rf $(PROJECT_ROOT)/.overlays
	@$(MKDIR) -p $(PROJECT_ROOT)/.overlays
	@for o in $(shell $(CAT) os/config.yaml | $(YQ) -r '.overlays | keys[]'); do \
		$(CP) -r $(PROJECT_ROOT)/overlays/$$o $(PROJECT_ROOT)/.overlays/$$o && \
		$(CD) $(PROJECT_ROOT)/.overlays/$$o && \
		$(call overlay_hook,pre) && \
		$(call tmpl_overlay,$(OS_PATH)) && \
		$(CD) $(PROJECT_ROOT)/.os && \
		$(call overlay_hook,post); \
	done

.PHONY: os +os
os: overlays +os
+os:
	@$(CD) os && \
		$(call tmpl,$(OS_PATH))
	@$(call parse_envs,$(PROJECT_ROOT)/os/config.yaml) > $(PROJECT_ROOT)/.os/.env

.PHONY: load +load
load: | os +load
+load:
	@$(MAKE) -sC .os load
	@for o in $(shell $(LS) $(PROJECT_ROOT)/.overlays); do \
		$(CD) $(PROJECT_ROOT)/lb && \
		$(call overlay_hook,lb); \
	done

.PHONY: build +build
build: | load +build
+build:
	@$(MAKE) -sC .os build

.PHONY: test-lang
test-lang: ##
	@grep-dctrl -Ftest-lang $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: enhances
enhances: ##
	@grep-dctrl -FEnhances $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: layouts
layouts: ##
	@egrep -i '(^!|$(ARGS))' /usr/share/X11/xkb/rules/base.lst

.PHONY: trust-gpg-key
trust-gpg-key: ##
	@$(EXPORT_GPG_KEY) $(ARGS) config-overrides/archives/$(ARGS).key.chroot

define overlay_hook
	if [ -f "$(PROJECT_ROOT)/.overlays/$$o/hooks/$1-overlay.sh" ]; then \
		( \
			(($(CAT) $(PROJECT_ROOT)/overlays/$$o/config.yaml $(NOFAIL)) | $(YQ)) && \
			(($(CAT) $(PROJECT_ROOT)/os/config.yaml $(NOFAIL)) | $(YQ) ".overlays.$$o") \
		) | $(JQ) -s '.[0]+.[1]' | env -i sh -c " \
			$(call inject_envs,') && \
			$(CAT) | $(PARSE_CONFIG) -e > $(MKPM_TMP)/overlay_hook_envs && \
			. $(MKPM_TMP)/overlay_hook_envs && \
			sh $(PROJECT_ROOT)/.overlays/$$o/hooks/$1-overlay.sh \
		"; \
	fi
endef

define tmpl
	(($(CAT) $(PROJECT_ROOT)/os/config.yaml $(NOFAIL)) | $(YQ)) | \
		$(call _tmpl,$1)
endef

define tmpl_overlay
	( \
		(($(CAT) $(PROJECT_ROOT)/overlays/$$o/config.yaml $(NOFAIL)) | $(YQ)) && \
		(($(CAT) $(PROJECT_ROOT)/os/config.yaml $(NOFAIL)) | $(YQ) ".overlays.$$o") \
	) | $(JQ) -s '.[0]+.[1]' | $(call _tmpl,$1)
endef

define _tmpl
env -i sh -c ' \
	$(call inject_envs,") && \
	$(CAT) | $(PARSE_CONFIG) -e > $(MKPM_TMP)/tmpl_envs && \
	. $(MKPM_TMP)/tmpl_envs && \
	for f in $$($(FIND) . -type f -printf "%p\n" | $(SED) "s|^\.\/||g"); do \
		$(MKDIR) -p $$($(ECHO) $1/$$f | $(SED) "s|/[^/]\+$$||g" $(NOFAIL)) && \
		if [ "$$($(ECHO) $$f | $(GREP) -oE "\.tmpl$$" $(NOFAIL))" = ".tmpl" ]; then \
			$(TMPL) $$f > $1/$$($(ECHO) $$f | $(SED) "s|\.tmpl$$||g"); \
		else \
			$(CP) $$f $1/$$f; \
		fi; \
	done \
'
endef

define inject_envs
	export INSERT_CAT=$1$(INSERT_CAT)$1
endef

define parse_envs
	(($(CAT) $1 $(NOFAIL)) | $(YQ)) | $(PARSE_CONFIG) $2
endef

CACHE_ENVS += \

endif
