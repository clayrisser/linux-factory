class OverlayHooks:
    def __init__(self, deb):
        self.deb = deb

    def before_prepare(self):
        print("before prepare from BRAVE")
