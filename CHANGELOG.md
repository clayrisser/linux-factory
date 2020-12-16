# Change Log

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [v2.2.5](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.5) - 2020-12-16

### Removed

- remove [Liferea](https://packages.debian.org/buster/liferea) feed reader from default install
- remove [gnome-maps](https://packages.debian.org/buster/gnome-maps) from default install

### Fixed

- nano: fix loading of syntax highlighting configuratio from ~/.nano/*.nanorc


### Changed

- update third-party Lutris package to 0.5.8.1
- update documentation/.gitconfig examples
- tools: improve build/cleanup mechanisms

-------------------------------

## [v2.2.4](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.4) - 2020-10-22

### Added

- add [Lutris](https://lutris.net) gaming platform
- add sensible defaults for mousepad text editor

### Fixed

- fix display of virt-manager console (add missing  gir1.2-spiceclientgtk-3.0 package)


### Changed

- update all packages to latest version (Debian 10.6)
- replace ntp time synchronization service with [chrony](https://chrony.tuxfamily.org/)
- keyboard shortcuts: add ctrl+alt+shift+left/down/right/up to move current windows to the left/down/right/up workspace
- libvirt: set the default URI to qemu:///system (virsh now works without sudo or --connect)
- dotfiles/conky: don't draw shades by default
- update documentation
- tools: various Makefile improvements

-------------------------------

## [v2.2.3](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.3) - 2020-05-10

Bugfix release.

### Fixed

- packages: add non-free nvidia-driver (fix no display at X startup on nvidia cards)
- packages: fix inability to mount luks encrypted disks (missing libblockdev-crypto2 package)
- packages: fix lightdm not showing the user list (missing accountsservice package)
- doc: fix readthedocs TOC/typos/syntax, reorder graphics package list, update auto-generated documentation (make doc), add links to source mirrors

### Changed

- dotfiles: .bash_aliases: add example of return code indication in bash prompt
- tools: remove unused build dependencies (xmlstarlet, shellcheck), add gnupg to build dependencies (checksums signing), add python3-venv to build dependencies (doc generation)

-------------------------------

## [v2.2.2](https://gitlab.com/nodiscc/debian-live-config/-/tags/2.2.2) - 2020-04-11

### Changed

- Disable window manager compositor by default (improve video performance/prevent tearing)
- Update user.js to 0.1
- Remove unused locales from live system (only keep en/fr), decrease iso image size

### Added

- Documentation at https://debian-live-config.readthedocs.io/ (auto-generated with Sphinx/python script)

### Fixed

- Fix APT sources lists not present in the final image
- Improve/cleanup makefile and package lists
- Fix error during installation in EFI boot mode


-------------------------------


## [v2.2.1](https://gitlab.com/nodiscc/debian-live-config/-/tags/2.2.1) - 2020-03-14

### Changed

- remove all plymouth/wallpaper customizations, use Debian defaults
- display plymouth boot loading screen
- Makefile: move 3rd party downloads to separate file, improve 'clean' target, improve idempotence/separation of concerns
- skel: quodlibet: set default rating to 0
- skel: xfwm: decrease default number of workspaces to 2
- skel: xfwm4: disable window shadows
- update README

### Added

- add third party package for https://github.com/EionRobb/pidgin-opensteamworks/
- add third party download for https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/
- add third party download for https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/
- add third party download for https://github.com/nodiscc/user.js
- add third-party download for https://github.com/az0/cleanerml
- add (disabled) third party download for  https://www.sublimetext.com/
- Makefile: add a target to generate a TODO.md from a list of gitea issues, add TODO.md

### Removed

- remove Samba server

### Fixed

- fix broken installation of graphics/image packages list
- associate SVG files with ristretto

-------------------------------

## [v2.2](https://gitlab.com/nodiscc/dlc/releases/tag/2.2) - 2020-03-08

Initial release, git repository reset and rebuilt from scratch. See commit messages and documentation.

<!--
### Changed
### Added
### Removed
### Fixed
### Security
### Deprecated
-->
