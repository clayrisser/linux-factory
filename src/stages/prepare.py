class PrepareStage:
    def __init__(self, config):
        self.config = config

    async def run(self) -> None:
        print("preparing")
