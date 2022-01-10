include ../mkpm.mk
ifneq (,$(MKPM_READY))
include $(MKPM)/gnu
include $(MKPM)/dotenv

LB_PATH=$(PROJECT_ROOT)/lb

hello:
	@echo world

env:
	@$(RM) $(LB_PATH)/.env $(NOFAIL)
	@$(ECHO) 'APT="apt"' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_INDICES="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_OPTIONS="-y"' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_RECOMMENDS="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'APT_SOURCE_ARCHIVES="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'ARCHITECTURES="amd64"' >> $(LB_PATH)/.env
	@$(ECHO) 'ARCHIVE_AREAS="main contrib non-free"' >> $(LB_PATH)/.env
	@$(ECHO) 'BACKPORTS="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'BINARY_IMAGES="iso-hybrid"' >> $(LB_PATH)/.env
	@$(ECHO) 'BOOTAPPEND_LIVE="boot=live components username=live locales=en_US.UTF-8 keyboard-layouts=us"' >> $(LB_PATH)/.env
	@$(ECHO) 'CACHE="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'CHECKSUMS="sha256"' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBIAN_INSTALLER="netinst"' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBIAN_INSTALLER_GUI="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBOOTSTRAP_OPTIONS="--include=apt-transport-https,ca-certificates,openssl"' >> $(LB_PATH)/.env
	@$(ECHO) 'DEBUG="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'DISTRIBUTION="bullseye"' >> $(LB_PATH)/.env
	@$(ECHO) 'INITSYSTEM="systemd"' >> $(LB_PATH)/.env
	@$(ECHO) 'ISO_APPLIECHOION="DEB Distro"' >> $(LB_PATH)/.env
	@$(ECHO) 'ISO_PUBLISHER="DEB Distro; https://bitspur.com; email@bitspur.com"' >> $(LB_PATH)/.env
	@$(ECHO) 'ISO_VOLUME="DEB Distro"' >> $(LB_PATH)/.env
	@$(ECHO) 'LINUX_FLAVOURS="amd64"' >> $(LB_PATH)/.env
	@$(ECHO) 'LINUX_PACKAGES="linux-image linux-headers"' >> $(LB_PATH)/.env
	@$(ECHO) 'MIRROR_BOOTSTRAP="http://deb.debian.org/debian/"' >> $(LB_PATH)/.env
	@$(ECHO) 'MIRROR_DEBIAN_INSTALLER="http://deb.debian.org/debian/"' >> $(LB_PATH)/.env
	@$(ECHO) 'MODE="debian"' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_DEBIAN_INSTALLER_DISTRIBUTION="bullseye"' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_DISTRIBUTION="bullseye"' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_MIRROR_CHROOT="http://deb.debian.org/debian/"' >> $(LB_PATH)/.env
	@$(ECHO) 'PARENT_MIRROR_CHROOT_SECURITY="http://security.debian.org/"' >> $(LB_PATH)/.env
	@$(ECHO) 'SECURITY="false"' >> $(LB_PATH)/.env
	@$(ECHO) 'SYSTEM="live"' >> $(LB_PATH)/.env
	@$(ECHO) 'UPDATES="true"' >> $(LB_PATH)/.env
	@$(ECHO) 'WIN32_LOADER="true"' >> $(LB_PATH)/.env

endif
