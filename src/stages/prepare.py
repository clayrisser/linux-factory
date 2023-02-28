from deb import Deb
from loaders import loaders
from overlay import Overlay
import logging
import os
import shutil
from util import (
    import_module,
    merge_dirs_templates,
)


class PrepareStage:
    def __init__(self, deb: Deb):
        self.deb = deb

    async def run(self):
        await self.load_overlays()
        await self.deb.hooks.trigger("before_prepare")
        await self.initialize_build()
        await self.initialize_lb()
        await self.initialize_os()
        await self.initialize_overlays()
        await self.run_loaders()
        await self.deb.hooks.trigger("after_prepare")

    async def load_overlays(self):
        overlay: Overlay
        for overlay_name, overlay in self.deb.overlays.items():
            overlay_module = None
            if os.path.exists(os.path.join(overlay.path, "overlay.py")):
                overlay_module = import_module(
                    "overlay_" + overlay_name, os.path.join(overlay.path, "overlay.py")
                )
            overlay_hooks = None
            if hasattr(overlay_module, "OverlayHooks"):
                overlay_hooks = overlay_module.OverlayHooks(self.deb, overlay.config)
            for method_name in dir(overlay_hooks):
                if len(method_name) <= 0:
                    continue
                if method_name[0] == "_":
                    continue
                if not hasattr(overlay_hooks, method_name):
                    continue
                if not callable(getattr(overlay_hooks, method_name)):
                    continue
                overlay_hook_name = method_name
                overlay_hook = getattr(overlay_hooks, method_name)
                self.deb.hooks.listen(overlay_hook_name, overlay_hook)

    async def initialize_build(self):
        if not os.path.exists(self.deb.paths["build"]):
            os.makedirs(self.deb.paths["build"])
        os.chdir(self.deb.paths["build"])

    async def initialize_lb(self):
        if os.path.exists(self.deb.paths["lb"]):
            shutil.rmtree(self.deb.paths["lb"])
        shutil.copytree(
            os.path.join(self.deb.paths["root"], "lb"), self.deb.paths["lb"]
        )

    async def initialize_os(self):
        if os.path.exists(self.deb.paths["os"]):
            shutil.rmtree(self.deb.paths["os"])
        shutil.copytree(
            os.path.join(self.deb.paths["root"], "os"), self.deb.paths["os"]
        )

    async def initialize_overlays(self):
        overlay: Overlay
        for _overlay_name, overlay in self.deb.overlays.items():
            await merge_dirs_templates(
                overlay.path, self.deb.paths["os"], deb=self.deb, overlay=overlay
            )
        if os.path.exists(
            os.path.join(self.deb.paths["os"], "__pycache__"),
        ):
            shutil.rmtree(
                os.path.join(self.deb.paths["os"], "__pycache__"),
            )
        if os.path.exists(
            os.path.join(self.deb.paths["os"], "config.yaml"),
        ):
            os.remove(
                os.path.join(self.deb.paths["os"], "config.yaml"),
            )
        if os.path.exists(
            os.path.join(self.deb.paths["os"], "overlay.py"),
        ):
            os.remove(
                os.path.join(self.deb.paths["os"], "overlay.py"),
            )

    async def run_loaders(self):
        for Loader in loaders:
            loader = Loader(self.deb)
            logging.debug("LOADER: loading " + loader.name + "...")
            await self.deb.hooks.trigger("before_loader_" + loader.name)
            await loader.load()
            await self.deb.hooks.trigger("after_loader_" + loader.name)
            logging.debug("LOADER: loaded " + loader.name)
