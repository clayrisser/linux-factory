from .envs import EnvsLoader
from .filesystem import FilesystemLoader
from .fonts import FontsLoader
from .hooks import HooksLoader
from .lb import LBLoader
from .packages import PackagesLoader
from .repos import ReposLoader


loaders = [
    PackagesLoader,
    EnvsLoader,
    ReposLoader,
    FontsLoader,
    HooksLoader,
    FilesystemLoader,
    LBLoader,
]
