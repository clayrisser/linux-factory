import os
from util import shell
from deb import Deb


class ConfigStage:
    def __init__(self, deb: Deb):
        self.deb = deb

    async def run(self):
        await self.deb.hooks.trigger("before_config")
        shell("cd " + self.deb.paths["lb"] + " && make config")
        await self.deb.hooks.trigger("after_config")
