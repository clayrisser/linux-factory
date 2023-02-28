import glob
from time import sleep
import logging
from util import mkdirs
import shutil
import os


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def before_prepare(self):
        logging.warn("\033[1;33mUNSTABLE: calamares overlay is unstable\033[0m")
        sleep(5)

    async def before_loader_filesystem(self):
        await mkdirs(
            os.path.join(
                self.deb.paths["os"], "filesystem/live/etc/calamares/branding/debian"
            )
        )
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], "assets/calamares/*.png"),
            include_hidden=True,
        ):
            await mkdirs(
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/live/etc/calamares/branding/debian",
                )
            )
            shutil.copyfile(
                path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/live/etc/calamares/branding/debian",
                    get_filename_from_path(path),
                ),
            )

    async def after_lb(self):
        remove_packages = []
        for path in glob.glob(
            os.path.join(
                self.deb.paths["lb"],
                "config-overrides/package-lists/*.list.chroot_live",
            ),
            include_hidden=True,
        ):
            with open(path) as f:
                for line in f.readlines():
                    line = line.strip()
                    if len(line) > 0 and line[0] != "#":
                        remove_packages.append(line)
        if len(remove_packages) > 0:
            lines = []
            with open(
                os.path.join(
                    self.deb.paths["lb"],
                    "config-overrides/includes.chroot/etc/calamares/modules/packages.conf",
                ),
            ) as f:
                for line in f.readlines():
                    if line == "  - remove: []\n":
                        lines.append("  - remove:\n")
                        for remove_package in remove_packages:
                            lines.append("      - " + remove_package + "\n")
                    elif line.strip() == "  - remove:\n":
                        for remove_package in remove_packages:
                            lines.append("      - " + remove_package + "\n")
                    else:
                        lines.append(line)
            with open(
                os.path.join(
                    self.deb.paths["lb"],
                    "config-overrides/includes.chroot/etc/calamares/modules/packages.conf",
                ),
                "w",
            ) as f:
                f.write("".join(lines))
