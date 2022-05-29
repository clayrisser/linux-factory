from .envs import EnvsLoader
from .filesystem import FilesystemLoader
from .fonts import FontsLoader
from .packages import PackagesLoader
from .repos import ReposLoader


loaders = [PackagesLoader, EnvsLoader, ReposLoader, FontsLoader, FilesystemLoader]
