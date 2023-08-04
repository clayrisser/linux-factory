# File: /main.mk
# Project: mkchain
# File Created: 26-09-2021 16:53:36
# Author: Clay Risser
# -----
# Last Modified: 10-04-2023 18:36:34
# Modified By: Clay Risser
# -----
# Risser Labs LLC (c) Copyright 2021
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
# -----
#
# the magic of this makefile consists of functions and macros
# used to create complex cached dependency chains that track
# changes on individual files and works across unix environments
#
# for example, this can be used to format the code and run tests
# against only the files that updated
#
# this significantly increases the speed of builds and development in a
# language and ecosystem agnostic way without sacrificing enforcement of
# critical scripts and jobs

.NOTPARALLEL:

_MKCACHE_CACHE ?= $(MKPM_TMP)/mkchain
_ACTIONS := $(_MKCACHE_CACHE)/actions
_DONE := $(_MKCACHE_CACHE)/done
ACTION := $(_DONE)

export GIT ?= $(call ternary,git --version,git,true)

IS_PROJECT_ROOT := false
ifeq ($(ROOT),$(PROJECT_ROOT))
	IS_PROJECT_ROOT := true
endif

export MKCACHE_CLEAN := $(RM) -rf $(_MKCACHE_CACHE) $(NOFAIL)

define done
$(TOUCH) -m $(_DONE)/$1
endef

define cache
$(MKDIR) -p $(shell echo $1 | $(SED) 's|\/[^\/]*$$||g') && \
	$(TOUCH) -m $1
endef

define git_deps
$(shell ($(GIT) ls-files && ($(GIT) lfs ls-files | $(CUT) -d' ' -f3)) | $(SORT) | $(UNIQ) -u | $(GREP) -E "$1" $(NOFAIL))
endef

define _ACTION_TEMPLATE
.PHONY: {{ACTION}} +{{ACTION}} _{{ACTION}} ~{{ACTION}}
.DELETE_ON_ERROR: $$(ACTION)/{{ACTION}}
{{ACTION}}: _{{ACTION}} ~{{ACTION}}
~{{ACTION}}: | {{ACTION_DEPENDENCY}} $$({{ACTION_UPPER}}_TARGETS) $$(ACTION)/{{ACTION}}
+{{ACTION}}: | _{{ACTION}} $$({{ACTION_UPPER}}_TARGETS) $$(ACTION)/{{ACTION}}
_{{ACTION}}:
	@$$(RM) -rf $$(_DONE)/{{ACTION}}
endef
export _ACTION_TEMPLATE

define actions
$(patsubst %,$(_ACTIONS)/%,$(ACTIONS))
endef

define reset
$(MAKE) -s _$1 && \
$(RM) -rf $(ACTION)/$1 $(NOFAIL)
endef

.PHONY: $(_ACTIONS)/%
$(_ACTIONS)/%:
	@$(MKDIR) -p $(@D)
ifeq ($(patsubst %.exe,%,$(SHELL)),$(SHELL))
	@ACTION_BLOCK=$(shell $(ECHO) $@ | $(GREP) -oE "[^\/]+$$") && \
		ACTION=$$($(ECHO) $$ACTION_BLOCK | $(GREP) -oE "^[^~]+") && \
		ACTION_DEPENDENCY=$$($(ECHO) $$ACTION_BLOCK | $(GREP) -Eo "~[^~]+$$" $(NOFAIL)) && \
		SUB_ACTION_DEPENDENCY=$$([ "$$ACTION_DEPENDENCY" = "" ] && $(ECHO) "" || $(ECHO) "sub_$$ACTION_DEPENDENCY") && \
		ACTION_UPPER=$$($(ECHO) $$ACTION | $(TR) '[:lower:]' '[:upper:]') && \
		$(ECHO) "$${_ACTION_TEMPLATE}" | $(SED) "s|{{ACTION}}|$${ACTION}|g" | \
		$(SED) "s|{{ACTION_DEPENDENCY}}|$${ACTION_DEPENDENCY}|g" | \
		$(SED) "s|{{SUB_ACTION_DEPENDENCY}}|$${SUB_ACTION_DEPENDENCY}|g" | \
		$(SED) "s|{{ACTION_UPPER}}|$${ACTION_UPPER}|g" > $@
endif

-include $(_DONE)/_
$(_DONE)/_:
	@$(MKDIR) -p $(@D)
	@$(TOUCH) $@

.PHONY: +%
+%:
	@$(MAKE) -s $(shell echo $@ | $(SED) 's|^\+||g')

HELP_PREFIX ?=
HELP_SPACING ?= 32
export MKCHAIN_HELP := _mkchain_help
$(MKCHAIN_HELP):
ifeq ($(patsubst %.exe,%,$(SHELL)),$(SHELL))
	@$(MAKE) -s $(MKPM_HELP) $(NOFAIL)
	@$(CAT) $(CURDIR)/Makefile | \
		$(GREP) -E '^ACTIONS\s+\+=\s+[a-zA-Z0-9].*##' | \
		$(SED) 's|^ACTIONS\s\++=\s\+||g' | \
		$(SED) 's|~[^ 	]\+||' | \
		$(SORT) | \
		$(UNIQ) | \
		$(AWK) 'BEGIN {FS = "[ 	]+##[ 	]*"}; {printf "\033[36m%-$(HELP_SPACING)s  \033[0m%s\n", "$(HELP_PREFIX)"$$1, $$2}'
endif

ifeq ($(MKPM_HELP),$(HELP))
HELP = $(MKCHAIN_HELP)
endif
ifeq ($(MKPM_HELP),$(.DEFAULT_GOAL))
.DEFAULT_GOAL = $(MKCHAIN_HELP)
endif
