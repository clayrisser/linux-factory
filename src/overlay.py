class Overlay:
    def __init__(self, deb):
        self.deb = deb
        self.name = deb["name"] if "name" in deb else None
        self.path = deb["path"] if "path" in deb else None
