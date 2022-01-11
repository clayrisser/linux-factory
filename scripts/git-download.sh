#!/bin/sh

while [ $# -gt 0 ]; do
    case $1 in
        -c|--clone)
            _CLONE=1
            shift
            ;;
        -o|--only)
            _ONLY=1
            shift
            ;;
        -*|--*)
            echo "unknown option $1"
            exit 1
            ;;
        *)
            _POSITIONAL_ARGS="$_POSITIONAL_ARGS $1"
            shift
            ;;
    esac
done

cut --version >/dev/null || exit $?
md5sum --version >/dev/null || exit $?
pwd >/dev/null || exit $?

_CURDIR=$(pwd)
_PATH=$(echo $_POSITIONAL_ARGS | cut -d' ' -f1)
if [ "$_PATH" = "" ]; then
    echo "missing path"
    exit 1
fi
_REPO=$(echo $_PATH | cut -d'#' -f1)
if [ "$_REPO" = "" ]; then
    echo "missing repository"
    exit 1
fi
_PATH=$(echo ${_PATH}\# | cut -d'#' -f2)
_REF=$(echo ${_PATH} | cut -d':' -f1)
_PATH=$(echo ${_PATH}: | cut -d':' -f2)
_REF=${_REF:-HEAD}
_PATH=${_PATH:-/}
if  [ "$_PATH" = "/" ]; then
    _PATH=.
elif [ "$(echo $_PATH | cut -c1-1)" = "/" ]; then
    _PATH=$(echo $_PATH | cut -c2-)
fi

_TMP=${XDG_RUNTIME_DIR:-${TMPDIR:-${TMP:-${TEMP:-/tmp}}}}/$(pwd | md5sum | cut -d' ' -f1)

_cleanup() {
    cd $_CURDIR >/dev/null
    rm -rf $_TMP 2>/dev/null || true
    exit $1
}

if [ "$_CLONE" = "1" ]; then
    mkdir -p $_TMP
    rm -rf $_TMP
    git clone --depth=1 --no-checkout \
        $([ "$_ONLY" = "1" ] && echo '--filter=tree:0' || true) \
        $_REPO $_TMP || _cleanup $?
    cd $_TMP >/dev/null
    git checkout $_REF -- $_PATH || _cleanup $?
    cp -r $_PATH $_CURDIR
    _cleanup $?
else
    exec git archive --format=tar --remote=$_REPO $_REF -- $_PATH | \
        tar xf -
fi
