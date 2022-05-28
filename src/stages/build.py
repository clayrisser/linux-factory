import os


class BuildStage:
    def __init__(self, config):
        self.config = config

    async def run(self):
        print("building")
        os.system("make build")
