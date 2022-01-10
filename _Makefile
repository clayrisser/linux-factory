include mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/mkchain
include $(MKPM)/dotenv

export DPKG_NAME ?= dpkg-name
export NODE ?= node
export YQ ?= yq
export CLEAN_PACKAGES ?= $(NODE) -e 'require("./scripts/packages.js").clean()'
export CLEAN_REPOS ?= $(NODE) -e 'require("./scripts/repos.js").clean()'
export LOAD_PACKAGES ?= $(NODE) -e 'require("./scripts/packages.js").load()'
export LOAD_REPOS ?= $(NODE) -e 'require("./scripts/repos.js").load()'

export DEBS := $(shell ls os/packages/*.deb $(NOFAIL))
export PACKAGES := $(shell ls os/packages/*.yaml $(NOFAIL))
export REPOS := $(shell ls os/repos/*.yaml $(NOFAIL))

.PHONY: config
config:
	@$(MAKE) -sC live-build config

.PHONY: load-packages
load-packages:
	@$(CLEAN_PACKAGES)
	@for p in $(PACKAGES); do \
		$(CAT) $$p | $(YQ) | $(LOAD_PACKAGES); \
	done
	@$(RM) -rf $(MKPM_TMP)/debs
	@$(MKDIR) -p $(MKPM_TMP)/debs
	@for d in $(DEBS); do \
		export MOVED_PATH=$$( \
			eval $(ECHO) $$( \
				$(DPKG_NAME) -s $(MKPM_TMP)/debs -o $$d | \
				$(SED) 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | \
				$(SED) 's|dpkg-name:\s.\+moved\s.\+\sto\s||g' \
			) \
		) && \
		$(CP) $$MOVED_PATH $$d && \
		$(ECHO) loaded package $$($(ECHO) $$MOVED_PATH | \
			$(GREP) -oE '[^/]+$$' | $(GREP) -oE '^[^_]+'); \
	done

.PHONY: load-repos
load-repos:
	$(CLEAN_REPOS)
	@for p in $(REPOS); do \
		$(CAT) $$p | $(YQ) | $(LOAD_REPOS); \
	done

.PHONY: load
load: | config load-packages load-repos

.PHONY: build
build: load
	@$(MAKE) -sC live-build build

.PHONY: clean
clean: sudo
	@$(MAKE) -sC live-build clean

.PHONY: purge
purge: sudo clean
	@$(SUDO) $(GIT) clean -fXd

endif
