# File: /mkpm.mk
# Project: mkchain
# File Created: 27-09-2021 16:33:44
# Author: Clay Risser
# -----
# Last Modified: 22-06-2022 14:50:14
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

MKPM_PKG_NAME := envcache

MKPM_PKG_VERSION := 0.1.0

MKPM_PKG_DESCRIPTION := "cache calculated envs for faster load time"

MKPM_PKG_AUTHOR := Clay Risser <clayrisser@gmail.com>

MKPM_PKG_SOURCE := https://gitlab.com/risserlabs/community/envcache.git

MKPM_PKG_FILES_REGEX :=

export MKPM_PACKAGES_DEFAULT := \

export MKPM_REPO_DEFAULT := \

############# MKPM BOOTSTRAP SCRIPT BEGIN #############
MKPM_BOOTSTRAP := https://gitlab.com/api/v4/projects/29276259/packages/generic/mkpm/0.2.0/bootstrap.mk
export PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
NULL := /dev/null
TRUE := true
ifneq ($(patsubst %.exe,%,$(SHELL)),$(SHELL))
	NULL = nul
	TRUE = type nul
endif
-include $(PROJECT_ROOT)/.mkpm/.bootstrap.mk
$(PROJECT_ROOT)/.mkpm/.bootstrap.mk:
	@mkdir $(@D) 2>$(NULL) || $(TRUE)
	@$(shell curl --version >$(NULL) 2>$(NULL) && \
			echo curl -L -o || \
			echo wget --content-on-error -O) \
		$@ $(MKPM_BOOTSTRAP) >$(NULL)
############## MKPM BOOTSTRAP SCRIPT END ##############
