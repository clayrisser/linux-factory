import os
import shutil


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def after_prepare(self):
        await self._after_prepare_preseed()
        await self._after_prepare_repos()

    async def _after_prepare_preseed(self):
        with open(
            os.path.join(
                self.deb.paths["lb"],
                "config-overrides/includes.installer/preseed.cfg",
            ),
            "a",
        ) as f:
            f.write(
                "\nd-i preseed/early_command string chmod +x /usr/local/bin/early-command && sh /usr/local/bin/early-command\n"
                + "d-i preseed/late_command string chmod +x /usr/local/bin/late-command && sh /usr/local/bin/late-command\n"
            )

    async def _after_prepare_repos(self):
        apt_path = os.path.join(
            self.deb.paths["lb"], "config-overrides/includes.installer/etc/apt"
        )
        sources_path = os.path.join(apt_path, "sources.list.d")
        trusted_path = os.path.join(apt_path, "trusted.list.d")
        if not os.path.exists(sources_path):
            os.makedirs(sources_path)
        if not os.path.exists(trusted_path):
            os.makedirs(trusted_path)
        for repo in self.deb.data["repos"]:
            if repo.installed:
                shutil.copyfile(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config-overrides/archives",
                        repo.name + ".list.chroot",
                    ),
                    os.path.join(sources_path, repo.name + ".list"),
                )
                shutil.copyfile(
                    os.path.join(
                        self.deb.paths["lb"],
                        "config-overrides/archives",
                        repo.name + ".key.chroot",
                    ),
                    os.path.join(trusted_path, repo.name + ".chroot.asc"),
                )
