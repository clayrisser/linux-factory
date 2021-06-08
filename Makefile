export MAKE_CACHE := $(shell pwd)/.make
export PARENT := true
include blackmagic.mk

LB := sudo lb
CLOC := node_modules/.bin/cloc
CSPELL := cspell
ISO_FILE := live-image-amd64.hybrid.iso

.PHONY: all
all: build

.PHONY: sudo
sudo:
	@sudo true

ACTIONS += config
CONFIG_DEPS := auto/config
CONFIG_TARGET := sudo
$(ACTION)/config:
	@$(LB) config
	@$(MAKE) -s fix-permissions
	@$(call done,config)

ACTIONS += build~config
BUILD_DEPS :=
BUILD_TARGET := sudo
$(ACTION)/build:
	@$(LB) build
	@$(call done,build)

.PHONY: prepare
prepare: ;

.PHONY: count
count:
	@$(CLOC) $(shell $(GIT) ls-files)

.PHONY: start +start
start: ~format $(ISO_FILE)
	@$(MAKE) -s +start
+start:
	@sudo kvm -cdrom $(ISO_FILE) -m 2G -serial stdio
$(ISO_FILE): ~build

.PHONY: clean
clean: sudo
	-@$(call clean)
	-@$(LB) clean
	-@sudo $(GIT) clean -fXd $(NOFAIL)

.PHONY: purge
purge: clean
	-@$(GIT) clean -fXd

.PHONY: reset
reset: purge
	-@sudo rm -rf config local $(NOFAIL)

.PHONY: test-lang
test-lang:
	@grep-dctrl -Ftest-lang $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: enhances
enhances:
	@grep-dctrl -FEnhances $(ARGS) /usr/share/tasksel/descs/debian-tasks.desc -sTask

.PHONY: layouts
layouts:
	@egrep -i '(^!|$(ARGS))' /usr/share/X11/xkb/rules/base.lst

FIX_PERMISSIONS_FILES := config
.PHONY: fix-permissions
fix-permissions: sudo
	@sudo chown -R $$(stat -c '%u:%g' Makefile) $(FIX_PERMISSIONS_FILES)

-include $(patsubst %,$(_ACTIONS)/%,$(ACTIONS))

+%:
	@$(MAKE) -e -s $(shell echo $@ | $(SED) 's/^\+//g')

%: ;

CACHE_ENVS += \
	CLOC \
	CSPELL \
	LB 
