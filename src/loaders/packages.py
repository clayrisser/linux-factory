from util import download
from datetime import datetime
from yaml import SafeLoader
import glob
import hashlib
import os
import re
import yaml


class PackagesLoader:
    name = "packages"

    DEB_REGEX = r"[^:]+:\/\/.+\.deb$"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        packages = await self.get_packages()
        for p in packages:
            await self.load_package(Package(p))
        if not os.path.exists(
            os.path.join(self.deb.paths["lb"], "config/packages.chroot")
        ):
            os.makedirs(os.path.join(self.deb.paths["lb"], "config/packages.chroot"))
        for d in (
            glob.glob(os.path.join(self.deb.paths["os"], "packages") + "*.deb")
            + glob.glob(os.path.join(self.deb.paths["os"], "packages") + "**/*.deb")
            + glob.glob(os.path.join(self.deb.paths["os"], ".debs/*.deb"))
        ):
            os.system(
                "dpkg-name -s "
                + os.path.join(self.deb.paths["lb"], "config/packages.chroot")
                + " -o "
                + d
            )

    async def get_packages(self):
        packages = []
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], "packages/**/*.yaml")
        ) + glob.glob(os.path.join(self.deb.paths["os"], "packages/*.yaml")):
            with open(path) as f:
                data = yaml.load(f, Loader=SafeLoader)
                packages += data
        return packages

    async def load_package(self, package):
        if not not re.match(self.DEB_REGEX, package.package):
            if not os.path.exists(os.path.join(self.deb.paths["os"], ".debs")):
                os.makedirs(os.path.join(self.deb.paths["os"], ".debs"))
            md5_hash = hashlib.md5()
            md5_hash.update(str(datetime.now()).encode("utf-8"))
            digest = md5_hash.hexdigest()
            await download(
                package.package,
                os.path.join(self.deb.paths["os"], ".debs", digest + ".deb"),
            )
        else:
            if not os.path.exists(
                os.path.join(
                    self.deb.paths["lb"],
                    "config/package-lists",
                )
            ):
                os.makedirs(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config/package-lists",
                    )
                )
            if package.live and package.installed:
                with open(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config/package-lists/packages.list.chroot_install",
                    ),
                    "a",
                ) as f:
                    f.write(package.package + "\n")
            elif package.live and not package.installed:
                with open(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config/package-lists/packages.list.chroot_live",
                    ),
                    "a",
                ) as f:
                    f.write(package.package + "\n")
            elif not package.live and package.installed:
                # TODO: add to calamares/modules/packages.conf and includes.installer/preseed.cfg
                pass
            if package.binary:
                with open(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config/package-lists/packages.list.binary",
                    ),
                    "a",
                ) as f:
                    f.write(package.package + "\n")


class Package:
    def __init__(self, package):
        if type(package) is not dict:
            package = {"package": package}
        self.live = package["live"] if "live" in package else True
        self.installed = package["installed"] if "installed" in package else True
        self.binary = package["binary"] if "binary" in package else False
        self.package = package["package"].strip()
