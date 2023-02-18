import os
from util import merge_dirs_templates


class LBLoader:
    name = "lb"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dirs_templates(
            os.path.join(self.deb.paths["os"], "lb"),
            os.path.join(self.deb.paths["lb"], "config-overrides"),
            deb=self.deb,
        )
