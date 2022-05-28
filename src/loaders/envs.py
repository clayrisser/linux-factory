import os


class EnvsLoader:
    def __init__(self, config):
        self.config = config

    async def load(self):
        envs = ""
        if os.path.exists(os.path.join(self.config.paths["os"], ".env")):
            with open(os.path.join(self.config.paths["os"], ".env")) as f:
                lines = f.readlines()
                for line in lines:
                    envs += line + "\n"
        if not os.path.exists(
            os.path.join(self.config.paths["lb"], "config/includes.chroot/root/install")
        ):
            os.makedirs(
                os.path.join(
                    self.config.paths["lb"], "config/includes.chroot/root/install"
                )
            )
            with open(
                os.path.join(
                    self.config.paths["lb"], "config/includes.chroot/root/install/env"
                ),
                "w",
            ) as f:
                f.write(envs)
        if not os.path.exists(
            os.path.join(
                self.config.paths["lb"], "config/includes.installer/root/install"
            )
        ):
            os.makedirs(
                os.path.join(
                    self.config.paths["lb"], "config/includes.installer/root/install"
                )
            )
            with open(
                os.path.join(
                    self.config.paths["lb"],
                    "config/includes.installer/root/install/env",
                ),
                "w",
            ) as f:
                f.write(envs)
