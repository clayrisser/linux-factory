# Building a custom Debian ISO image

## Building an ISO image using the default configuration

Install [Debian](https://www.debian.org). You must build from the same distribution as the target distribution (build *stable* systems on a build machine running Debian *stable*, *testing* systems on a machine running Debian *testing*...). The run the following commands (as root):

```bash
# install requirements
apt install make git sudo live-build

# clone the repository
git clone https://gitlab.com/nodiscc/debian-live-config

# build the ISO image
cd debian-live-config && make install_buildenv && make
```

You need some disk space for the download and build caches. The build directory grows to about 13GB using the default configuration.


## Building a custom ISO image

The [`Makefile`](../Makefile) handles the high-level build process (download of extra components, tests and documentation generation, running the build, generating/signing checksums...)

The actual process of building the image is handled by Debian's [live-build](https://www.debian.org/devel/debian-live/) suite of tools. The rest of this page describes how to change the build configuration at a basic level. For more details, read the `live-build` documentation:

* [Live Systems manual](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html)
* [`man lb config`](httpshttps://manpages.debian.org/buster/live-build/lb_config.1.en.html)
* [`man lb build`](https://manpages.debian.org/buster/live-build/lb_build.1.en.html)
* [`man lb clean`](https://manpages.debian.org/buster/live-build/lb_clean.1.en.html)
* [`man live-build`](https://manpages.debian.org/stretch/live-build/live-build.7.en.html)
* `/usr/share/doc/live-manual/pdf/live-manual.portrait.en.a4.pdf.gz` ([live-manual](https://packages.debian.org/buster/live-manual) package)



`live-build` is configured through files under the `auto/` and `config/` directories.

```
.
├── auto                        #main live-build configuration
├── config
│   ├── archives                #package mirrors/repositories
│   ├── hooks                   #extra scripts to run during build stages
│   ├── includes.binary         #files to include on the ISO filesystem
│   ├── includes.chroot         #files to include in the live system's filesystem
│   ├── includes.installer      #files to include in the installer's filesystem
│   ├── package-lists
│   │   └── *.list.chroot		#packages to install on the live system
│   │   └── *.list.binary		#packages to place in the APT repository on the ISO image
│   ├── packages.chroot         #standalone .deb packages to install on the live system
│   └── task-lists              #tasksel tasks to install on the live system
├── doc			#user documentation
├── Makefile	#main automation, dependencies management, ...
└── scripts		#extra automation scripts

```

### auto/

* `auto/config` sets basic configuration settings for the build (architecture, boot configuration, installer...), see [`man lb config`](httpshttps://manpages.debian.org/buster/live-build/lb_config.1.en.html)
* `auto/clean` is run automatically before each build to ensure the build directory is free of any artifacts from previous builds (download caches are kept). See [`man lb clean`](https://manpages.debian.org/buster/live-build/lb_clean.1.en.html)
* `auto/build` contains the command used for the build, and basic logging settings


### config/includes.chroot/

Files to copy to the resulting live system (used include modified configuration or data files under `etc/, opt/, usr/, ...`)

Scripts and data that do not belong to an existing Debian package _should_ be distributed as [custom packages](http://wiki.debian.org/Packaging), and not stashed directly into the directory. Debian packages can also handle custom configuration files (see [`man dpkg-divert`](https://manpages.debian.org/buster/dpkg/dpkg-divert.1.en.html)).


### config/package-lists/

* `*.chroot`: lists of packages to install on the resulting image/system
* `*.binary`: lists of additional packages to add to the ISO image `pool/` directory (to use as an offline repository/mirror) (not required for the live system to work)

Simply use the `.list` extension to install packages in the live system and include them as well in the `pool/` directory in the ISO image.


### config/packages.chroot/

`.deb` packages placed here will be installed to the live system.

Useful if:

- You need a package that is not available in Debian (see [requests for packaging](http://wnpp.debian.net/))
- The package can be downloaded as a standalone `.deb` on the original project website OR you want to build a package yourself
- You don't want to add a third-party repository to your APT sources list (see below).

Reasons to NOT use this:

 - Packages placed here will _not_ receive upgrades through APT (unless they are someday added to official Debian repositories)
 - Packages placed here are not GPG-signed. Ensure you download/build the package over a secure channel.


### config/includes.installer/

`preseed.cfg` is used to preconfigure the _installer_ using [preseeding](https://wiki.debian.org/Preseed).


### config/preseed/

`*.chroot.cfg` used to preseed debconf values for the _resulting live system_.


### config/hooks/

Scripts used to run arbitrary commands at different stages of the build (`*.hook.chroot` or `.*chroot.binary`). See `/usr/share/doc/live-build/examples/hooks/` for examples.


### config/includes.binary/

Additional files to place at the root of the ISO image filesystem (these files will be directly accessible when mounting the ISO).

## Other

### Setting the locale/language

Currently only 2 locales (english and french) are pre-generated, other languages have to be manually added to the build configuration, and the ISO rebuilt.


### Release process

 - [ ] `make bump_version`, update version indicators
 - [ ] `git tag --sign $new_version`
 - [ ] `make && make checksums && make sign_checksums`
 - [ ] Download the ISO from the build machine `make download_iso`
 - [ ] Test that the image is less than 2GB in size (optional)
 - [ ] `make test_kvm_bios`, test live mode in all languages
 - [ ] `make test_kvm_bios`, test offline installation
 - [ ] `make test_kvm_bios`, Test online installation
 - [ ] `make test_kvm_uefi`, test offline installation
 - During installation, test the following disk partitioning schemes:
   - [ ] Automatic whole disk encrypted LVM
   - [ ] Automated whole disk LVM
   - [ ] Automated whole disk partitioning
   - [ ] Manual
 - [ ] Update the changelog


## See also

 - **https://wiki.debian.org/**
 - https://stdout.root.sx/links/?searchtags=debian
