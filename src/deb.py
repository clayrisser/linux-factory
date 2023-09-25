from hooks import Hooks
from overlay import Overlay
from util import merge_dict
from yaml.loader import SafeLoader
import os
import subprocess
import yaml

_paths = None


class Deb:
    def __init__(self, config):
        self._config = config
        self._overlays = None
        self._envs = None
        self._additional_envs = {}
        self.data = {}

    hooks = Hooks()

    @property
    def paths(self):
        return Deb._get_paths()

    @property
    def overlays(self) -> list[Overlay]:
        if self._overlays:
            return self._overlays
        self._overlays = {}
        for overlay_name, overlay_config in (
            self._config["overlays"]
            if ("overlays" in self._config and self._config["overlays"])
            else {}
        ).items():
            overlay_path = os.path.join(self.paths["root"], "overlays", overlay_name)
            if not overlay_config:
                overlay_config = {}
            if os.path.exists(os.path.join(overlay_path, "config.yaml")):
                with open(os.path.join(overlay_path, "config.yaml")) as f:
                    overlay_config = merge_dict(
                        yaml.load(f, Loader=SafeLoader), overlay_config
                    )
            overlay_config["name"] = overlay_name
            overlay_config["path"] = overlay_path
            self._overlays[overlay_name] = Overlay(overlay_config)
        return self._overlays

    @property
    def _lb(self):
        return (
            self._config["lb"]
            if "lb" in self._config and self._config["lb"] is not None
            else {}
        )

    @property
    def arch(self):
        out = ""
        try:
            out = (
                subprocess.run(["dpkg", "--print-architecture"], stdout=subprocess.PIPE)
                .stdout.decode("utf-8")
                .strip()
            )
        except FileNotFoundError:
            try:
                out = (
                    subprocess.run(["uname", "-m"], stdout=subprocess.PIPE)
                    .stdout.decode("utf-8")
                    .strip()
                )
            except FileNotFoundError:
                out = (
                    subprocess.run(["arch"], stdout=subprocess.PIPE)
                    .stdout.decode("utf-8")
                    .strip()
                )
        arch = out.lower()
        if arch == "i386":
            arch = "386"
        elif arch == "i686":
            arch = "386"
        elif arch == "x86_64":
            arch = "amd64"
        return arch

    @property
    def envs(self):
        envs = {}
        for key, value in self.lb_envs.items():
            envs[key] = value
        for key, value in self._additional_envs.items():
            envs[key] = value
        return envs

    @property
    def name(self):
        return self._config["name"] if "name" in self._config else "DEB Distro"

    @property
    def distribution(self):
        return (
            self._config["distribution"]
            if "distribution" in self._config
            else "bullseye"
        )

    @property
    def lb_envs(self):
        if self._envs:
            return self._envs
        arch = self._config["arch"] if "arch" in self._config else self.arch
        kernel_version = (
            self._config["kernelVersion"] if "kernelVersion" in self._config else None
        )
        name = self.name
        website = (
            self._config["website"]
            if "website" in self._config
            else "https://risserlabs.com"
        )
        email = (
            self._config["email"] if "email" in self._config else "info@risserlabs.com"
        )
        locale = self._config["locale"] if "locale" in self._config else "en_US"
        keyboard_layout = (
            self._config["keyboardLayout"] if "keyboardLayout" in self._config else "us"
        )
        mirror = (
            self._config["mirror"]
            if "mirror" in self._config
            else "http://deb.debian.org/debian/"
        )
        mirror_security = (
            self._config["mirrorSecurity"]
            if "mirrorSecurity" in self._config
            else "http://security.debian.org/"
        )
        distribution = (
            self._lb["distribution"]
            if "distribution" in self._lb
            else (self.distribution)
        )
        security = self._config["security"] if "security" in self._config else True
        if distribution == "bullseye":
            security = False
        security = self._lb["security"] if "security" in self._lb else security
        linux_flavours = arch
        if arch == "i386":
            linux_flavours = "686-pae"
        linux_flavours = (
            self._lb["linuxFlavours"] if "linuxFlavours" in self._lb else linux_flavours
        )
        linux_packages = "linux-image linux-headers"
        if kernel_version:
            linux_packages = (
                "linux-image-" + kernel_version + " linux-headers-" + kernel_version
            )
        linux_packages = (
            self._lb["linuxPackages"] if "linuxPackages" in self._lb else linux_packages
        )
        apt = self._lb["apt"] if "apt" in self._lb else "apt"
        apt_indices = self._lb["aptIndices"] if "aptIndices" in self._lb else True
        apt_options = self._lb["aptOptions"] if "aptOptions" in self._lb else "-y"
        apt_recommends = (
            self._lb["aptRecommends"] if "aptRecommends" in self._lb else True
        )
        apt_source_archives = (
            self._lb["aptSourceArchives"] if "aptSourceArchives" in self._lb else True
        )
        architectures = (
            self._lb["architectures"] if "architectures" in self._lb else arch
        )
        archive_areas = (
            self._lb["archiveAreas"]
            if "archiveAreas" in self._lb
            else "main contrib non-free"
            + (" non-free-firmware" if distribution != "bullseye" else "")
        )
        backports = self._lb["backports"] if "backports" in self._lb else True
        binary_images = (
            self._lb["binaryImages"] if "binaryImages" in self._lb else "iso-hybrid"
        )
        bootappend_live = (
            self._lb["bootappendLive"]
            if "bootappendLive" in self._lb
            else (
                "boot=live components username=live locales="
                + locale
                + ".UTF-8 keyboard-layouts="
                + keyboard_layout
            )
        )
        cache = self._lb["cache"] if "cache" in self._lb else True
        checksums = self._lb["checksums"] if "checksums" in self._lb else "sha256"
        debian_installer = (
            self._lb["debianInstaller"] if "debianInstaller" in self._lb else "none"
        )
        debian_installer_gui = (
            self._lb["debianInstallerGui"]
            if "debianInstallerGui" in self._lb
            else False
        )
        debootstrap_options = (
            self._lb["debootstrapOptions"]
            if "debootstrapOptions" in self._lb
            else "--include=apt-transport-https,ca-certificates,openssl"
        )
        debug = self._lb["debug"] if "debug" in self._lb else self.debug
        initsystem = self._lb["initsystem"] if "initsystem" in self._lb else "systemd"
        iso_application = (
            self._lb["isoApplication"] if "isoApplication" in self._lb else name
        )
        iso_publisher = (
            self._lb["isoPublisher"]
            if "isoPublisher" in self._lb
            else name + "; " + website + "; " + email
        )
        iso_volume = self._lb["isoVolume"] if "isoVolume" in self._lb else name
        mirror_bootstrap = (
            self._lb["mirrorBootstrap"] if "mirrorBootstrap" in self._lb else mirror
        )
        mirror_debian_installer = (
            self._lb["mirrorDebianInstaller"]
            if "mirrorDebianInstaller" in self._lb
            else mirror
        )
        mode = self._lb["mode"] if "mode" in self._lb else "debian"
        debian_installer_distribution = (
            self._lb["debianInstallerDistribution"]
            if "debianInstallerDistribution" in self._lb
            else distribution
        )
        parent_debian_installer_distribution = (
            self._lb["parentDebianInstallerDistribution"]
            if "parentDebianInstallerDistribution" in self._lb
            else debian_installer_distribution
        )
        parent_distribution = (
            self._lb["parentDistribution"]
            if "parentDistribution" in self._lb
            else distribution
        )
        parent_mirror_chroot = (
            self._lb["parentMirrorChroot"]
            if "parentMirrorChroot" in self._lb
            else mirror
        )
        parent_mirror_chroot_security = (
            self._lb["parentMirrorChrootSecurity"]
            if "parentMirrorChrootSecurity" in self._lb
            else mirror_security
        )
        system = self._lb["system"] if "system" in self._lb else "live"
        updates = self._lb["updates"] if "updates" in self._lb else True
        if distribution == "sid":
            updates = False
        win32_loader = self._lb["win32Loader"] if "win32Loader" in self._lb else True
        self._envs = {
            "APT": str(apt),
            "APT_INDICES": str(apt_indices).lower()
            if type(apt_indices) is bool
            else str(apt_indices),
            "APT_OPTIONS": str(apt_options),
            "APT_RECOMMENDS": str(apt_recommends).lower()
            if type(apt_recommends) is bool
            else str(apt_recommends),
            "APT_SOURCE_ARCHIVES": str(apt_source_archives).lower()
            if type(apt_source_archives) is bool
            else str(apt_source_archives),
            "ARCHITECTURES": str(architectures),
            "ARCHIVE_AREAS": str(archive_areas),
            "BACKPORTS": str(backports).lower()
            if type(backports) is bool
            else str(backports),
            "BINARY_IMAGES": str(binary_images),
            "BOOTAPPEND_LIVE": str(bootappend_live),
            "CACHE": str(cache).lower() if type(cache) is bool else str(cache),
            "CHECKSUMS": str(checksums),
            "DEBIAN_INSTALLER": str(debian_installer),
            "DEBIAN_INSTALLER_DISTRIBUTION": str(debian_installer_distribution),
            "DEBIAN_INSTALLER_GUI": str(debian_installer_gui).lower()
            if type(debian_installer_gui) is bool
            else str(debian_installer_gui),
            "DEBOOTSTRAP_OPTIONS": str(debootstrap_options),
            "DEBUG": str(debug).lower() if type(debug) is bool else str(debug),
            "DISTRIBUTION": str(distribution),
            "INITSYSTEM": str(initsystem),
            "ISO_APPLICATION": str(iso_application),
            "ISO_PUBLISHER": str(iso_publisher),
            "ISO_VOLUME": str(iso_volume),
            "LINUX_FLAVOURS": str(linux_flavours),
            "LINUX_PACKAGES": str(linux_packages),
            "MIRROR_BOOTSTRAP": str(mirror_bootstrap),
            "MIRROR_DEBIAN_INSTALLER": str(mirror_debian_installer),
            "MODE": str(mode),
            "PARENT_DEBIAN_INSTALLER_DISTRIBUTION": str(
                parent_debian_installer_distribution
            ),
            "PARENT_DISTRIBUTION": str(parent_distribution),
            "PARENT_MIRROR_CHROOT": str(parent_mirror_chroot),
            "PARENT_MIRROR_CHROOT_SECURITY": str(parent_mirror_chroot_security),
            "SECURITY": str(security).lower()
            if type(security) is bool
            else str(security),
            "SYSTEM": str(system),
            "UPDATES": str(updates).lower() if type(updates) is bool else str(updates),
            "WIN32_LOADER": str(win32_loader).lower()
            if type(win32_loader) is bool
            else str(win32_loader),
        }
        return self._envs

    @property
    def debug(self):
        return self._config["debug"] if "debug" in self._config else False

    @property
    def config(self):
        return self._config

    @staticmethod
    def _get_paths():
        global _paths
        if _paths:
            return _paths
        root_path = os.path.realpath(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
        )
        build_path = os.path.join(root_path, ".build")
        _paths = {
            "build": build_path,
            "lb": os.path.join(build_path, "lb"),
            "os": os.path.join(build_path, "os"),
            "root": root_path,
            "tmp": os.path.join(build_path, "tmp"),
            "installer_install": os.path.join(
                build_path, "lb/config-overrides/includes.installer/root/install"
            ),
            "chroot_install": os.path.join(
                build_path, "lb/config-overrides/includes.chroot/root/install"
            ),
        }
        return _paths

    @staticmethod
    async def _load_config(config_path=None):
        paths = Deb._get_paths()
        if not config_path:
            config_path = os.path.join(paths["root"], "os/config.yaml")
        with open(config_path) as f:
            return yaml.load(f, Loader=SafeLoader)

    @staticmethod
    async def create(config={}):
        paths = Deb._get_paths()
        config = merge_dict(await Deb._load_config(), config)
        for overlay_name in (
            config["overlays"] if ("overlays" in config and config["overlays"]) else {}
        ).keys():
            overlay_path = os.path.join(paths["root"], "overlays", overlay_name)
            if os.path.exists(os.path.join(overlay_path, "config.yaml")):
                overlay_config = await Deb._load_config(
                    os.path.join(overlay_path, "config.yaml")
                )
                if "os" in overlay_config and type(overlay_config["os"]) is dict:
                    config = merge_dict(
                        config,
                        overlay_config["os"],
                    )
        return Deb(config)
