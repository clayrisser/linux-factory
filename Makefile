export MAKE_CACHE := $(shell pwd)/.make
export PARENT := true
include blackmagic.mk

LB := sudo lb
CLOC := node_modules/.bin/cloc
CSPELL := cspell

.PHONY: all
all: build

.PHONY: sudo
sudo:
	@sudo true

ACTIONS += config
CONFIG_DEPS :=
CONFIG_TARGET := sudo
$(ACTION)/config:
	@$(LB) config
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
start: ~format
	@$(MAKE) -s +start
+start: ;

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

-include $(patsubst %,$(_ACTIONS)/%,$(ACTIONS))

+%:
	@$(MAKE) -e -s $(shell echo $@ | $(SED) 's/^\+//g')

%: ;

CACHE_ENVS += \
	CLOC \
	CSPELL \
	LB 
