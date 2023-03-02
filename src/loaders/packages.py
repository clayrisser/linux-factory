from util import download, shell, merge_dirs, mkdirs
from yaml import SafeLoader
import glob
import os
import re
import shutil
import yaml


class PackagesLoader:
    name = "packages"

    URI_REGEX = r"[^:]+:\/\/.+\.deb$"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        packages = await self.get_packages()
        if not "packages" in self.deb.data:
            self.deb.data["packages"] = []
        if not "debs" in self.deb.data:
            self.deb.data["debs"] = []
        for p in packages:
            await self.load_package(Package(p))
        if not os.path.exists(
            os.path.join(self.deb.paths["lb"], "config-overrides/packages.chroot")
        ):
            os.makedirs(
                os.path.join(self.deb.paths["lb"], "config-overrides/packages.chroot")
            )
        for d in glob.glob(
            os.path.join(self.deb.paths["os"], ".debs/**/*.deb"),
            recursive=True,
            include_hidden=True,
        ):
            shell(
                "dpkg-name -s "
                + os.path.join(self.deb.paths["lb"], "config-overrides/packages.chroot")
                + " -o "
                + d
            )
        if (
            len(
                glob.glob(
                    os.path.join(
                        self.deb.paths["lb"], "config-overrides/packages.chroot"
                    ),
                    include_hidden=True,
                )
            )
            > 0
        ):
            await merge_dirs(
                os.path.join(self.deb.paths["lb"], "config-overrides/packages.chroot"),
                os.path.join(self.deb.paths["installer_install"], "debs"),
            )
            await merge_dirs(
                os.path.join(self.deb.paths["lb"], "config-overrides/packages.chroot"),
                os.path.join(self.deb.paths["chroot_install"], "debs"),
            )

    async def get_packages(self):
        packages = []
        package_names = set()
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], "packages/**/*.yaml"),
            recursive=True,
            include_hidden=True,
        ):
            with open(path) as f:
                data = yaml.load(f, Loader=SafeLoader)
                if not type(data) is list:
                    continue
                for package in data:
                    package_name = None
                    if type(package) == str:
                        package_name = package
                    elif "package" in package:
                        package_name = package["package"]
                    if type(package_name) is str and package_name not in package_names:
                        package_names.add(package_name)
                        packages.append(package)
        return packages

    async def load_package(self, package):
        if not not re.match(self.URI_REGEX, package.package):
            self.deb.data["debs"].append(package)
            await mkdirs(os.path.join(self.deb.paths["os"], ".debs"))
            await download(
                package.package,
                os.path.join(
                    self.deb.paths["os"], ".debs", str(hash(package.package)) + ".deb"
                ),
            )
        elif package.package[-4:] == ".deb":
            if package.live or package.installed:
                await mkdirs(os.path.join(self.deb.paths["os"], ".debs"))
                shutil.copyfile(
                    os.path.join(self.deb.paths["os"], "packages", package.package),
                    os.path.join(
                        self.deb.paths["os"],
                        ".debs",
                        str(hash(package.package)) + ".deb",
                    ),
                )
        else:
            self.deb.data["packages"].append(package)
            if not os.path.exists(
                os.path.join(
                    self.deb.paths["lb"],
                    "config-overrides/package-lists",
                )
            ):
                os.makedirs(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config-overrides/package-lists",
                    )
                )
            if package.live and package.installed:
                with open(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config-overrides/package-lists/packages.list.chroot",
                    ),
                    "a",
                ) as f:
                    f.write(package.package + "\n")
            elif package.live and not package.installed:
                with open(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config-overrides/package-lists/packages.list.chroot_live",
                    ),
                    "a",
                ) as f:
                    f.write(package.package + "\n")
            elif not package.live and package.installed:
                # add to calamares/modules/packages.conf and includes.installer/preseed.cfg
                # handled by overlays
                pass
            if package.binary:
                with open(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config-overrides/package-lists/packages.list.binary",
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
