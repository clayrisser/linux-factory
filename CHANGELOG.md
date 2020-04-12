# Change Log

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](http://keepachangelog.com/).

-------------------------------

## [v2.2.2](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.2) - 2020-04-11

### Changed

- Disable window manager compositor by default (improve video performance/prevent tearing)
- Update user.js to 0.1

### Added

- Documentation at https://debian-live-config.readthedocs.io/ (auto-generated with Sphinx/python script)

### Fixed

- Fix APT sources lists not present in the final image
- Improve/cleanup makefile and package lists
- Fix error during installation in EFI boot mode


-------------------------------


## [v2.2.1](https://gitlab.com/nodiscc/dlc/releases/tag/2.2.1) - 2020-03-14

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
