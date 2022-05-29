from .envs import EnvsLoader
from .filesystem import FilesystemLoader
from .fonts import FontsLoader
from .packages import PackagesLoader
from .repos import ReposLoader
from .lb import LBLoader


loaders = [
    PackagesLoader,
    EnvsLoader,
    ReposLoader,
    FontsLoader,
    FilesystemLoader,
    LBLoader,
]
