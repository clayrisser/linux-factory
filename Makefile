# File: /Makefile
# Project: linux-factory
# File Created: 24-05-2022 13:11:50
# Author: Clay Risser
# -----
# Last Modified: 28-02-2023 09:39:02
# Modified By: Clay Risser
# -----
# Risser Labs LLC (c) Copyright 2021 - 2022
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
include $(MKPM)/mkchain
include $(MKPM)/envcache
include $(MKPM)/dotenv
include $(MKPM)/python

export EXPORT_GPG_KEY := sh $(SCRIPTS_PATH)/export-gpg-key.sh

CLOC ?= cloc

ACTIONS += install ## install dependencies
$(ACTION)/install: $(PROJECT_ROOT)/pyproject.toml env
	@$(call poetry_install_dev,$(ARGS))
	@$(call done,install)

ACTIONS += lint ##
$(ACTION)/lint: $(call git_deps,\.(py)$$)
	@$(call black_lint,$?,$(ARGS))
	@$(call done,lint)

.PHONY: build
build: sudo ~install ##
	@$(SUDO) $(PYTHON) src/main.py $(ARGS)

.PHONY: clean
clean: sudo
	@$(MKCHAIN_CLEAN)
	@$(SUDO) $(GIT) clean -fXd \
		$(MKPM_GIT_CLEAN_FLAGS)

.PHONY: purge
purge: clean
	@$(GIT) clean -fXd

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

.PHONY: count
count:
	@$(CLOC) $(shell $(GIT) ls-files | $(GREP) -v '^.gitattributes$$' | $(XARGS) git check-attr filter | \
		$(GREP) -v 'filter: lfs' | $(SED) 's|: filter: .*||g')

.PHONY: lb/%
lb/%:
	@$(MAKE) -sC .build/lb $(subst lb/,,$@) ARGS=$(ARGS)

-include $(call actions)

endif
