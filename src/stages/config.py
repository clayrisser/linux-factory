import os
from deb import Deb


class ConfigStage:
    def __init__(self, deb: Deb):
        self.deb = deb

    async def run(self):
        await self.deb.hooks.trigger("before_config")
        os.system("cd " + self.deb.paths["lb"] + " && make config")
        await self.deb.hooks.trigger("after_config")
