from util import download, mkdirs, get_filename_from_path
from yaml import SafeLoader
import glob
import os
import re
import shutil
import tarfile
import yaml
import zipfile


class FontsLoader:
    FONT_REGEX = r"[^:]+:\/\/.+$"

    def __init__(self, config):
        self.config = config

    async def load(self):
        await mkdirs(os.path.join(self.config.paths["os"], ".fonts/live"))
        await mkdirs(os.path.join(self.config.paths["os"], ".fonts/installed"))
        fonts = await self.get_fonts()
        for f in fonts:
            await self.load_font(Font(f))
        await self.unpack_fonts()
        await self.copy_fonts()

    async def get_fonts(self):
        fonts = []
        for path in glob.glob(
            os.path.join(self.config.paths["os"], "fonts/**/*.yaml")
        ) + glob.glob(os.path.join(self.config.paths["os"], "fonts/*.yaml")):
            with open(path) as f:
                data = yaml.load(f, Loader=SafeLoader)
                fonts += data
        return fonts

    async def load_font(self, font):
        if not not re.match(FontsLoader.FONT_REGEX, font.font):
            if font.live:
                filename = get_filename_from_path(font.font)
                await download(
                    font.font,
                    os.path.join(self.config.paths["os"], ".fonts/live", filename),
                )
            if font.installed:
                with open(
                    os.path.join(
                        self.config.paths["os"], ".fonts/installed/fonts.list"
                    ),
                    "a",
                ) as f:
                    f.write(font.font)
        elif os.path.exists(os.path.join(self.config.paths["os"], "fonts", font.font)):
            if font.live:
                shutil.copyfile(
                    os.path.join(self.config.paths["os"], "fonts", font.font),
                    os.path.join(self.config.paths["os"], ".fonts/live", font.font),
                )
            if font.installed:
                shutil.copyfile(
                    os.path.join(self.config.paths["os"], "fonts", font.font),
                    os.path.join(
                        self.config.paths["os"], ".fonts/installed", font.font
                    ),
                )

    async def unpack_fonts(self, location=None):
        if location == None:
            await self.unpack_fonts("live")
            await self.unpack_fonts("installed")
            return
        for path in glob.glob(
            os.path.join(self.config.paths["os"], ".fonts", location, "**/*.zip")
        ) + glob.glob(
            os.path.join(self.config.paths["os"], ".fonts", location, "*.zip")
        ):
            with zipfile.ZipFile(path, "r") as zip:
                zip.extractall(
                    os.path.join(self.config.paths["os"], ".fonts", location)
                )
        for path in (
            glob.glob(
                os.path.join(self.config.paths["os"], ".fonts", location, "**/*.tar")
            )
            + glob.glob(
                os.path.join(self.config.paths["os"], ".fonts", location, "*.tar")
            )
            + glob.glob(
                os.path.join(self.config.paths["os"], ".fonts", location, "**/*.tar.gz")
            )
            + glob.glob(
                os.path.join(self.config.paths["os"], ".fonts", location, "*.tar.gz")
            )
        ):
            with tarfile.TarFile(path, "r") as tar:
                tar.extractall(
                    os.path.join(self.config.paths["os"], ".fonts", location)
                )

    async def copy_fonts(self):
        await mkdirs(
            os.path.join(
                self.config.paths["os"],
                "filesystem/installed/usr/local/share/fonts",
            )
        )
        await mkdirs(
            os.path.join(
                self.config.paths["os"],
                "filesystem/live/usr/local/share/fonts",
            )
        )
        await mkdirs(
            os.path.join(
                self.config.paths["os"],
                "filesystem/installed/root/install/fonts",
            ),
        )
        for path in (
            glob.glob(
                os.path.join(self.config.paths["os"], ".fonts/installed/**/*.ttf")
            )
            + glob.glob(os.path.join(self.config.paths["os"], ".fonts/installed/*.ttf"))
            + glob.glob(
                os.path.join(self.config.paths["os"], ".fonts/installed/**/*.otf")
            )
            + glob.glob(os.path.join(self.config.paths["os"], ".fonts/installed/*.otf"))
        ):
            filename = get_filename_from_path(path)
            shutil.copyfile(
                path,
                os.path.join(
                    self.config.paths["os"],
                    "filesystem/installed/usr/local/share/fonts",
                    filename,
                ),
            )
            shutil.copyfile(
                path,
                os.path.join(
                    self.config.paths["os"],
                    "filesystem/live/usr/local/share/fonts",
                    filename,
                ),
            )
            shutil.copyfile(
                path,
                os.path.join(
                    self.config.paths["os"],
                    "filesystem/installed/root/install/fonts",
                    filename,
                ),
            )


class Font:
    def __init__(self, font):
        if type(font) is not dict:
            font = {"font": font}
        self.live = font["live"] if "live" in font else True
        self.installed = font["installed"] if "installed" in font else True
        self.font = font["font"].strip()
