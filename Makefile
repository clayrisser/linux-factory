export MAKE_CACHE := $(shell pwd)/.make
export PARENT := true
include blackmagic.mk

LB := lb
CLOC := node_modules/.bin/cloc
CSPELL := cspell

.PHONY: all
all: build

ACTIONS += config
INSTALL_DEPS := 
INSTALL_TARGET := $(INSTALL_DEPS) $(ACTION)/install
$(ACTION)/config:
	@$(LB) config

ACTIONS += install
INSTALL_DEPS := $(patsubst %,$(DONE)/_install/%,package.json)
INSTALL_TARGET := $(INSTALL_DEPS) $(ACTION)/install
$(ACTION)/install:
	@$(call done,install)

ACTIONS += format~install
FORMAT_DEPS := $(call deps,format,$(shell $(GIT) ls-files 2>$(NULL) | \
	grep -E "\.((json)|(ya?ml)|(md)|([jt]sx?))$$"))
FORMAT_TARGET := $(FORMAT_DEPS) $(ACTION)/format
$(ACTION)/format:
	@$(call done,format)

ACTIONS += spellcheck~format
SPELLCHECK_DEPS := $(call deps,spellcheck,$(shell $(GIT) ls-files 2>$(NULL) | \
	$(GIT) ls-files | grep -E "\.(md)$$"))
SPELLCHECK_TARGET := $(SPELLCHECK_DEPS) $(ACTION)/spellcheck
$(ACTION)/spellcheck:
	-@$(CSPELL) --config .cspellrc.json $(shell $(call get_deps,spellcheck))
	@$(call done,spellcheck)

ACTIONS += lint~spellcheck
LINT_DEPS := $(call deps,lint,$(shell $(GIT) ls-files 2>$(NULL) | \
	grep -E "\.([jt]sx?)$$"))
LINT_TARGET := $(LINT_DEPS) $(ACTION)/lint
$(ACTION)/lint:
	@$(call done,lint)

ACTIONS += test~lint
TEST_DEPS := $(call deps,test,$(shell $(GIT) ls-files 2>$(NULL) | \
	grep -E "\.([jt]sx?)$$"))
TEST_TARGET := $(TEST_DEPS) $(ACTION)/test
$(ACTION)/test:
	@$(call done,test)

ACTIONS += build~test
BUILD_DEPS := $(call deps,build,$(shell $(GIT) ls-files 2>$(NULL) | \
	grep -E "\.([jt]sx?)$$"))
BUILD_TARGET := $(BUILD_DEPS) $(ACTION)/build
$(ACTION)/build: es/index.js lib/index.js ;
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
	-@$(JEST) --clearCache $(NOFAIL)
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
