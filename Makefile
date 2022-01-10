include mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/mkchain
include $(MKPM)/dotenv

export TMPL := sh $(PROJECT_ROOT)/scripts/tmpl.sh
export OS := $(MKPM_TMP)/os

.PHONY: root
root:
	@$(RM) -f $@ $(NOFAIL)
	@$(MKDIR) -p $@
	@$(call tmpl,root,$(OS))

define tmpl
cd $1 && \
	for f in $$($(FIND) . -type f -printf "%p\n" | $(SED) 's|^\.\/||g'); do \
		$(TMPL) $$f > $2/$$f; \
	done
endef

endif
