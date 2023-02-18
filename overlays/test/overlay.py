import logging


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def before_config(self):
        logging.debug("TEST before config")

    async def after_config(self):
        logging.debug("TEST after config")

    async def before_prepare(self):
        logging.debug("TEST before prepare")

    async def after_prepare(self):
        logging.debug("TEST after prepare")

    async def before_build(self):
        logging.debug("TEST before build")

    async def after_build(self):
        logging.debug("TEST after build")
