import os
from util import merge_dirs


class HooksLoader:
    name = "hooks"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dirs(
            os.path.join(self.deb.paths["os"], "hooks"),
            os.path.join(
                self.deb.paths["installer_install"],
                "hooks",
            ),
        )
        await merge_dirs(
            os.path.join(self.deb.paths["os"], "hooks"),
            os.path.join(
                self.deb.paths["chroot_install"],
                "hooks",
            ),
        )
