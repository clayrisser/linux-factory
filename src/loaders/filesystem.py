import os
from util import merge_dirs


class FilesystemLoader:
    name = "filesystem"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dirs(
            os.path.join(self.deb.paths["os"], "filesystem/binary"),
            os.path.join(self.deb.paths["lb"], "config-overrides/includes.binary"),
        )
        await merge_dirs(
            [
                os.path.join(self.deb.paths["os"], "filesystem/live"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(self.deb.paths["lb"], "config-overrides/includes.chroot"),
        )
        await merge_dirs(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(
                self.deb.paths["installer_install"],
                "filesystem",
            ),
        )
        await merge_dirs(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(
                self.deb.paths["chroot_install"],
                "filesystem",
            ),
        )
