# File: /mkpm.mk
# Project: mkgnu
# File Created: 03-10-2021 22:03:16
# Author: Clay Risser
# -----
# Last Modified: 26-11-2021 01:57:43
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

MKPM_PKG_NAME := gnu

MKPM_PKG_VERSION := 0.0.3

MKPM_PKG_DESCRIPTION := "add gnu commands to makefiles"

MKPM_PKG_AUTHOR := Clay Risser <clayrisser@gmail.com>

MKPM_PKG_SOURCE := https://gitlab.com/bitspur/community/mkgnu.git

MKPM_PKG_FILES_REGEX :=

MKPM_PACKAGES := \

MKPM_REPOS := \

############# MKPM BOOTSTRAP SCRIPT BEGIN #############
MKPM_BOOTSTRAP := https://bitspur.gitlab.io/community/mkpm/bootstrap.mk
NULL := /dev/null
TRUE := true
ifeq ($(OS),Windows_NT)
	NULL = nul
	TRUE = type nul
endif
-include .mkpm/.bootstrap.mk
.mkpm/.bootstrap.mk:
	@mkdir .mkpm 2>$(NULL) || $(TRUE)
	@cd .mkpm && \
		$(shell curl --version >$(NULL) 2>$(NULL) && \
			echo curl -L -o || \
			echo wget --content-on-error -O) \
		.bootstrap.mk $(MKPM_BOOTSTRAP) >$(NULL)
############## MKPM BOOTSTRAP SCRIPT END ##############
