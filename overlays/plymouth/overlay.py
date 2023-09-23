import os
import shutil
import util


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def before_loader_filesystem(self):
        os.system("sudo apt-get install -y desktop-base")
        await self._load_background()

    async def _load_background(self):
        from_theme = "homeworld"
        homeworld_path = os.path.join("/usr/share/plymouth/themes", from_theme)
        if os.path.isdir(homeworld_path):
            custom_path = os.path.join(
                self.deb.paths["os"],
                "filesystem/installed/usr/share/plymouth/themes/custom",
            )
            shutil.copytree(homeworld_path, custom_path)
            shutil.move(
                os.path.join(custom_path, f"{from_theme}.plymouth"),
                os.path.join(custom_path, "custom.plymouth"),
            )
            with open(os.path.join(custom_path, "custom.plymouth"), "r+") as f:
                content = f.read()
                content = content.replace(f"/themes/{from_theme}", "/themes/custom")
                f.seek(0)
                f.write(content)
                f.truncate()
        background_path = (
            os.path.join(self.deb.paths["os"], "assets/plymouth/background.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/plymouth/background.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/plymouth/background.jpeg")
        )
        if os.path.isfile(background_path):
            await util.mkdirs(
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/share/plymouth/themes/custom",
                ),
            )
            convert_image(
                background_path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/share/plymouth/themes/custom/plymouth_background_homeworld.png",
                ),
                "1920x1539",
            )
        logo_path = os.path.join(self.deb.paths["os"], "assets/plymouth/logo.png")
        if os.path.isfile(logo_path):
            await util.mkdirs(
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/share/plymouth/themes/custom",
                ),
            )
            shutil.copy(
                logo_path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/share/plymouth/themes/custom/logo.png",
                ),
            )
        title_path = os.path.join(self.deb.paths["os"], "assets/plymouth/title.png")
        if os.path.isfile(title_path):
            await util.mkdirs(
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/share/plymouth/themes/custom",
                ),
            )
            shutil.copy(
                title_path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/share/plymouth/themes/custom/debian.png",
                ),
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
        + " '"
        + b_path
        + "'"
    )
