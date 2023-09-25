from jinja2 import Template
import glob
import importlib
import os
import re
import logging
import tarfile
import zipfile


def merge_dict(a, b, depth=float("inf")):
    if b == None:
        return a
    if type(a) is dict and type(b) is dict:
        if depth == 0:
            return a
        merged = {}
        for key in set(list(a.keys()) + list(b.keys())):
            merged[key] = merge_dict(
                a[key] if key in a else None, b[key] if key in b else None, --depth
            )
        return merged
    elif type(a) is list and type(b) is list:
        return a + [x for x in b if x not in a]
    else:
        return b


async def merge_dirs(a_paths, b_path):
    if type(a_paths) is not list:
        a_paths = [a_paths]
    if not a_paths[0].strip():
        raise Exception("missing source")
    if not b_path.strip():
        raise Exception("missing destination")
    if not os.path.exists(b_path):
        os.makedirs(b_path)
    existing_a_paths = list(filter(lambda path: os.path.exists(path), a_paths))
    shell(
        "rsync -r "
        + " ".join(list(map(lambda p: p + "/", existing_a_paths)))
        + " "
        + b_path
        + "/"
    )


async def merge_dirs_templates(a_paths, b_path, deb, overlay=None):
    if type(a_paths) is not list:
        a_paths = [a_paths]
    await merge_dirs(a_paths, b_path)
    for a_path in a_paths:
        for path in glob.glob(
            os.path.join(a_path, "**/*.overlay.tmpl" if overlay else "**/*.tmpl"),
            recursive=True,
            include_hidden=True,
        ):
            with open(path) as f:
                template = Template(f.read())
                with open(
                    os.path.join(
                        b_path, path[len(a_path) + 1 : -13 if overlay else -5]
                    ),
                    "w",
                ) as f:
                    f.write(
                        template.render(
                            deb=deb,
                            overlay=overlay.__dict__
                            if hasattr(overlay, "__dict__")
                            else None,
                        )
                    )
            if os.path.exists(
                os.path.join(b_path, path[len(a_path) + 1 :]),
            ):
                os.remove(
                    os.path.join(b_path, path[len(a_path) + 1 :]),
                )


async def download(url, output):
    shell("wget -O " + output + " " + url)


def import_module(module_name, relative_path):
    full_path = os.path.abspath(
        os.path.join(os.path.dirname(os.path.realpath(__file__)), relative_path)
    )
    spec = importlib.util.spec_from_file_location(module_name, full_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


async def mkdirs(path):
    if not os.path.exists(path):
        os.makedirs(path)


def extract(file, destination=os.getcwd()):
    logging.debug("EXTRACT: " + file + " -> " + destination)
    parent_path = os.path.dirname(destination)
    if not os.path.exists(parent_path):
        os.makedirs(parent_path)
    if bool(re.search(r"\.zip$", file)):
        with zipfile.ZipFile(file, "r") as zip:
            zip.extractall(destination)
    elif bool(re.search(r"\.tar$", file)):
        with tarfile.TarFile(file, "r") as tar:
            tar.extractall(destination)
    elif bool(re.search(r"\.tar.gz$", file)):
        with tarfile.TarFile(file, "r") as tar:
            tar.extractall(destination)
    fix_permissions(destination)


def shell(command, ignore_error=False):
    logging.debug("SHELL: " + command)
    status = os.system(command)
    if os.WIFEXITED(status):
        exit_code = os.WEXITSTATUS(status)
        if exit_code != 0:
            if not ignore_error:
                exit(exit_code)
            return False
    else:
        if not ignore_error:
            exit(1)
        return False
    return True


def fix_permissions(path):
    shell(
        "chown -R "
        + os.environ["SUDO_USER"]
        + ":"
        + os.environ["SUDO_USER"]
        + ' "'
        + path
        + '"'
    )
