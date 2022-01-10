export SWAY_VERSION ?= 1.5.1

export UPSTREAMS := config-overrides/includes.installer/preseed.cfg

export CURL ?= curl
export PATCHES :=
include $(MKPM)/patch

config-overrides/includes.installer/preseed.cfg:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://www.debian.org/releases/bullseye/example-preseed.txt