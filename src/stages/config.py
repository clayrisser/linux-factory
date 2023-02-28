import os
from util import shell
from deb import Deb


class ConfigStage:
    def __init__(self, deb: Deb):
        self.deb = deb

    async def run(self):
        await self.deb.hooks.trigger("before_config")
        shell("make -sC '" + self.deb.paths["root"] + "' lb/config")
        await self.deb.hooks.trigger("after_config")
