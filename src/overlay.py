class Overlay:
    def __init__(self, config):
        self.config = config
        self.name = config["name"] if "name" in config else None
        self.path = config["path"] if "path" in config else None
