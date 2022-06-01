import os
from util import merge_dir, merge_dir_templates


class LBLoader:
    name = "lb"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dir(
            os.path.join(self.deb.paths["os"], "lb"),
            os.path.join(self.deb.paths["lb"], "config-overrides"),
        )
        await merge_dir_templates(
            os.path.join(self.deb.paths["os"], "lb"),
            os.path.join(self.deb.paths["lb"], "config-overrides"),
            deb=self.deb,
        )
