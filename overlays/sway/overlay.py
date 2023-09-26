import os
import util


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def before_loader_filesystem(self):
        await self._load_wallpaper()
        await self._load_face()

    async def _load_wallpaper(self):
        wallpaper_path = (
            os.path.join(self.deb.paths["os"], "assets/sway/wallpaper.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/sway/wallpaper.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/sway/wallpaper.jpeg")
        )
        if os.path.isfile(wallpaper_path):
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/installed/etc/skel"),
            )
            convert_image(
                wallpaper_path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/live_installed/etc/skel/.wallpaper.png",
                ),
                "1920x1080",
            )

    async def _load_face(self):
        face_path = (
            os.path.join(self.deb.paths["os"], "assets/sway/face.png")
            if os.path.isfile(
                os.path.join(self.deb.paths["os"], "assets/sway/face.png")
            )
            else os.path.join(self.deb.paths["os"], "assets/sway/face.jpeg")
        )
        if os.path.isfile(face_path):
            await util.mkdirs(
                os.path.join(self.deb.paths["os"], "filesystem/installed/etc/skel"),
            )
            convert_image(
                face_path,
                os.path.join(
                    self.deb.paths["os"], "filesystem/live_installed/etc/skel/.face"
                ),
                "358x358",
            )


def convert_image(a_path, b_path, size="1920x1080"):
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
