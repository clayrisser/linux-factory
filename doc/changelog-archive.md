This is an archived changelog for versions 1.4-2.1. The git history has been reset for 2.2, and the repository recreated from scratch. 

## [v2.1](https://gitlab.com/nodiscc/dlc/releases/tag/2.1) - UNRELEASED

### Changed

- Change main graphical package manager back to gnome-packagekit
- Disable enforcing DNSSec by default in NetworkManager config
- Better keepassxc desktop integration: start minimzed, enable browser integration, various UX settings
- Cleanup/simplify/improve build/testing tools
- Update documentation

### Added

- Make security/bugfix updates fully automatic ([unattended-upgrades](https://wiki.debian.org/UnattendedUpgrades))
- Add [mlocate](https://packages.debian.org/buster/mlocate)
- Add sublime text bash alias

### Removed

- Remove [gnome-software](https://packages.debian.org/buster/gnome-software), UX problems

### Fixed

- Fix build dependencies installation
- Fix missing bootloader/desktop backgrounds
- Partially fix installation on EFI systems
- Fix blank homepage links in documentation

### Security
### Deprecated
-->

-------------------------------

## [v2.0](https://gitlab.com/nodiscc/dlc/releases/tag/2.0) - 2019-11-11

### Changed

- This release is based on [Debian 10 "Buster"](https://www.debian.org/releases/buster/)
- Rename project to `dlc`
- Switch to [GNOME Software](https://wiki.gnome.org/Apps/Software) as main graphical packagement tool (remove [gnome-packagekit](https://packages.debian.org/stretch/gnome-packagekit))
- Replace [owncloud-client](https://packages.debian.org/stretch/owncloud-client) with [nextcloud-desktop](https://packages.debian.org/buster/nextcloud-desktop)
- Replace [winff](https://packages.debian.org/stretch/winff) media converter with [qwinff](https://packages.debian.org/buster/qwinff)
- Remove all [APT pinning](https://wiki.debian.org/AptConfiguration#apt_preferences_.28APT_pinning.29) configuraton, by default only packages from Debian Stable will be used.
- Auto-start [KeepassXC](https://packages.debian.org/bullseye/keepassxc) on desktop login
- Update default SSH configuration from  https://gitlab.com/nodiscc/ansible-xsrv-common / https://github.com/dev-sec/ansible-ssh-hardening/
- Cosmetic changes (desktop theming)
- Update documentation
- Update all packages to latest versions
- Build tools: linting, cleanup, refactoring

### Added

- Add [lnav](https://packages.debian.org/buster/lnav) log viewer

### Removed

- Remove all third party/non-Debian software downloads except [dlc-utils](https://neuralnet.xinit.se/gitea/zerodb/dlc-utils)
- Remove less used packages [retext](https://packages.debian.org/stretch/retext), [libreoffice-math](https://packages.debian.org/stretch/libreoffice-math), [xfce4-dict](https://packages.debian.org/stretch/xfce4-dict), [git-svn](https://packages.debian.org/stretch/git-svn), [subversion](https://packages.debian.org/stretch/subversion), [mercurial](https://packages.debian.org/stretch/mercurial), [xfce4-dict](https://packages.debian.org/stretch/github-backup), [ghi](https://packages.debian.org/stretch/ghi), [xfce4-dict](https://packages.debian.org/stretch/hg-fast-export), [checkinstall](https://packages.debian.org/stretch/checkinstall), [live-images](https://packages.debian.org/stretch/live-images), 
- Remove packages not present in Debian 10 [alarm-clock-applet](https://packages.debian.org/stretch/alarm-clock-applet)
- Remove [cfv](https://packages.debian.org/stretch/cfv), [subliminal](https://packages.debian.org/stretch/subliminal), [gcolor2](https://packages.debian.org/stretch/gcolor2), [pidgin-libnotify](https://packages.debian.org/stretch/pidgin-libnotify), [python-musicbrainz2](https://packages.debian.org/stretch/python-musicbrainz2), [python-indicate](https://packages.debian.org/stretch/python-indicate), [libsane-extras](https://packages.debian.org/stretch/libsane-extras), [pulseaudio-module-gconf](https://packages.debian.org/stretch/pulseaudio-module-gconf), [gir1.2-spice-client-gtk-3.0](https://packages.debian.org/stretch/gir1.2-spice-client-gtk-3.0), [python-tox](https://packages.debian.org/stretch/python-tox), [consolekit](https://packages.debian.org/stretch/consolekit), [preload](https://packages.debian.org/stretch/preload), various documentation/ packages, [libgnomevfs2-extra](https://packages.debian.org/stretch/libgnomevfs2-extra), [gir1.2-gnomekeyring-1.0](https://packages.debian.org/stretch/gir1.2-gnomekeyring-1.0), [libtxc-dxtn-s2tc0](https://packages.debian.org/stretch/libtxc-dxtn-s2tc0)

<!--
### Fixed
### Security
### Deprecated
-->

-------------------------------

## [v1.9.3](https://gitlab.com/nodiscc/dlc/releases/tag/1.9.3) - 2019-06-08

<!--### Added -->

### Changed

- Faster installation procedure (never use network mirrors, don't try to connect to the network)
- Update all software to latest versions
- Update documentation/comments
- Various build tools improvements
- Update default wallpapers


### Removed

- Remove unused syntax highlighting files for gtksourceview-based text editors
- Remove unused transmission download completion script


### Fixed

- Fix missing APT sources.list entries when installing without an Internet connection.
- Fix missing xserver-xorg-video-intel display driver (required for Intel GPUs)
- Fix display of release number on the boot screen/menu
- Fix build for i386 (32-bit) CPU architecture
- Fix font name in default conky config

<!--
### Security
### Deprecated
-->

-------------------------------

## [v1.9.2](https://gitlab.com/nodiscc/dlc/releases/tag/1.9.2) - 2019-05-05

### Added

- Show the release number on the live medium boot menu
- Add an optional utility to install extra/non-Debian components and perform basic post-install configuration tasks (https://gitlab.com/nodiscc/dlc-utils)
- Re-add conky system monitor/desktop info widget, add basic conky configuration file (uncomment blocks inside the file to enable more components), autostart conky when opening a desktop session


### Changed

- Development: Cleanup package lists, scripts, update documentation
- Development: Simplify/refactor preseed files (installer automation)
- Development: Improve automated tests, automate incrementing the release version
- Update all software to latest versions
- add dlc-utils (utility/ansible playbook to install optional components)
- Replace dummy/transition packages with the actual packages
- Cleanup SSHD config file, remove obsolete comments
- Improve appearance/scaling of the audio volume icon
- Remove all 3rd party dependencies except dlc-utils and lutris


### Removed

- Remove incomplete/unused thunderbird default configuration file
- Remove ffmpegthumbnailer, libquicktime2 (unused)
- Remove needrestart as is may cause the installer to block with no visible message

### Fixed

- Preconfigure the installer's mirror directory (don't ask for it during install)


<!--
### Security
### Deprecated
-->

-------------------------------

## [v1.9](https://gitlab.com/nodiscc/dlc/releases/tag/1.9) - 2019-03-11

### Added

- Add [lutris](https://lutris.net/) gaming platform. Can be used to run games/applications for other OS/platforms including Windows and various game consoles.
- First run: add an option to disable the desktop compositor (may fix video lag/issues on old machines)

### Changed

- Makefile/tools: improve cleanup, add performance tests for built system
- Replace deprecated perl rename with 'rename' package
- During installation, show a warning if network auto-configuration fails

### Removed

- Removed gnome-logs package (does not show all logs)
- Remove unused 'alert' bash alias
- Removed playonlinux (replaced with lutris)

### Fixed

- First run: fixed concurrent launch of web browsers when all boxes were checked

<!--
### Security
### Deprecated
-->

-------------------------------

## [v1.8](https://gitlab.com/nodiscc/dlc/releases/tag/1.8) - 2019-02-10

### Added

- Run a simple graphical utility on first user login to help new users set up their environment (Firefox configuration/extensions, messaging accounts, other settings)

### Changed

- Default Firefox addons are no longer downloaded from addons.mozilla.org but use official Debian packages instead
- Enable hardware temperature monitoring (hddtemp, lm-sensors) and random number generation (haveged) services on boot
- nano text editor: disable automatic tab-to-spaces in config
- Update documentation
- Disable some services on startup to improve boot time/base resource usage: samba (nmbd/smbd), libvirt (libvirtd, libvirt-guests)

### Removed

- Remove all Firefox addons from default installation except uBlock Origin and HTTPS everywhere
- Don't install user.js Firefox configuration hardening by default
- Remove unused .desktop launchers:

### Fixed

- `rsyslog` system logging service is now correctly enabled at system boot.
- Fix some known non-working Wi-Fi adapters by disabling _Predictable Network Interface Names_ in systemd
- Fix broken pidgin accounts dialog (remove apparmor-profiles-extra)

<!--
### Security
### Deprecated
-->

-------------------------------

## [v1.7.1](https://gitlab.com/nodiscc/dlc/releases/tag/1.7.1) - 2019-01-09

### Changed

 - Update documentation
 - Update software to latest versions
 - sysctl: use configuration sysctl from  https://gitlab.com/nodiscc/srv01/blob/master/roles/common/files/etc_sysctl.d_srv01-sysctl.conf
 - Replace marble maps with gnome-maps
 - Replace chm2pdf with archmage (CHM to HTML converter)

### Removed

 - Remove broken "shred files" file manager extension
 - Firefox: remove canvasblocker addon


## [v1.7](https://gitlab.com/nodiscc/dlc/releases/tag/1.7) - 2018-11-25

### Added

 - Packages: add chm2pdf, add thunderbird Lightning extension
 - Add KeepassXF-browser Firefox addon
 - Add sensible default configuration for xfce4-taskmanager
 - Harden default SSH configuration
 - Development: add a test_kvm Makefile target: create a blank libvirt VM and run the system in live mode, add the ability to specify arbitrary URLs for inclusion in packages documentation

### Changed

- Packagekit: Do not prompt for password on package upgrades for users in the sudo group
- Replace KeepassX with KeepassXC
- Update documentation

### Removed

 - Remove Firefox no-resource-uri-leak addon ([upstream bug fixed](https://bugzilla.mozilla.org/show_bug.cgi?id=863246)
 - Remove gnome-video-effects-frei0r (rarely used, vulnerable dependencies)

<!--
### Fixed
### Security
### Deprecated
-->

-------------------------------

## [v1.6](https://gitlab.com/nodiscc/dlc/releases/tag/1.6) - 2018-09-09

### Added
 * Add libpam-tmpdir package (per-user temporary directories)
 * Virtualization: add virt-top and netcat-openbsd packages

### Changed

 * Replace gnome-system-log with gnome-logs (gnome-system-tools are deprecated)
 * Replace livestreamer with streamlink (active fork)
 * Replace gnome-search-tool with catfish
 * Disable autostarting xfce4-notes
 * Simplify and document sysctl settings
 * Update documentation
 * Improve Makefile download/caching/installation mechanisms
 * Remove conky configuration from the main repository, download/install it from the Makefile

### Removed
 * Desktop utilities: Remove screenruler package (removes dependency on rake/ruby stack)
 * Development/utilities: Remove ranger and pypi2deb package


### Fixed
 * Fix broken XFCE keyboard shortcuts
 * Fix debian installer asking for the mirror directory


## [v1.5.1](https://gitlab.com/nodiscc/dlc/releases/tag/1.5.1) - 2018-06-06

### Added
 * Auto-generate documentation/links to installed Firefox addons pages.

### Removed
 * Remove unused packages at-spi2-core, apparmor-notify, apmd

### Changed
 * Don't disable bluetooth service by default, but boot with bluetooth devices powered down.
 * Various build tools optimizations/improvements/cleanup.
 * Cleanup obsolete desktop session autostart entries.

### Fixed
 * Add missing packages for working virt-manager/KVM virtualization stack
 * Fix broken selection of Firefox default search engine (revert back to Google), add 15 engines to search engines menu.

-------------------------------

## [v1.5](https://gitlab.com/nodiscc/dlc/releases/tag/1.5) - 2018-05-22

### Added

 * Packages: add traceroute, localepurge (remove unused translations), manpages, manpages-dev, transmission-cli, poedit
 * Transmission: on download completion, copy the original .torrent file to the download directory (script in /usr/share/transmission/)
 * Add default configuration for liferea, xfce4-notes, update retext default config
 * Add 2 bash aliases: `sortclipboard` (sort the X clipboard), `alert <command>` (display a red/green block on command success/error)

### Changed

 * Replace xfce applications menu with whiskermenu plugins, update default configuration
 * Replace virtualbox with KVM/libvirt/virt-manager based setup (level 1 hypervisor, much better performance)
 * Replace gtk-recordmydesktop with vokoscreen screencast recorder
 * Firewall policies "Low" and "High" are available in GUFW
   * "Low" policy allows any output, and incoming samba/avahi connections from LAN 192.168.1.0/24
   * "High" policy only allows output on secure protocols + DNS, and blocks the rest
 * Update documentation
 * Force https downloads for APT where possible
 * Cleanup, reordering, improve build tools, Makefile, caching, automation, error handling and output

### Removed

 * Packages: Remove less-used packages to save disk space / ISO file size: 
   * All game console emulators except pcsxr and zsnes
   * 11 fonts, font-manager
   * Openshot video editor (use blender)
   * network-manager-iodine, wxhexeditor, tdfsb, sqlitebrowser, asciio
 * Remove 3rd party package download (webtorrent) (see branch `extras/webtorrent`)
 * Remove WIP thunderbird addons download/installation (see branch `extras/wip/thunderbird-addons`)
 * Remove gdebi, removes dependency on gksu (unmaintained)

### Fixed

 * Fixed qemu-utils package name
 * Fixed iso signing procedure
 * Fix boot menu submenus not working
 * Fix live-build hooks
 * Fix bootloader menu templates
 * Fix some bash aliases
 * Fix custom application launchers icons/categories

-------------------------------

## [v1.4](https://gitlab.com/nodiscc/dlc/releases/tag/1.4) - 2018-03-05

### Added

Build an ISO image using live-build:
 - build an iso-hybrid image suitable for removable drives and/or CD/DVD
 - add an option to permanenty install the live system to disk, using the graphical installer
 - build from Debian 9 Stretch repositories (using main, contrib and non-free archive sections)
 - support the amd64 CPU architecture, enable support for i386 packages (multiarch)
 - enable Debian backports, security and updates repositories
 - disable installation of 'recommended' packages
 - include device firmwares in the ISO image and the live system
 - include memtest86+ in the ISO image
 - include an installer launcher for Windows computers in the ISO image
 - other build options: HTTPS apt transport, SHA256 checksums, no separate image for source packages, boot parameters, debconf options, logging, cleanup
 - pre-answer (preseed) some installer questions
 - rewrite the git history/changelog to get a readable log. An [archive of the old changelog](https://gitlab.com/dlc/blob/master/doc/changelog-archive.md) is available.

Include ~600 packages by default:
 - desktop environment based on Xfce
 - office utilities, document reading and editing
 - web browsing, file transfer, download and synchronisation, messaging
 - audio/video playback, creation and editing tools
 - base hardware, display and audio systems, apparmor
 - file management, system, hardware and network configuration/diagnostic utilities
 - various graphical and command line utilities for common tasks
 - Virtualization/other platforms support (Virtualbox, WINE)
 - remove a few unwanted default Debian packages from the system, disable some services by default
 - add documentation for general usage, installation and default packages. See the [README](https:/gitlab.com/nodiscc/dlc/blob/master/README.md).

Other changes to default Debian installation:
 - add a few .desktop launchers, better integration for the Send to... menu, default file associations, 
 - add default configuration for terminal, desktop, boot splash, syntax highlighting, conky, and many other utilities.
 - configure touchpad scrolling, file indexing, sudo behavior, sysctl, localization, power saving, package management, GRUB boot options, keyboard, UFW firewall
 - add a local caching DNS resolver (dnsmasq-base) for NetworkManager
 - enable AppArmor mandatory access control system
 - see the [commit log](https://gitlab.com/nodiscc/dlc/commits) and git repository contents for more details.

<!--
### Added
### Changed
### Removed
### Fixed
### Security
### Deprecated
-->


This is an archived changelog for versions 0.9m-1.9.3. Parts of this project have been ported from multiple git and svn repositories over the years, and their history long lost. This project was started around 2010 and has since taken various forms and names.

## [v1.2](https://gitlab.com/nodiscc/dlc/releases/tag/1.2) - 2018/02/11

### Added

 * Add KeepassX password manager
 * Add a 'Send To' menu entry for Ex Falso
 * APT: Add and enable apt-transport-https
 * Development tools: add python-tox
 * Add lman, hman (manpage viewing) and genpass bash aliases, add required groff package
 * Command line utilities: add subliminal subtitle downloader

### Changed

 * Replace QWinFF with WinFF (media converter)
 * Replace sound-juicer with asunder (audio CD extractor)
 * Improve tools/automation (tests, doc generation, build)
 * Autostart xfce4-notes
 * Update and improve documentation and TODO
 * Use APT HTTPS transport for package downloads when possible
 * Replace virtualbox with kvm/virt-manager tools

### Removed

 * Remove insecure (HTTP) direct package downloads from the Makefile
  * light-locker-settings
  * purple-facebook
  * youtube-dl-gui
  * paper-gtk-theme
  * paper-cursor-theme
  * fonts-open-sans
  * ceti2-theme
  * vertex-theme
 * Remove 'Quote colors' Thunderbird addon
 * Remove 'Dark mode' and 'Simple YouTube repeater' Firefox addons

### Fixed

 * Remove obsolete virtualbox repository GPG key
 * Minor fixes, cleanup, improve various default configurations
 * Re-add virtualbox graphical interface
 * Force IPv4 APT updates since IPv6 is disabled

## [v1.1](https://gitlab.com/nodiscc/dlc/releases/tag/1.1) - 2017-11-11

### Added

 * Add Virtualbox virtualization software
 * Add OBS Studio video recorder/streamer
 * Add Blender 3D editor
 * Add ReText markdown editor
 * Add various development/utility packages: dnsmasq-base  ghi, pypi2deb, python-praw, firejail, firetools, dfc, fonts-hack-ttf, xfce4-pulseaudio-plugin, gimp-help-fr, libdvd-pkg, asciio
 * Add basic default configuration file for youtube-dl
 * Add a set of default configuration files + scripts for conky

### Changed

 * Replace xpad with xfce4-notes (notetaking application)
 * Change main UI font to Roboto
 * Replace jpegoptim/optipng with trimage (image file optimization)
 * Update quodlibet configuration
 * Disable haveged and bluetooth services by default
 * Installer: remove disk partitioning scheme customizations, don't auto-try DHCP network configuration
 * Add 'genpass' alias (generate random password)
 * Update all packages to their latest versions
 * Improve documentation generation
 * Update documentation

### Removed

 * Remove librecad, glabels, ocrfeeder, winetricks from default installed packages
 * Firefox addons: remove all 'legacy' add-ons, keep only e10s and WebExtensions compatible add-ons
 * Firefox addons: add Simple Youtube Repeater

### Fixed

 * Fix gpk-update-viewer not detecting available package updates (add missing apt-config-auto-update package)
 * Add missing i386 packages for PlayOnLinux/WINE
 * Fix live-build hooks execution (enable multiarch, purge unwanted packages, set default services status, set default desktop session)
 * Remove obsolete config files, cleanup various files, improve Makefile/build process
 * Remove i386 3rd-party packages downloads from Makefile

### Security

 * Security vulnerabilities in multiple Debian packages have been fixed (https://lists.debian.org/debian-security/)


## [v1.0.1](https://gitlab.com/nodiscc/dlc/releases/tag/1.0.1) - 2017-07-03

### Removed

 * Removed gnome-boxes and dependency on GNOME Tracker file indexing (high resource usage)

### Fixed

 * Added missing gnome-settings-daemon and at packages
 * Cleanup in autostart entries

## [v1.0](https://gitlab.com/nodiscc/dlc/releases/tag/1.0) - 2017-06-26

### Added

 * Development tools: added dh-make
 * Games/emulators: add mupen64plus-qt

### Changed

 * Update documentation
 * Improve iso image signing and release process

### Removed

 * Disabled redshift autostart, must now be enabled manually
 * Removed third party dependencies on conkyselect and fonts git repos

### Fixed

 * Fixed documentation generation script

### Deprecated

 * Removed obsolete libpam-smbpass package
 * Removed obsolete ffmpegthumbnailer workaround


## [v0.9n](https://gitlab.com/nodiscc/dlc/releases/tag/0.9n) - 2017-06-19

### Added

 * Added xfce4-places-plugin
 * Support generating documentation pages from .deb packages

### Changed

 * Simplified XFCE4 panel configuration
 * Refactoring and cleanup in makefile/doc-generator.sh

### Removed

 * Removed first-run desktop setup script
 * Remove torrent creation sendto/helper

### Fixed

 * Fixed doc generation for samba package list


## [v0.9m](https://gitlab.com/nodiscc/dlc/releases/tag/0.9m) - 2017-06-17

### Added

 * Desktop environment: XFCE4 netload/weather/whiskermenu panel plugins, GNOME Boxes.
 * Development: added vera, gdb, iat, nrg2iso, git-mediawiki, python3-venv.
 * Multimedia: added QWinFF, added more VLC plugins (skins2,splitter,visualization,video-output,base,qt) and command-line variant.
 * System: Added GNOME Boxes virtualization tool.
 * Network: Added Samba file sharing server.
 * Added application launcher for Units.
 * Firefox addons: add Scrapbook X, Greasemonkey, Downthemall.

### Changed

 * Installer: let user select whether a network mirror should be used or not. This allows fully offline installation without having to manually cancel mirror selection.
 * Network mirrors: replaced country specific debian archive mirrors with deb.debian.net CDN. Allows faster packages download speeds regardless of the machine's geographic locations.
 * Updated 3rd party packages and user documentation, fix translations.
 * Removed most preset firewall rules, only preconfigured rules are now Bittorrent, Avahi and Samba.

### Removed

 * Replaced Synapse launcher with Kupfer.
 * Removed Remmina remote desktop client (removed from Debian Stretch).

### Fixed

 * Cleanup and improvements in documenation generation scripts.

## [v0.9k](https://gitlab.com/nodiscc/dlc/releases/tag/0.9k) - 2017-06-02

Release final usable version. See [TODO.md](TODO.md) for remaining issues.

### Added

* Automate Debian Live system and installer build using live-build/Make
* Build for amd64 and i386 platforms, using Debian "Stretch" (testing) release
* Preconfigure isolinux bootloader (splash/menus) and Debian installer (disable popcon, noatime mount option, default groups, ext4 as default filesystem, clock, mirrors, homedir permissions, DHCP, generic setup tasks)
* Include memtest86+ and a Windows-compatible installer on bootable media
* Include non-free firmwares on the installation media
* Enable multiarch (x86 compatibility for x86_64 machines)
* Specify [571 packages to install](https://gitlab.com/nodiscc/dlc/blob/master/doc/packages.md)
* Preconfigure services status, package management, bootloader, keyboard, firefox, font rendering, thunderbird, power management, display/session management, boot screen, sudo, sysctl, ufw, updatedb, locales, audacity, conky, elinks, gimp, mplayer, nano, pidgin, quodlibet, ssh, git, top, bash, audacious, autostarted applications, bleachbit, htop, openbox, pnmixer, synapse, Thunar, transmission, xfce4, xfce4-desktop, xfce4-panel, xfce4-terminal, ristretto, xfwm4, xsettings, xpad, redshift, Qt, file associations, gtksourceview, synapse, themes, thumbnailers, X11
* Automate download/installation of third-party software/addons/configuration files (Makefile, scripts/): 9 Firefox addons, 11 Thunderbird addons, 10 third-party .deb packages, 18 git repositories
* Automate generation of markdown documentation for installed packages, add main documentation (README, TODO, license, installation, usage, changelog, packages).
* Add simple GTK graphical helpers/launchers for simple tasks (initial setup wizard, password generation, torrent creation)

