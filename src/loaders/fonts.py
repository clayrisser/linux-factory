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
        await mkdirs(os.path.join(self.deb.paths["os"], ".fonts/installed"))
        await mkdirs(os.path.join(self.deb.paths["os"], ".fonts/live"))
        await mkdirs(os.path.join(self.deb.paths["os"], ".fonts/live_installed"))
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
            include_hidden=True,
        ):
            with open(path) as f:
                data = yaml.load(f, Loader=SafeLoader)
                fonts += data
        return fonts

    async def load_font(self, font):
        if not not re.match(FontsLoader.URI_REGEX, font.font):
            extension = font.format
            if not extension:
                extension = "." + font.font.split(".")[-1]
                extension = (
                    extension
                    if extension in {".zip", ".tar", ".tar.gz", ".otf", "ttf"}
                    else ".zip"
                )
            filename = str(hash(font.font)) + extension
            if font.live and font.installed:
                await download(
                    font.font,
                    os.path.join(
                        self.deb.paths["os"], ".fonts/live_installed", filename
                    ),
                )
            elif font.live:
                await download(
                    font.font,
                    os.path.join(self.deb.paths["os"], ".fonts/live", filename),
                )
            elif font.installed:
                await download(
                    font.font,
                    os.path.join(self.deb.paths["os"], ".fonts/installed", filename),
                )
        elif os.path.exists(os.path.join(self.deb.paths["os"], "fonts", font.font)):
            if font.live and font.installed:
                shutil.copyfile(
                    os.path.join(self.deb.paths["os"], "fonts", font.font),
                    os.path.join(
                        self.deb.paths["os"], ".fonts/live_installed", font.font
                    ),
                )
            elif font.live:
                shutil.copyfile(
                    os.path.join(self.deb.paths["os"], "fonts", font.font),
                    os.path.join(self.deb.paths["os"], ".fonts/live", font.font),
                )
            elif font.installed:
                shutil.copyfile(
                    os.path.join(self.deb.paths["os"], "fonts", font.font),
                    os.path.join(self.deb.paths["os"], ".fonts/installed", font.font),
                )

    async def unpack_fonts(self, location=None):
        if location == None:
            await self.unpack_fonts("installed")
            await self.unpack_fonts("live")
            await self.unpack_fonts("live_installed")
            return
        fonts_path = os.path.join(self.deb.paths["os"], ".fonts", location)
        for path in (
            glob.glob(
                os.path.join(fonts_path, "**/*.zip"),
                recursive=True,
                include_hidden=True,
            )
            + glob.glob(
                os.path.join(fonts_path, "**/*.tar"),
                recursive=True,
                include_hidden=True,
            )
            + glob.glob(
                os.path.join(fonts_path, "**/*.tar.gz"),
                recursive=True,
                include_hidden=True,
            )
        ):
            extract(path, fonts_path)

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
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/installed/**/*.otf"),
            recursive=True,
            include_hidden=True,
        ) + glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/installed/**/*.ttf"),
            recursive=True,
            include_hidden=True,
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
            os.path.join(self.deb.paths["os"], ".fonts/live/**/*.otf"),
            recursive=True,
            include_hidden=True,
        ) + glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/live/**/*.ttf"),
            recursive=True,
            include_hidden=True,
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
        for path in glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/live_installed/**/*.otf"),
            recursive=True,
            include_hidden=True,
        ) + glob.glob(
            os.path.join(self.deb.paths["os"], ".fonts/live_installed/**/*.ttf"),
            recursive=True,
            include_hidden=True,
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
            shutil.copyfile(
                path,
                os.path.join(
                    self.deb.paths["os"],
                    "filesystem/installed/usr/local/share/fonts",
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
        self.format = font["format"] if "format" in font else None
