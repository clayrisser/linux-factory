from deb import Deb
from util import shell


class BuildStage:
    def __init__(self, deb: Deb):
        self.deb = deb

    async def run(self):
        await self.deb.hooks.trigger("before_build")
        shell("cd " + self.deb.paths["lb"] + " && make build")
        await self.deb.hooks.trigger("after_build")
