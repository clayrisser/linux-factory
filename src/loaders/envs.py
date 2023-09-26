import os
import logging


class EnvsLoader:
    name = "envs"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        lb_envs = ""
        for key, value in self.deb.lb_envs.items():
            lb_envs += key + '="' + value + '"\n'
        if not os.path.exists(os.path.join(self.deb.paths["lb"], ".env")):
            with open(os.path.join(self.deb.paths["lb"], ".env"), "w") as f:
                f.write(lb_envs)
        envs = ""
        for key, value in self.deb.envs.items():
            envs += key + '="' + value + '"\n'
            logging.debug(key + ": " + value)
        if not os.path.exists(
            os.path.join(
                self.deb.paths["lb"], "config-overrides/includes.chroot/root/install"
            )
        ):
            os.makedirs(
                os.path.join(
                    self.deb.paths["lb"],
                    "config-overrides/includes.chroot/root/install",
                )
            )
        with open(
            os.path.join(
                self.deb.paths["lb"],
                "config-overrides/includes.chroot/root/install/.env",
            ),
            "w",
        ) as f:
            f.write(envs)
        if not os.path.exists(
            os.path.join(
                self.deb.paths["lb"], "config-overrides/includes.installer/root/install"
            )
        ):
            os.makedirs(
                os.path.join(
                    self.deb.paths["lb"],
                    "config-overrides/includes.installer/root/install",
                )
            )
        with open(
            os.path.join(
                self.deb.paths["lb"],
                "config-overrides/includes.installer/root/install/.env",
            ),
            "w",
        ) as f:
            f.write(envs)
