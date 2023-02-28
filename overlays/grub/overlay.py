import os
import shutil
import util


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def before_loader_filesystem(self):
        await self._load_theme()
        await self._load_splash()

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

    async def _load_splash(self):
        splash_path = (
            os.path.join(self.deb.paths["os"], "assets/grub/splash.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/grub/splash.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/grub/splash.jpeg")
        )
        if os.path.isfile(splash_path):
            size = "640x480"
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/installed/boot/grub"),
            )
            convert_image(
                splash_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/installed/boot/grub/splash.png"
                ),
                size,
            )
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/binary/boot/grub"),
            )
            convert_image(
                splash_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/binary/boot/grub/splash.png"
                ),
                size,
            )
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/binary/isolinux"),
            )
            convert_image(
                splash_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/binary/isolinux/splash.png"
                ),
                size,
            )


def convert_image(a_path, b_path, size="640x480"):
    util.shell(
        "convert '"
        + a_path
        + "' -resize '"
        + size
        + "^' -gravity center -extent "
        + size
        + " -define png:format=png24 '"
        + b_path
        + "'"
    )
