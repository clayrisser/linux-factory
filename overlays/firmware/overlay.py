import os
from util import download, mkdirs, shell


class OverlayHooks:
    def __init__(self, deb, config):
        self.deb = deb
        self.config = config

    async def after_prepare(self):
        await self._load_firmware()

    async def _load_firmware(self):
        firmware_path = os.path.join(
            self.deb.paths["lb"],
            "config-overrides/includes.binary/firmware",
        )
        firmware_tar_path = os.path.join(
            firmware_path,
            "firmware.tar.gz",
        )
        await mkdirs(firmware_path)
        await download(
            'https://chuangtzu.ftp.acc.umu.se/cdimage/unofficial/non-free/firmware/bullseye/11.6.0/firmware.tar.gz',
            firmware_tar_path
        )
        shell(
            "tar -xzvf '" + firmware_tar_path + "' -C '"  + firmware_path + "'"
        )
        os.remove(firmware_tar_path)
