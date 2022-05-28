from .envs import EnvsLoader
from .filesystem import FilesystemLoader
from .packages import PackagesLoader
from .repos import ReposLoader


loaders = [FilesystemLoader, PackagesLoader, EnvsLoader, ReposLoader]
