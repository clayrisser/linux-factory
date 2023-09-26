# File: /lb/Makefile
# Project: linux-factory
# File Created: 12-05-2023 06:06:17
# Author: Clay Risser
# -----
# BitSpur (c) Copyright 2021 - 2023
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

include $(MKPM)/mkpm
include $(MKPM)/gnu
include $(MKPM)/envcache
include $(MKPM)/chain
include $(MKPM)/dotenv

export ISO_FILE ?= \
	$(SYSTEM)-image-$(shell $(ECHO) $(DISTRIBUTION) | $(CUT) -d' ' -f1).hybrid.iso
export RSYNC ?= rsync
export CURL ?= curl

ACTIONS += config
CONFIG_TARGET := sudo
$(ACTION)/config: auto/config config-overrides ##
	@$(RM) -rf config
	@$(SUDO) bash auto/config
	@$(MAKE) -s fix-permissions
	@for d in $$(ls config-overrides); do \
		$(MKDIR) -p config/$$d && \
		if [ "$$($(ECHO) $$d | $(SED) 's|\..*||g')" = "includes" ]; then \
			$(RSYNC) -a config-overrides/$$d/ config/$$d/; \
		else \
			$(RSYNC) -a --exclude=".*" config-overrides/$$d/ config/$$d/; \
		fi; \
	done
	@$(call done,$@)

ACTIONS += build~config
BUILD_TARGET := sudo
$(ACTION)/build: ##
	@$(SUDO) bash auto/build
	@$(CAT) build.log | $(TAIL) -n1 | $(GREP) -q 'P: Build completed successfully'
	@$(call done,$@)

$(ISO_FILE): ~build
.PHONY: start +start
start: | sudo $(ISO_FILE) +start ##
+start:
	@$(SUDO) kvm -cdrom $(ISO_FILE) -m 2G -serial stdio

FIX_PERMISSIONS_FILES := config config-overrides
.PHONY: fix-permissions
fix-permissions: sudo ##
	@$(SUDO) chown -R $$(stat -c '%u:%g' Makefile) $(FIX_PERMISSIONS_FILES)

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

-include $(call chain)

CACHE_ENVS += \
