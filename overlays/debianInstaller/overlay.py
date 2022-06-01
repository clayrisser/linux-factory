import os


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def after_prepare(self):
        with open(
            os.path.join(
                self.deb.paths["lb"],
                "config-overrides/includes.installer/preseed.cfg",
            ),
            "a",
        ) as f:
            f.write(
                "d-i preseed/late_command string chmod +x /usr/sbin/post-install && sh /usr/sbin/post-install\n"
            )
