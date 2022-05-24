class Config:
    def __init__(self, config):
        self.config = config

    @staticmethod
    async def create(config={}):
        print("loading config")
        return Config(config)
