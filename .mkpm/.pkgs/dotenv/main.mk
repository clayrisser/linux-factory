# File: /main.mk
# Project: mkpm-dotenv
# File Created: 06-01-2022 03:18:08
# Author: Clay Risser
# -----
# Last Modified: 08-04-2023 08:01:12
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

-include $(MKPM_TMP)/mkenv

DOTENV ?= $(CURDIR)/.env
DEFAULT_ENV ?= $(subst /.env,,$(DOTENV))/default.env

$(MKPM_TMP)/env: $(DOTENV)
	@$(MKDIR) -p $(@D)
	@$(CAT) $< | \
		$(SED) 's|^#.*||g' | \
		$(SED) '/^$$/d' | \
		$(SED) 's|^|export |' > $@
$(MKPM_TMP)/mkenv: $(MKPM_TMP)/env
	@$(MKDIR) -p $(@D)
	@$(CAT) $(MKPM_TMP)/env | $(SED) "s|^export \+\([^ =]\+\)=[\"']\?\(.*\)$$|export \1 ?= \2|g" | \
		$(SED) "s|[\"']$$||g" > $@
ifneq (,$(wildcard $(DEFAULT_ENV)))
$(DOTENV): $(DEFAULT_ENV)
	@if [ ! -f "$@" ] || [ "$<" -nt "$@" ]; then \
		$(CP) $< $@; \
	fi
else
$(DOTENV):
	@$(TOUCH) -m $@
endif
