# debian-live-config

A [Debian GNU/Linux](https://www.debian.org/) live system/installer, preconfigured for generic personal computers/workstations.

This repository contains the `live-build` configuration and scripts used to build a custom Debian ISO image. See [doc/custom.md](doc/custom.md).

![](https://i.imgur.com/1QdF9N7.png)


----------------

**Table of contents**

<!-- MarkdownTOC levels=2 -->

- [Features](#features)
- [Hardware Requirements](#hardware-requirements)
- [Download](#download)
- [Writing the bootable media](#writing-the-bootable-media)
- [Booting the ISO](#booting-the-iso)
- [Running the live system](#running-the-live-system)
- [Installing the system](#installing-the-system)
- [Usage](#usage)
- [Maintenance & security](#maintenance--security)
- [Issues](#issues)
- [Changelog](#changelog)
- [License](#license)

<!-- /MarkdownTOC -->

---------------

## Features

- Install a ready-to-use system in less than ~10 minutes, without Internet access, or run it [live](https://en.wikipedia.org/wiki/Live_USB) from USB/DVD (no installation required)
- Preinstalled [software](doc/packages.md) for most office/multimedia/internet tasks, [preconfigured](config/includes.chroot/) for personal computers
- Lightweight [desktop environment](https://docs.xfce.org/start)/low resource usage (low-end hardware, old/recycled machines...), low power consumption
- Fits on a 2GB USB drive
- Based on Debian [stable](https://wiki.debian.org/DebianStable) + [backports](https://wiki.debian.org/Backports), reliable, low maintenance


## Hardware Requirements

- Computer with x86_64 CPU
- Memory: min 1024MB, recommended 2GB+
- Recommended storage: 15GB+ hard drive or SSD (operating system and programs), 10-∞GB (user data)
- 2GB+ USB drive or DVD-R for the installation media


## Download

**[Download](https://github.com/nodiscc/dlc/releases/files/dlc-2.0.0-amd64.iso)** the latest ISO image

It is optional but recommended to verify the ISO image against cryptographic signatures, to ensure downloaded files are valid and authentic. Download `dlc-release.key`, `SHA512SUMS.sign` and `SHA512SUMS` from the [releases page](https://github.com/nodiscc/dlc/releases), to the same directory as the `iso` file.

```bash
# import the release signing key
# the key used to sign releases has key ID 16C50725859EBE2DD1B22100BCC63E85387671B9
gpg --import dlc-release.key
# verify that checksums are authentic
gpg --verify SHA512SUMS.sign
# verify integrity of the ISO image
sha512sum -c SHA512SUMS
```


## Writing the bootable media

#### To USB - From Linux

  * Insert a 2GB+ USB drive
  * Right-click the ISO image file, and click `Open with ... > Disk image writer` (requires [gnome-disks](https://packages.debian.org/buster/gnome-disk-utility)) **Caution, all data on the USB drive will be erased**
  * Or, using the command line: Identify your USB drive device name (eg. `/dev/sdc`) using the `lsblk` command; Write the ISO image to the drive using `sudo dd /path/to/live-image.iso /dev/sdXXX`.


#### To USB - From Windows

  * Insert a blank 2GB+ USB drive
  * Download [win32diskimager](http://sourceforge.net/projects/win32diskimager/files/latest/download), extract it in a directory, then run the program.
  * `Image file`: select your ISO image.
  * `Device`: Select your USB drive's drive letter.
  * Press `Write`. **Caution, all data on the USB drive will be erased**


#### To DVD

  * Select "burn a disk image" in your disk burning utility (Windows: [InfraRecorder](http://infrarecorder.org/?page_id=5))


#### Virtualization

You can also run the system in a virtual machine on top of your existing system. In that case writing a bootable drive is not needed and you can simply load the `.iso` file in the virtual machine's CD drive. Free and open-source virtualization software includes [virt-manager](https://stdout.root.sx/docs/virt-manager.md) (Linux) or [VirtualBox](https://www.virtualbox.org) (Linux/MacOS/Windows).


## Booting the ISO

- Turn your computer off. Insert the bootable USB/DVD, and turn it back on.
- The boot menu will be displayed, allowing you to install the operating system or run it in Live mode.

| 💥 | If your computer does not boot to the DVD/USB, check that [BIOS/EFI boot configuration](http://www.makeuseof.com/tag/enter-bios-computer/) utility is configured to boot from CD/DVD or USB. |
|---------|---------|

| 💥 | On some computers you need to [disable secure boot](https://neosmart.net/wiki/disabling-secure-boot/) before installing a Linux distribution. |
|---------|---------|


## Running the live system

A live system runs entirely in memory and allows you to use the operating system without installing it to your machine.

No changes to the Live filesystem are kept after reboot, (eg. files in user directories), the system will reset to it's original state when the computer is powered off/rebooted. Changes to files/directory on other drives (external/USB drive, existing fixed disk...) attached to the computer _will_ be kept - save your work there if you need to keep your changes.

The screen will lock after 5 minutes of inactivity during the live session. The passord to unlock it is `live`.


## Installing the system

Select `Graphical install` from the boot menu to install a permanent copy a of the system to your hard drive. Follow instructions from the installer.

| 💥 | Installation in UEFI boot mode is curently broken. [Disable secure boot](https://neosmart.net/wiki/disabling-secure-boot/) and [enable legacy BIOS boot mode](https://neosmart.net/wiki/enable-legacy-boot-mode/) before running the installer. |
|---------|---------|

| 💥 | The default drive partitioning configuration overwrites any previously installed operating system/data on the selected installation disk. To preserve your data, use manual partitioning in the installer, install to an empty disk, or backup your data to an external drive if needed. |
|---------|---------|

<!--
**Troubleshooting:** If you get the message `Failed to determine the codename for the release` during installation, unplug the USB drive, insert it again, open a shell from the installer menu, identify the device name for the USB drive (run `parted_devices`), and remount the USB drive under `/cdrom/` (run `mount /dev/sdX1 /cdrom/` where `sdX` is your USB device).
-->

-----------------------------------


## Usage

Head to the **[Debian wiki](https://wiki.debian.org)** for information on how to use your Debian/GNU Linux system.


## Maintenance & security

 * Only install software from your [package manager](#installingremoving-software-packages), do not run or install software or commands for untrusted sources.
 * Backup your data periodically to an external storage using the [Back In Time](https://backintime.readthedocs.io/en/latest/quick-start.html) backup utility
 * Only enter your administrator password to perform necessary system administration tasks.
 * Use strong (long) passwords/phrases, do not reuse passwords for different services (use the a password manager). Use encrypted network communication protocols (HTTPS, SSH/SFTP, OTR, GPG...), use disk encryption.
 * Keep your hardware in good condition.


## Issues

* [Gitlab issue tracker](https://gitlab.com/nodiscc/dlc) 
* [TODO.md](TODO.md)


## Changelog

[CHANGELOG.md](CHANGELOG.md)

## License

[GPL-3.0](LICENSE)

