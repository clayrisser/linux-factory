# File: /Makefile
# Project: deb-distro
# File Created: 24-05-2022 13:11:50
# Author: Clay Risser
# -----
# Last Modified: 24-05-2022 13:26:10
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

ACTIONS += install ## install dependencies
$(ACTION)/install: $(PROJECT_ROOT)/pyproject.toml env
	@$(call poetry_install_dev,$(ARGS))
	@$(call done,install)

ACTIONS += lint ##
$(ACTION)/lint: $(call git_deps,\.(py)$$)
	@$(call black_lint,$?,$(ARGS))
	@$(call done,lint)

.PHONY: start
start: ~install ##
	@$(PYTHON) src/main.py $(ARGS)

.PHONY: clean
clean:
	@$(MKCHAIN_CLEAN)
	@$(GIT) clean -fXd \
		$(MKPM_GIT_CLEAN_FLAGS)

.PHONY: purge
purge: clean
	@$(GIT) clean -fXd

-include $(call actions)

endif
