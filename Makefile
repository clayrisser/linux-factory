# File: /Makefile
# Project: deb-distro
# File Created: 09-01-2022 11:10:46
# Author: Clay Risser
# -----
# Last Modified: 11-01-2022 14:40:16
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
include os/config.mk

export OS_PATH := $(PROJECT_ROOT)/.os
export SCRIPTS_PATH := $(PROJECT_ROOT)/scripts

export CLOC ?= cloc
export CSPELL ?= cspell
export DPKG_NAME ?= dpkg-name
export YQ ?= yq
export EXPORT_GPG_KEY := sh $(SCRIPTS_PATH)/export-gpg-key.sh
export GIT_DOWNLOAD := sh $(SCRIPTS_PATH)/git-download.sh
export PARSE_CONFIG := sh $(SCRIPTS_PATH)/parse-config.sh
export TMPL := sh $(SCRIPTS_PATH)/tmpl.sh

.PHONY: root
root:
	@$(RM) -rf $(OS_PATH) $(NOFAIL)
	@$(MKDIR) -p $(OS_PATH)
	@$(CD) root && \
		$(call tmpl,$(OS_PATH))

.PHONY: overlays
overlays: | root +overlays
+overlays:
	@$(RM) -rf $(PROJECT_ROOT)/.overlays
	@$(MKDIR) -p $(PROJECT_ROOT)/.overlays
	@for o in $(shell $(CAT) os/config.yaml | $(YQ) -r '.overlays | keys[]'); do \
		$(CP) -r $(PROJECT_ROOT)/overlays/$$o $(PROJECT_ROOT)/.overlays/$$o && \
		$(CD) $(PROJECT_ROOT)/.overlays/$$o && \
		if [ -f "$(PROJECT_ROOT)/.overlays/$$o/hooks/pre_overlay.sh" ]; then \
			$(call overlay_hook,pre); \
		fi && \
		$(call tmpl,$(OS_PATH),$(PROJECT_ROOT)/overlays/$$o/config.yaml) && \
		if [ -f "$(PROJECT_ROOT)/.overlays/$$o/hooks/post_overlay.sh" ]; then \
			$(CD) $(PROJECT_ROOT)/.os && \
			$(call overlay_hook,post); \
		fi; \
	done

.PHONY: os
os: overlays
	@$(CD) os && \
		$(call tmpl,$(OS_PATH))

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
	([ "$(PROJECT_ROOT)/overlays/$$o/config.yaml" = "" ] && $(TRUE) || \
		($(CAT) $(PROJECT_ROOT)/overlays/$$o/config.yaml $(NOFAIL))) | $(YQ) | env -i sh -c " \
		$(CAT) | $(PARSE_CONFIG) > $(MKPM_TMP)/overlay_hook_envs && \
		. $(MKPM_TMP)/overlay_hook_envs && \
		sh $(PROJECT_ROOT)/.overlays/$$o/hooks/$1_overlay.sh \
	"
endef

define tmpl
	([ "$2" = "" ] && $(TRUE) || ($(CAT) $2 $(NOFAIL))) | $(YQ) | env -i sh -c ' \
		$(CAT) | $(PARSE_CONFIG) > $(MKPM_TMP)/tmpl_envs && \
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

CACHE_ENVS += \

endif
