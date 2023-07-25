import os
import shutil
import util


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def before_loader_filesystem(self):
        os.system('sudo apt-get install -y desktop-base')
        await self._load_background()

    async def _load_background(self):
        homeworld_path = "/usr/share/plymouth/themes/homeworld"
        if os.path.isdir(homeworld_path):
            shutil.copytree(
                homeworld_path,
                os.path.join(self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom"),
            )
        background_path = (
            os.path.join(self.deb.paths["os"], "assets/plymouth/background.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/plymouth/background.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/plymouth/background.jpeg")
        )
        if os.path.isfile(background_path):
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom"),
            )
            convert_image(
                background_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom/plymouth_background_homeworld.png"
                ),
                "1920x1539",
            )
        logo_path = (
            os.path.join(self.deb.paths["os"], "assets/plymouth/logo.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/plymouth/logo.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/plymouth/logo.jpeg")
        )
        if os.path.isfile(logo_path):
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom"),
            )
            convert_image(
                logo_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom/logo.png"
                ),
                "380x380",
            )
        title_path = (
            os.path.join(self.deb.paths["os"], "assets/plymouth/title.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/plymouth/title.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/plymouth/title.jpeg")
        )
        if os.path.isfile(title_path):
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom"),
            )
            convert_image(
                title_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/installed/usr/share/plymouth/themes/custom/debian.png"
                ),
                "201x86",
            )


def convert_image(a_path, b_path, size=None):
    util.shell(
        "convert '"
        + a_path
        + (
            ("' -resize '" + size + "^' -gravity center -extent " + size)
            if size
            else "'"
        )
        + " -define png:format=png24 '"
        + b_path
        + "'"
    )
