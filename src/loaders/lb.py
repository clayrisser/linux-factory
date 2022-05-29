import os
from util import merge_dir


class LBLoader:
    name = "lb"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await merge_dir(
            os.path.join(self.deb.paths["os"], "lb"),
            os.path.join(self.deb.paths["lb"]),
        )
