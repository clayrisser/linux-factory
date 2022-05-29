import os
import logging


class EnvsLoader:
    def __init__(self, config):
        self.config = config

    async def load(self):
        lb_envs = ""
        for key, value in self.config.lb_envs.items():
            lb_envs += "export " + key + '="' + value + '"\n'
        if not os.path.exists(os.path.join(self.config.paths["lb"], ".env")):
            with open(os.path.join(self.config.paths["lb"], ".env"), "w") as f:
                f.write(lb_envs)
        envs = ""
        for key, value in self.config.envs.items():
            envs += "export " + key + '="' + value + '"\n'
            logging.debug(key + ": " + value)
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
                self.config.paths["lb"], "config/includes.chroot/root/install/.env"
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
                "config/includes.installer/root/install/.env",
            ),
            "w",
        ) as f:
            f.write(envs)
