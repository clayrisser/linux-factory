class PackagesLoader:
    def __init__(self, config):
        self.config = config

    async def load(self):
        print("loading assets")
