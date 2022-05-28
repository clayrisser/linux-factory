import os


def merge_dict(a, b, depth=-1):
    if b == None:
        return a
    if type(a) is dict and type(b) is dict:
        if depth == 0:
            return a
        merged = {}
        for key in list(set(list(a.keys()) + list(b.keys()))):
            merged[key] = merge_dict(
                a[key] if key in a else None, b[key] if key in b else None, --depth
            )
        return merged
    elif type(a) is list and type(b) is list:
        return list(set(a + b))
    else:
        return b


async def merge_dir(a_path, b_path):
    if type(a_path) is not list:
        a_path = [a_path]
    if not os.path.exists(b_path):
        os.makedirs(b_path)
    os.system(
        "rsync -a "
        + " ".join(list(map(lambda p: p + "/", a_path)))
        + " "
        + b_path
        + "/ 2>/dev/null"
    )
