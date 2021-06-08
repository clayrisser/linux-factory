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
clean:
	-@$(call clean)
	-@$(LB) build
	-@$(GIT) clean -fXd $(NOFAIL)

.PHONY: purge
purge: clean
	-@$(GIT) clean -fXd

-include $(patsubst %,$(_ACTIONS)/%,$(ACTIONS))

+%:
	@$(MAKE) -e -s $(shell echo $@ | $(SED) 's/^\+//g')

%: ;

CACHE_ENVS += \
	CLOC \
	CSPELL \
	LB 
