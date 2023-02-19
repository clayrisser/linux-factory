import os
from util import merge_dirs_templates


class FilesystemLoader:
    name = "filesystem"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dirs_templates(
            os.path.join(self.deb.paths["os"], "filesystem/binary"),
            os.path.join(self.deb.paths["lb"], "config-overrides/includes.binary"),
            deb=self.deb,
        )
        await merge_dirs_templates(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
                os.path.join(self.deb.paths["os"], "filesystem/installer_live"),
                os.path.join(self.deb.paths["os"], "filesystem/live"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installer"),
            ],
            os.path.join(self.deb.paths["lb"], "config-overrides/includes.chroot"),
            deb=self.deb,
        )
        await merge_dirs_templates(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installer"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installer"),
                os.path.join(self.deb.paths["os"], "filesystem/installer_live"),
            ],
            os.path.join(self.deb.paths["lb"], "config-overrides/includes.installer"),
            deb=self.deb,
        )
        await merge_dirs_templates(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(
                self.deb.paths["installer_install"],
                "filesystem",
            ),
            deb=self.deb,
        )
        await merge_dirs_templates(
            [
                os.path.join(self.deb.paths["os"], "filesystem/installed"),
                os.path.join(self.deb.paths["os"], "filesystem/live_installed"),
                os.path.join(self.deb.paths["os"], "filesystem/installed_live"),
            ],
            os.path.join(
                self.deb.paths["chroot_install"],
                "filesystem",
            ),
            deb=self.deb,
        )
