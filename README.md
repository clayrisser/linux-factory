# deb-distro

> a framework used to create custom debian distributions

## Cheatsheet

### Definitions

- **live medium** - the ISO image and filesystem
- **live system** - the operating system booted from the live medium
- **installed system** - the operating system installed from debian installer
- **chroot stage** - stage when building the image
- **binary stage** - stage when running the live system

### File Structure

`config/archives/*.{list,key}.binary` - repositories added to _live system_ `/etc/apt/sources.list.d/`
`config/archives/*.{list,key}.chroot` - repositories loaded during the _chroot stage_
`config/includes.binary/*` - files to include in the _live medium's_ filesystem
`config/includes.chroot/*` - files to include in the _live system's_ filesystem
`config/includes.installer/*` - configuration for debian installer
`config/package-lists/*.list.binary` - packages to place in the APT `pool/` repository on the _live medium_
`config/package-lists/*.list.chroot` - packages to install in the _live system_
`config/package-lists/*.list.chroot_install` - packages to install in the _live system_ and _installed system_

## Resources

https://debian-live-config.readthedocs.io/en/latest/custom.html
https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html
