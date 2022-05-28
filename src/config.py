import os
import yaml
from yaml.loader import SafeLoader
from overlay import Overlay
from util import merge_dict

_paths = None


class Config:
    def __init__(self, config):
        self._config = config
        self._overlays = None

    @property
    def paths(self):
        return Config._get_paths()

    @property
    def overlays(self):
        if self._overlays:
            return self._overlays
        self._overlays = {}
        for overlay_name, overlay_config in self._config["overlays"].items():
            overlay_path = os.path.join(self.paths["root"], "overlays", overlay_name)
            if not overlay_config:
                overlay_config = {}
            overlay_config["name"] = overlay_name
            overlay_config["path"] = overlay_path
            self._overlays[overlay_name] = Overlay(overlay_config)
        return self._overlays

    @staticmethod
    def _get_paths():
        global _paths
        if _paths:
            return _paths
        root_path = os.path.realpath(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
        )
        build_path = os.path.join(root_path, ".build")
        _paths = {
            "build": build_path,
            "lb": os.path.join(build_path, "lb"),
            "os": os.path.join(build_path, "os"),
            "root": root_path,
        }
        return _paths

    @staticmethod
    async def _load_config(config_path=None):
        paths = Config._get_paths()
        if not config_path:
            config_path = os.path.join(paths["root"], "os/config.yaml")
        with open(config_path) as f:
            return yaml.load(f, Loader=SafeLoader)

    @staticmethod
    async def create(config={}):
        paths = Config._get_paths()
        config = merge_dict(await Config._load_config(), config)
        for overlay_name in config["overlays"].keys():
            overlay_path = os.path.join(paths["root"], "overlays", overlay_name)
            if os.path.exists(os.path.join(overlay_path, "config.yaml")):
                config = merge_dict(
                    config,
                    await Config._load_config(
                        os.path.join(overlay_path, "config.yaml")
                    ),
                )
        return Config(config)
