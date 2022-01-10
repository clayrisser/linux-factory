include mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/mkchain
include $(MKPM)/dotenv
include util.mk

export TMPL := sh $(PROJECT_ROOT)/scripts/tmpl.sh
export OS := $(MKPM_TMP)/os

.PHONY: root
root:
	@$(RM) -rf $(OS) $(NOFAIL)
	@$(MKDIR) -p $(OS)
	@$(CD) root && \
		$(call tmpl,$(OS))

.PHONY: overlays
overlays: root
	@for o in $(shell $(LS) overlays); do \
		$(CD) $(PROJECT_ROOT)/overlays/$$o && \
			$(call tmpl,$(OS)); \
	done

endif
