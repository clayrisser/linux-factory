import os
from util import merge_dir


class FilesystemLoader:
    name = "filesystem"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dir(
            os.path.join(self.deb.paths["os"], "filesystem/binary"),
            os.path.join(self.deb.paths["lb"], "config/includes.binary/"),
        )
        await merge_dir(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(self.deb.paths["lb"], "config/includes.chroot/"),
        )
        await merge_dir(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(
                self.deb.paths["lb"],
                "config/includes.installer/root/install/filesystem",
            ),
        )
        await merge_dir(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(
                self.deb.paths["lb"],
                "config/includes.chroot/root/install/filesystem",
            ),
        )
