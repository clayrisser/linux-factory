include mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/mkchain
include $(MKPM)/dotenv

export NODE ?= node
export YQ ?= yq
export CLEAN_PACKAGES ?= $(NODE) -e 'require("./scripts/packages.js").clean()'
export LOAD_PACKAGES ?= $(NODE) -e 'require("./scripts/packages.js").load()'

export PACKAGES := $(addprefix os/packages/,$(shell ls os/packages))

.PHONY: load-packages
load-packages:
	$(CLEAN_PACKAGES)
	@for p in $(PACKAGES); do \
		$(CAT) $$p | $(YQ) | $(LOAD_PACKAGES); \
	done

endif

