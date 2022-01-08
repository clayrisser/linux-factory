export SWAY_VERSION ?= 1.5.1

export UPSTREAM := config-overrides/includes.chroot/etc/skel/.config/sway/config \
	config-overrides/includes.installer/preseed.cfg

export CURL ?= curl
export PATCHES := $(UPSTREAM)
include $(MKPM)/patch

config-overrides/includes.chroot/etc/skel/.config/sway/config:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://raw.githubusercontent.com/swaywm/sway/$(SWAY_VERSION)/config.in

config-overrides/includes.installer/preseed.cfg:
	@$(MKDIR) -p $(@D)
	@$(CURL) -Lo $@ \
		https://www.debian.org/releases/bullseye/example-preseed.txt
