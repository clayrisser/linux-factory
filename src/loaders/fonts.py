from util import download, mkdirs, extract
from yaml import SafeLoader
import glob
import os
import re
import shutil
import yaml


class FontsLoader:
    name = "fonts"

    URI_REGEX = r"[^:]+:\/\/.+$"

    def __init__(self, deb):
        self.deb = deb

    async def load(self):
        await mkdirs(os.path.join(self.deb.paths["os"], ".fonts/live"))
        await mkdirs(os.path.join(self.deb.paths["os"], ".fonts/installed"))
        fonts = await self.get_fonts()
        for f in fonts:
            await self.load_font(Font(f))
        await self.unpack_fonts()
        await self.copy_fonts()

    async def get_fonts(self):
        fonts = []
        for path in glob.glob(
            os.path.join(
                self.deb.paths["os"],
                "fonts/**/*.yaml",
            ),
            recursive=True,
        ):
            with open(path) as f:
                data = yaml.load(f, Loader=SafeLoader)
                fonts += data
        return fonts

    async def load_font(self, font):
        if not not re.match(FontsLoader.URI_REGEX, font.font):
            if font.live:
                filename = os.path.basename(font.font)
                await download(
                    font.font,
                    os.path.join(self.deb.paths["os"], ".fonts/live", filename),
                )
                if font.installed:
                    shutil.copyfile(
                        os.path.join(self.deb.paths["os"], ".fonts/live", filename),
                        os.path.join(self.deb.paths["os"], ".fonts/live", font.font),
                    )
            elif font.installed:
                with open(
                    os.path.join(self.deb.paths["os"], ".fonts/installed/fonts.list"),
                    "a",
                ) as f:
                    f.write(font.font)
        elif os.path.exists(os.path.join(self.deb.paths["os"], "fonts", font.font)):
            if font.live:
                shutil.copyfile(
                    os.path.join(self.deb.paths["os"], "fonts", font.font),
                    os.path.join(self.deb.paths["os"], ".fonts/live", font.font),
                )
            if font.installed:
                shutil.copyfile(
                    os.path.join(self.deb.paths["os"], "fonts", font.font),
                    os.path.join(self.deb.paths["os"], ".fonts/installed", font.font),
                )

    async def unpack_fonts(self, location=None):
        if location == None:
            await self.unpack_fonts("live")
            await self.unpack_fonts("installed")
            return
        for path in glob.glob(
            os.path.join(
                self.deb.paths["os"],
                ".fonts",
                location,
                "**/*.{zip,tar,tar.gz}",
            ),
            recursive=True,
        ):
            extract(path, location)

    async def copy_fonts(self):
        await mkdirs(
            os.path.join(
                self.deb.paths["os"],
                "filesystem/installed/usr/local/share/fonts",
            )
        )
        await mkdirs(
            os.path.join(
                self.deb.paths["os"],
                "filesystem/live/usr/local/share/fonts",
            )
        )
        await mkdirs(
            os.path.join(
                self.deb.paths["os"],
                "filesystem/installed/root/install/fonts",
            ),
        )
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/installed/**/*.{otf,ttf}"),
            recursive=True,
        ):
            filename = os.path.basename(path)
            shutil.copyfile(
                path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/local/share/fonts",
                    filename,
                ),
            )
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/live/**/*.{otf,ttf}"),
            recursive=True,
        ):
            filename = os.path.basename(path)
            shutil.copyfile(
                path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/live/usr/local/share/fonts",
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
