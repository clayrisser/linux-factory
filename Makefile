include mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/mkchain
include $(MKPM)/dotenv

export NODE ?= node
export YQ ?= yq
export CLEAN_PACKAGES ?= $(NODE) -e 'require("./scripts/packages.js").clean()'
export CLEAN_REPOS ?= $(NODE) -e 'require("./scripts/repos.js").clean()'
export LOAD_PACKAGES ?= $(NODE) -e 'require("./scripts/packages.js").load()'
export LOAD_REPOS ?= $(NODE) -e 'require("./scripts/repos.js").load()'

export PACKAGES := $(shell ls os/packages/*.yaml $(NOFAIL))
export REPOS := $(shell ls os/repos/*.yaml $(NOFAIL))

.PHONY: load-packages
load-packages:
	@$(CLEAN_PACKAGES)
	@for p in $(PACKAGES); do \
		$(CAT) $$p | $(YQ) | $(LOAD_PACKAGES); \
	done

.PHONY: load-repos
load-repos:
	$(CLEAN_REPOS)
	@for p in $(REPOS); do \
		$(CAT) $$p | $(YQ) | $(LOAD_REPOS); \
	done

.PHONY: load
load: load-packages load-repos

.PHONY: clean
clean: sudo
	@$(MAKE) -sC live-build clean

.PHONY: purge
purge: sudo clean
	@$(SUDO) $(GIT) clean -fXd

endif
