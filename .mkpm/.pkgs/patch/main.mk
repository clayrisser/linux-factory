# File: /main.mk
# Project: mkpm-patch
# File Created: 27-12-2021 00:29:41
# Author: Clay Risser
# -----
# Last Modified: 10-06-2023 12:33:37
# Modified By: Clay Risser
# -----
# BitSpur Inc (c) Copyright 2021
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

export PATCHES ?=
export PATCHES_DIR ?= patches

export DIFF ?= diff
export PATCH ?= patch

export PATCHES_TMP := $(addsuffix .tmp,$(PATCHES))
export PATCHES_PATCH := $(addprefix patches/,$(addsuffix .patch,$(PATCHES)))

export TMPDIR := /tmp

.PHONY: patch-apply
patch-apply: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		[ -f "$(PATCHES_DIR)/$${f}.patch" ] && \
		$(CAT) "$(PATCHES_DIR)/$${f}.patch" | $(PATCH) -p0 -N -r$(NULL) || $(TRUE); \
	done

.PHONY: patch-revert
patch-revert: $(PATCHES) $(PATCHES_PATCH)
	@for f in $(PATCHES); do \
		[ -f "$(PATCHES_DIR)/$${f}.patch" ] && \
		$(CAT) "$(PATCHES_DIR)/$${f}.patch" | $(PATCH) -p0 -N -r$(NULL) -R || $(TRUE); \
	done

.PHONY: patch-build
patch-build: patch-revert $(PATCHES_TMP)
	@for f in $(PATCHES); do \
		$(MKDIR) -p "$$($(ECHO) "$(PATCHES_DIR)/$${f}.patch" | $(SED) 's|[\\\\/][^\\\/]*$$||g')" && \
		$(DIFF) -Naur "$$f" "$${f}.tmp" > "$(PATCHES_DIR)/$${f}.patch" || $(TRUE); \
	done
.PHONY: patch-build-prepare
patch-build-prepare: | patch-apply $(PATCHES_TMP) patch-revert
$(PATCHES_TMP):
	@$(CP) $(patsubst %.tmp,%,$@) $@
.SECONDEXPANSION:
$(PATCHES_PATCH): ;

.PHONY: patch-build-clear
patch-build-clear: $(PATCHES_TMP) $(PATCHES_PATCH)
	@$(RM) -rf $^ || $(TRUE)

.PHONY: patch-build-reset
patch-build-reset: patch-build-clear
	@$(MAKE) -s patch-build
