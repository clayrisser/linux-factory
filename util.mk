define tmpl
	for f in $$($(FIND) . -type f -printf "%p\n" | $(SED) 's|^\.\/||g'); do \
		if [ "$2" != "" ]; then \
			for i in $2; do \
				if [ "$$f" = "$$i" ]; then \
					IGNORE=1; \
				fi; \
			done; \
		fi; \
		if [ "$$IGNORE" != "1" ]; then \
			$(MKDIR) -p $$($(ECHO) $1/$$f | $(SED) 's|\/[^\/]\+$$||g' $(NOFAIL)) && \
			if [ "$$($(ECHO) $$f | $(GREP) -oE '\.tmpl$$' $(NOFAIL))" = ".tmpl" ]; then \
				$(TMPL) $$f > $1/$$($(ECHO) $$f | $(SED) 's|\.tmpl$$||g'); \
			else \
				$(CP) $$f $1/$$f; \
			fi; \
		fi; \
	done
endef
