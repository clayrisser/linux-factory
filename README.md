# 🐧🏭 linux-factory

> a framework used to create custom linux debian operating systems

![](assets/linux-factory.jpeg)

## Usage

### Building

Edit configurations in the `os/config.yaml`, activate custom overlays and when ready . . .

```
make build
```

Once the build has been completed, you can find the iso installer located in the `.build/lb` folder.

### Reset Environment

Run the following command to completely reset your environment.

```sh
sudo git clean -fxd
```

> Please note that if you stopped the build in the middle of execution (for example `CTRL-C`),
> it's possible you will get a permission error. If this happens you may need to restart your
> computer and try resetting after you have rebooted.

## Dependencies

This system can only be built from a Debian based operating system. While
any Debian based operating system should work, this is only tested against
the official Debian distribution on amd64.

You can install all of the dependencies with the following command.

```sh
sudo apt-get install -y imagemagick make git git-lfs grub-emu live-build python3 jq python3-poetry-core python3-venv snapd && sudo snap install yq
```

### Required

| Name        | Install                                                 | Url                                                                           |
| ----------- | ------------------------------------------------------- | ----------------------------------------------------------------------------- |
| GNU Make    | `sudo apt-get install -y make`                          | https://www.gnu.org/software/make                                             |
| Git         | `sudo apt-get install -y git`                           | https://git-scm.com                                                           |
| Git LFS     | `sudo apt-get install -y git-lfs`                       | https://git-lfs.com                                                           |
| ImageMagick | `sudo apt-get install -y imagemagick`                   | https://imagemagick.org                                                       |
| Live Build  | `sudo apt-get install -y live-build`                    | https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html |
| Python 3    | `sudo apt-get install -y python3`                       | https://www.python.org                                                        |
| jq          | `sudo apt-get install -y jq`                            | https://stedolan.github.io/jq                                                 |
| poetry      | `sudo apt-get install -y python3-poetry-core`           | https://python-poetry.org                                                     |
| virtualenv  | `sudo apt-get install -y python3-venv`                  | https://virtualenv.pypa.io                                                    |
| yq          | `sudo apt-get install -y snapd && sudo snap install yq` | https://mikefarah.gitbook.io/yq                                               |

### Optional

| Name          | Install                            | Url                                                             |
| ------------- | ---------------------------------- | --------------------------------------------------------------- |
| Grub Emulator | `sudo apt-get install -y grub-emu` | https://manpages.debian.org/testing/grub-emu/grub-emu.1.en.html |

## Overlays

Overlays are configurable, flexible and decoupled customizations that get applied to the operating system build. They
can be mixed and matched with other overlays, or be completely disabled if you don't want those changes.

Overlays get _"overlayed"_ on top of the `os` directory during the build. This means the file structure inside
of an overlay and the file structure of the `os` directory are identical.

### Example

The example overlay showcases the capabilities of an overlay. You can use it as a
starting point for one of your overlays, or simply use it as a reference.

[overlays/example](overlays/example)

### Debian Installer

The Debian Installer is the official installation system for the Debian operating system.
It provides a user-friendly interface for installing Debian on a wide range of hardware,
from desktops and laptops to servers and embedded systems. The Debian Installer supports
multiple languages, network installations, and a variety of disk partitioning options. With
its flexible and customizable design, the Debian Installer is a popular choice for many
users who are looking to install Debian on their systems.

[overlays/debianInstaller](overlays/debianInstaller)

### Grub

GRUB (GRand Unified Bootloader) is a boot loader package from the GNU Project. It is used to
boot Linux operating systems, as well as a number of other operating systems. In the context
of this system, Grub can be used as an overlay to customize the boot loader.

[overlays/debianInstaller](overlays/debianInstaller)

### Sway

Sway is a tiling window manager for Wayland. It provides a tiling window manager
experience for users who are looking for a modern, keyboard-driven interface. In the
context of this system, Sway can be used as an overlay to provide a tiling
window manager for the target system.

[overlays/sway](overlays/sway)

## Overlay Components

### Fonts

Supports `zip`, `tar` and `tar.gz` files that contain `.ttf` or `.otf` fonts

### Packages

### Repos

### Filesystem

### Prompt

#### Types

- `string`
- `boolean`
- `select`
- `multiselect`
- `error`
- `note`
- `password`

### Hooks

To use the hooks in your overlay, you will need to create a file named overlay.py within your overlay directory. This file should contain a class named OverlayHooks that implements methods for each hook.

Each hook has two corresponding methods, one for before the stage is executed and one for after the stage is executed. There are currently three stages in the process: build, config, and prepare. This means the following hooks are available for you to use:

- `before_build()`
- `after_build()`
- `before_config()`
- `after_config()`
- `before_prepare()`
- `after_prepare()`

For example, if you wanted to run some custom code before the build stage is executed, you could implement the following in your overlay.py file:

_overlay.py_

```py
class OverlayHooks:
    def before_build(self):
        # Your custom code here
```

It's important to note that the order in which hooks are executed is determined by the order in which the overlays are specified. Make sure to take this into consideration when implementing your hooks.

### Script Hooks

> Script hooks are a linux-factory concept and should not be confused with the live build hooks available at `lb/hooks/`.

During the installation process, there are two script hooks that can be utilized, `post-install` and `user-post-install`.

#### Location of Script Hooks

Script hooks should be placed in the `hooks/<hook>` folder. All scripts within the specified
folder will be executed during the corresponding hook.

> the name of the script should be the same name as your overlay to prevent collisions with hooks from other overlays

#### Execution of Script Hooks

- `user-post-install`: This script hook will execute after the system has been installed as the newly created user.
- `post-install`: This script hook will also execute after the system has been installed, but it runs as the root user.

#### Example

Here's an example of how you can utilize the user-post-install script hook.

Create a folder named user-post-install in the hooks directory and add a file named script.sh in it. In the script.sh file, you can add the following code.

_hooks/user-post-install/\<overlay\>.sh_

```sh
#!/bin/sh

echo "Running user-post-install script"
```

## Live Build Cheatsheet

### Definitions

- **live medium** - the ISO image and filesystem
- **live system** - the operating system booted from the live medium
- **installed system** - the operating system installed from debian installer
- **chroot stage** - stage when building the image
- **binary stage** - stage when building the live medium (binary can also refer to the debian installer)

### File Structure

- `config/archives/*.{list,key}.binary` - repositories added to _live system_ `/etc/apt/sources.list.d/`
- `config/archives/*.{list,key}.chroot` - repositories loaded during the _chroot stage_
- `config/includes.binary/*` - files to include in the _live medium's_ filesystem
- `config/includes.chroot/*` - files to include in the _live system's_ filesystem
- `config/includes.installer/*` - configuration for debian installer
- `config/package-lists/*.list.binary` - packages to place in the APT `pool/` repository on the _live medium_ (for offline packages)
- `config/package-lists/*.list.chroot_install` - packages to install in the _live system_ and _installed system_
- `config/package-lists/*.list.chroot_live` - packages to install in the _live system_ only (works by uninstalling them from _installed system_)
- `config/package-lists/*.list.chroot` - packages to install in the _live system_ (which will most likely be added to the _installed system_)
- `config/packages.binary` - udeb packages to install for the debian installer
- `config/packages.chroot` - deb packages to install for the live system

_I'm not sure exactly what the differences between `config/package-lists/*.list.chroot` and
`config/package-lists/*.list.chroot_install` are._

> WARNING: _binary_ unfortunately has many different meanings in the documentation depending on the context. The following table helps clarify the context of binary.

| binary                                | refers to             |
| ------------------------------------- | --------------------- |
| `config/archives/*.{list,key}.binary` | _live system_         |
| `config/includes.binary/*`            | _live medium_         |
| `config/package-lists/*.list.binary`  | _live medium_ `/pool` |
| `config/packages.binary`              | _debian installer_    |

> WARNING: `config/archives/*.{list,key}.chroot` does not make the repositories available to the _live system_. Instead you must use `config/archives/*.{list,key}.binary` for the repositories to be available to the _live system_.

### Mounts

- **live medium** - `/cdrom` if debian installer or `/run/live/medium` from live system
- **installed system** - `/target` if debian installer or `/tmp/calamares-root-*` if calamares

## Resources

- https://bugs.launchpad.net/subiquity/+bug/1960068
- https://debian-live-config.readthedocs.io/en/latest/custom.html
- https://discourse.ubuntu.com/t/automated-server-install-reference/16613/21
- https://github.com/elementary/os/wiki/Building-ISO-Images
- https://help.ubuntu.com/community/InstallCDCustomization
- https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html
- https://manpages.debian.org/unstable/live-build/lb_config.1.en.html
