import os
import shutil


class PrepareStage:
    def __init__(self, config):
        self.config = config

    async def run(self):
        await self.initialize()
        print("preparing")

    async def initialize(self):
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
        if os.path.exists(self.config.paths["lb"]):
            shutil.rmtree(self.config.paths["lb"])
        shutil.copytree(
            os.path.join(self.config.paths["root"], "lb"), self.config.paths["lb"]
        )
        os.chdir(self.config.paths["lb"])
