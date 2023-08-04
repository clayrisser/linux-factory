# File: /main.mk
# Project: mkgnu
# File Created: 03-10-2021 22:03:16
# Author: Clay Risser
# -----
# Last Modified: 26-11-2021 01:56:27
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

ifneq ($(NIX_ENV),true)
	ifeq ($(PLATFORM),darwin)
		export FIND ?= $(call ternary,gfind --version,gfind,find)
		export GREP ?= $(call ternary,ggrep --version,ggrep,grep)
		export SED ?= $(call ternary,gsed --version,gsed,sed)
	endif
endif

export GIT ?= $(call ternary,git --version,git,true)
export AWK ?= awk
export GREP ?= grep
export JQ ?= jq
export READLINE ?= readline
export SED ?= sed
export TAR ?= tar
export TIME ?= time

# SHELL
export CD ?= cd
export DO ?= do
export DONE ?= done
export FI ?= fi
export FOR ?= for
export IF ?= if
export READ ?= read
export THEN ?= then
export WHILE ?= while

# COREUTILS
export BASENAME ?= basename
export CAT ?= cat
export CHMOD ?= chmod
export CHOWN ?= chown
export CHROOT ?= chroot
export COMM ?= comm
export CP ?= cp
export CUT ?= cut
export DATE ?= date
export DD ?= dd
export DF ?= df
export DIRNAME ?= dirname
export DU ?= du
export ECHO ?= echo
export ENV ?= env
export EXPAND ?= expand
export FALSE ?= false
export FMT ?= fmt
export FOLD ?= fold
export GROUPS ?= groups
export HEAD ?= head
export HOSTNAME ?= hostname
export ID ?= id
export JOIN ?= join
export LN ?= ln
export LS ?= ls
export MD5SUM ?= md5sum
export MKDIR ?= mkdir
export MV ?= mv
export NICE ?= nice
export PASTE ?= paste
export PR ?= pr
export PRINTF ?= printf
export PWD ?= pwd
export RM ?= rm
export RMDIR ?= rmdir
export SEQ ?= seq
export SLEEP ?= sleep
export SORT ?= sort
export SPLIT ?= split
export SU ?= su
export TAIL ?= tail
export TEE ?= tee
export TEST ?= test
export TOUCH ?= touch
export TR ?= tr
export TRUE ?= true
export UNAME ?= uname
export UNEXPAND ?= unexpand
export UNIQ ?= uniq
export WC ?= wc
export WHO ?= who
export WHOAMI ?= whoami
export YES ?= yes

# FINDUTILS
export FIND ?= find
export LOCATE ?= locate
export UPDATEDB ?= updatedb
export XARGS ?= xargs

# PROCPS
export KILL ?= kill
export PS ?= ps
export TOP ?= top

# INFOZIP
export ZIP ?= zip
export UNZIP ?= unzip

export GNU_READY ?= true
