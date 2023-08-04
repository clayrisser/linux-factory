# File: /mkpm.mk
# Project: mkpm-python
# File Created: 10-02-2022 10:21:38
# Author: Clay Risser
# -----
# Last Modified: 28-02-2023 08:30:11
# Modified By: Clay Risser
# -----
# Risser Labs (c) Copyright 2022
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

MKPM_PKG_NAME := python

MKPM_PKG_VERSION := 0.0.4

MKPM_PKG_DESCRIPTION := "manage python projects"

MKPM_PKG_AUTHOR := Clay Risser <clayrisser@gmail.com>

MKPM_PKG_SOURCE := https://gitlab.com/risserlabs/community/mkpm-python.git

MKPM_PKG_FILES_REGEX :=

MKPM_PACKAGES := \
	gnu=0.0.3

MKPM_REPOS := \
	https://gitlab.com/risserlabs/community/mkpm-stable.git

############# MKPM BOOTSTRAP SCRIPT BEGIN #############
MKPM_BOOTSTRAP := https://risserlabs.gitlab.io/community/mkpm/bootstrap.mk
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
