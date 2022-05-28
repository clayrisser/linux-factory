import os
import shutil
from util import merge_dir


class PrepareStage:
    def __init__(self, config):
        self.config = config

    async def run(self):
        await self.initialize_build()
        await self.initialize_lb()
        await self.initialize_os()
        await self.initialize_overlays()

    async def initialize_build(self):
        if not os.path.exists(self.config.paths["build"]):
            os.makedirs(self.config.paths["build"])
        shutil.copyfile(
            os.path.join(self.config.paths["root"], "mkpm.mk"),
            os.path.join(self.config.paths["build"], "mkpm.mk"),
        )
        if os.path.exists(
            os.path.join(self.config.paths["root"], ".mkpm")
        ) and not os.path.exists(os.path.join(self.config.paths["build"], ".mkpm")):
            shutil.copytree(
                os.path.join(self.config.paths["root"], ".mkpm"),
                os.path.join(self.config.paths["build"], ".mkpm"),
            )

    async def initialize_lb(self):
        if os.path.exists(self.config.paths["lb"]):
            shutil.rmtree(self.config.paths["lb"])
        shutil.copytree(
            os.path.join(self.config.paths["root"], "lb"), self.config.paths["lb"]
        )
        os.chdir(self.config.paths["lb"])

    async def initialize_os(self):
        if os.path.exists(self.config.paths["os"]):
            shutil.rmtree(self.config.paths["os"])
        shutil.copytree(
            os.path.join(self.config.paths["root"], "os"), self.config.paths["os"]
        )
        os.chdir(self.config.paths["os"])

    async def initialize_overlays(self):
        for _overlay_name, overlay in self.config.overlays.items():
            await merge_dir(overlay.path, self.config.paths["os"])
