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
                "\nd-i preseed/early_command string chmod +x /usr/local/bin/early-install && sh /usr/local/bin/early-install\n"
                + "d-i preseed/late_command string chmod +x /usr/local/bin/post-install && sh /usr/local/bin/post-install\n"
            )
