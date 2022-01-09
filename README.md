# deb-distro

> a framework used to create custom debian distributions

## Dependencies

This system can only be built from a Debian based operating system. While
any Debian based operating system should work, this is only tested against
the official Debian distribution on amd64.

| Name       | Install                                                                                                                                                                                       | Url                                                                           |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| GNU Make   | `sudo apt-get install -y make`                                                                                                                                                                | https://www.gnu.org/software/make                                             |
| Live Build | `sudo apt-get install -y live-build`                                                                                                                                                          | https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html |
| NixOS      | `sudo true && curl -L https://nixos.org/nix/install \| sh`                                                                                                                                    | https://nixos.org/download.html                                               |
| NodeJS     | `sudo apt-get install -y nodejs`                                                                                                                                                              | https://nodejs.org/en/                                                        |
| direnv     | `sudo apt-get install -y direnv && SHELL_NAME=$(echo $SHELL \| grep -oE '[^/]+$') echo "eval \"\$(direnv hook $SHELL_NAME)\"" >> $HOME/.${SHELL_NAME}rc && eval "$(direnv hook $SHELL_NAME)"` | https://direnv.net                                                            |
| jq         | `sudo apt-get install -y jq`                                                                                                                                                                  | https://stedolan.github.io/jq/                                                |
| yq         | `sudo apt-get install -y snap && sudo snap install yq`                                                                                                                                        | https://mikefarah.gitbook.io/yq/                                              |

> If you install NixOS and direnv, you do not need to install yq, jq or GNU Make

## Cheatsheet

### Definitions

- **live medium** - the ISO image and filesystem
- **live system** - the operating system booted from the live medium
- **installed system** - the operating system installed from debian installer
- **chroot stage** - stage when building the image
- **binary stage** - stage when building the live medium

### File Structure

`config/archives/*.{list,key}.binary` - repositories added to _live system_ `/etc/apt/sources.list.d/`
`config/archives/*.{list,key}.chroot` - repositories loaded during the _chroot stage_
`config/includes.binary/*` - files to include in the _live medium's_ filesystem
`config/includes.chroot/*` - files to include in the _live system's_ filesystem
`config/includes.installer/*` - configuration for debian installer
`config/package-lists/*.list.binary` - packages to place in the APT `pool/` repository on the _live medium_ (for offline packages)
`config/package-lists/*.list.chroot` - packages to install in the _live system_ (which will most likely be added to the _installed system_)
`config/package-lists/*.list.chroot_install` - packages to install in the _live system_ and _installed system_
`config/package-lists/*.list.chroot_live` - packages to install in the _live system_ only (works by uninstalling them from _installed system_)

- I'm not sure exactly what the difference between `config/package-lists/*.list.chroot` and
  `config/package-lists/*.list.chroot_install` are.

### Mounts

#### Debian Installer

- **live medium** - `/cdrom`
- **installed system** - `/target`

#### Calamares

## Resources

https://debian-live-config.readthedocs.io/en/latest/custom.html
https://github.com/elementary/os/wiki/Building-ISO-Images
https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html
