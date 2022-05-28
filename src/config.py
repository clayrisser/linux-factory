import os


class Config:
    def __init__(self, config):
        self.config = config

    @property
    def paths(self):
        root_path = os.path.realpath(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
        )
        build_path = os.path.join(root_path, ".build")
        return {
            "root": root_path,
            "build": build_path,
            "lb": os.path.join(build_path, "lb"),
        }

    @staticmethod
    async def create(config={}):
        print("loading config")
        return Config(config)
