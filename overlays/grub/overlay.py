import os
import shutil
import util


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def after_prepare(self):
        await self._load_theme()

    async def _load_theme(self):
        if os.path.isfile(
            os.path.join(self.deb.paths["os"], "assets/grub/theme.tar")
        ) or os.path.isdir(os.path.join(self.deb.paths["os"], "assets/grub/theme")):
            theme_path = os.path.join(
                self.deb.paths["os"],
                "filesystem/installed/boot/grub/themes/default",
            )
            if os.path.exists(theme_path):
                shutil.rmtree(theme_path)
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/grub/theme.tar")
            ):
                os.makedirs(theme_path)
                util.extract(
                    os.path.join(self.deb.paths["os"], "assets/grub/theme.tar"),
                    theme_path,
                )
            elif os.path.isdir(os.path.join(self.deb.paths["os"], "assets/grub/theme")):
                util.merge_dirs_templates(
                    os.path.join(self.deb.paths["os"], "assets/grub/theme"),
                    theme_path,
                    self.deb,
                )
            exit()
