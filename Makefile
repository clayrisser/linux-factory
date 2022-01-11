# File: /Makefile
# Project: deb-distro
# File Created: 09-01-2022 11:10:46
# Author: Clay Risser
# -----
# Last Modified: 11-01-2022 07:40:31
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
export EXPORT_GPG_KEY := sh $(SCRIPTS_PATH)/export-gpg-key.sh
export GIT_DOWNLOAD := sh $(SCRIPTS_PATH)/git-download.sh
export TMPL := sh $(SCRIPTS_PATH)/tmpl.sh

.PHONY: root
root:
	@$(RM) -rf $(OS_PATH) $(NOFAIL)
	@$(MKDIR) -p $(OS_PATH)
	@$(CD) root && \
		$(call tmpl,$(OS_PATH))

.PHONY: overlays
overlays: root
# @for o in $(shell $(LS) $(MKPM_TMP)/overlays $(NOFAIL)); do \
# 	$(CD) $(MKPM_TMP)/overlays/$$o && \
# 		$(call tmpl,$(OS_PATH)); \
# done
	@for o in $(shell $(LS) overlays); do \
		if ($(ECHO) ' $(OVERLAYS) ' | $(GREP) "\s$$o\s" $(NOOUT)); then \
			$(CD) $(PROJECT_ROOT)/overlays/$$o && \
				$(call tmpl,$(OS_PATH)); \
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


define tmpl
	for f in $$($(FIND) . -type f -printf "%p\n" | $(SED) 's|^\.\/||g'); do \
		if [ "$2" != "" ]; then \
			for i in $2; do \
				if [ "$$f" = "$$i" ]; then \
					IGNORE=1; \
				fi; \
			done; \
		fi; \
		if [ "$$IGNORE" != "1" ]; then \
			$(MKDIR) -p $$($(ECHO) $1/$$f | $(SED) 's|\/[^\/]\+$$||g' $(NOFAIL)) && \
			if [ "$$($(ECHO) $$f | $(GREP) -oE '\.tmpl$$' $(NOFAIL))" = ".tmpl" ]; then \
				$(TMPL) $$f > $1/$$($(ECHO) $$f | $(SED) 's|\.tmpl$$||g'); \
			else \
				$(CP) $$f $1/$$f; \
			fi; \
		fi; \
	done
endef

CACHE_ENVS += \

endif
