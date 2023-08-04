#!/bin/sh

export MKPM_CLI_VERSION="0.3.0"
export DEFAULT_MKPM_BOOTSTRAP="https://gitlab.com/api/v4/projects/29276259/packages/generic/mkpm/0.3.0/bootstrap.mk"
export DEFAULT_MKPM_REPO="https://gitlab.com/risserlabs/community/mkpm-stable.git"

export _CWD=$(pwd)
export _USER_ID=$(id -u $USER)
export _TMP_PATH="${XDG_RUNTIME_DIR:-$([ -d "/run/user/$_USER_ID" ] && \
    echo "/run/user/$_USER_ID" || echo ${TMP:-${TEMP:-/tmp}})}/mkpm/$$"
export _STATE_PATH="${XDG_STATE_HOME:-$HOME/.local/state}/mkpm"
export _REPOS_PATH="$_STATE_PATH/repos"
export _REPOS_LIST_PATH="$_STATE_PATH/repos.list"
export GIT_LFS_SKIP_SMUDGE=1

alias gsed="$(gsed --help >/dev/null 2>/dev/null && echo gsed || echo sed)"

main() {
    _prepare
    if [ "$_COMMAND" = "install" ]; then
        if [ "$_PARAM1" = "" ] && [ "$_PARAM2" = "" ]; then
            if [ "$MKPM" = "" ]; then
                _echo "_install must be called from mkpm makefile" 1>&2
                exit 1
            fi
            _install
            return
        fi
        _REPO=$_PARAM1
        _PACKAGE=$_PARAM2
        _REPO_URI=$(_lookup_repo_uri $_REPO)
        _REPO_PATH=$(_repo_path $_REPO_URI)
        if [ "$_REPO_URI" = "" ]; then
            _echo "repo $_REPO is not valid" 1>&2
            exit 1
        fi
        if ! _is_repo_uri "$_REPO"; then
            _REPO_NAME="$(echo $_REPO | tr '[:lower:]' '[:upper:]')"
        fi
        _update_repo $_REPO_URI $_REPO_PATH
        _install $_PACKAGE $_REPO_URI $_REPO_NAME
    elif [ "$_COMMAND" = "remove" ]; then
        _remove $_PARAM1
        _echo "removed $_PARAM1"
    elif [ "$_COMMAND" = "upgrade" ]; then
        _upgrade $_PARAM1 $_PARAM2
    elif [ "$_COMMAND" = "dependencies" ]; then
        _dependencies $_PARAM1
    elif [ "$_COMMAND" = "repo-add" ]; then
        _REPO_NAME=$_PARAM1
        _REPO_URI=$_PARAM2
        _repo_add $_REPO_NAME $_REPO_URI
    elif [ "$_COMMAND" = "repo-remove" ]; then
        _repo_remove $_PARAM1
    elif [ "$_COMMAND" = "reinstall" ]; then
        _reinstall
    elif [ "$_COMMAND" = "init" ]; then
        _init
    fi
}

_install() {
    if [ "$1" = "" ]; then
        for r in $(_lookup_repos); do
            _REPO_URI="$(_lookup_repo_uri $r)"
            if [ "$_REPO_URI" = "" ]; then
                continue
            fi
            _REPO_PATH=$(_repo_path $_REPO_URI)
            _update_repo "$_REPO_URI" "$_REPO_PATH"
            for p in $(eval $(echo "echo \$MKPM_PACKAGES_$(echo $r | tr '[:lower:]' '[:upper:]')")); do
                _install $p "$_REPO_URI" $r
            done
        done
        _create_cache
        return
    fi
    _PACKAGE=$1
    _PACKAGE_NAME=$(echo $_PACKAGE | cut -d'=' -f1)
    _PACKAGE_VERSION=$(echo $_PACKAGE | gsed 's|^[^=]*||g' | gsed 's|^=||g')
    _REPO_URI=$2
    _REPO_PATH=$(_repo_path $_REPO_URI)
    _REPO_NAME=$3
    cd "$_REPO_PATH" || exit 1
    if [ "$_PACKAGE_VERSION" = "" ]; then
        _PACKAGE_VERSION=$(git tag | grep -E "${_PACKAGE_NAME}/" | \
            gsed "s|${_PACKAGE_NAME}/||g" | \
            sort -t "." -k1,1n -k2,2n -k3,3n | tail -n1)
    fi
    if [ "$_PACKAGE_VERSION" = "" ]; then
        _echo "package $_PACKAGE_NAME does not exist" 1>&2
        exit 1
    fi
    if ! git checkout -f "$_PACKAGE_NAME/$_PACKAGE_VERSION" >/dev/null 2>/dev/null; then
        _echo "package ${_PACKAGE_NAME}=${_PACKAGE_VERSION} does not exist" 1>&2
        exit 1
    fi
    git lfs pull --include "$_PACKAGE_NAME/$_PACKAGE_NAME.tar.gz"
    if [ ! -f "$_REPO_PATH/$_PACKAGE_NAME/$_PACKAGE_NAME.tar.gz" ]; then
        _echo "package ${_PACKAGE_NAME}=${_PACKAGE_VERSION} does not exist" 1>&2
        exit 1
    fi
    if [ ! -d "$_CWD/.mkpm" ]; then
        mkdir -p "$_CWD/.mkpm"
    fi
    _remove $_PACKAGE_NAME
    echo 'include $(MKPM)'"/.pkgs/$_PACKAGE_NAME/main.mk" > \
        "$_CWD/.mkpm/$_PACKAGE_NAME"
    echo ".PHONY: $_PACKAGE_NAME-%" > "$_CWD/.mkpm/-$_PACKAGE_NAME"
    echo "$_PACKAGE_NAME-%:" >> "$_CWD/.mkpm/-$_PACKAGE_NAME"
    echo '	@$(MAKE) -s -f $(MKPM)/.pkgs/'"$_PACKAGE_NAME/main.mk "'$(subst '"$_PACKAGE_NAME-,,$"'@)' >> \
        "$_CWD/.mkpm/-$_PACKAGE_NAME"
    mkdir -p "$_CWD/.mkpm/.pkgs/$_PACKAGE_NAME"
    tar -xzf "$_REPO_PATH/$_PACKAGE_NAME/$_PACKAGE_NAME.tar.gz" -C "$_CWD/.mkpm/.pkgs/$_PACKAGE_NAME" >/dev/null
    if [ "$MKPM" = "" ] && [ "$_REPO_NAME" != "" ]; then
        _LINE_NUMBER=$(expr $(cat -n "$_CWD/mkpm.mk" | grep "MKPM_PACKAGES_${_REPO_NAME} := \\\\" | grep -oE '[0-9]+') + 1)
        gsed -i "${_LINE_NUMBER}i\\	${_PACKAGE_NAME}=${_PACKAGE_VERSION} \\\\" "$_CWD/mkpm.mk"
        _trim_mkpm_file
    fi
    _create_cache
    _echo "installed ${_PACKAGE_NAME}=${_PACKAGE_VERSION}"
}

_is_repo_uri() {
    echo "$1" | grep -E '^(\w+://.+)|(git@.+:.+)$' >/dev/null 2>/dev/null
}

_lookup_repo_uri() {
    _REPO=$1
    if _is_repo_uri "$_REPO"; then
        echo $_REPO
        return
    fi
    _REPO_URI=$(eval 'echo $MKPM_REPO_'$(echo "$_REPO" | \
        tr '[:lower:]' '[:upper:]'))
    if [ "$_REPO_URI" = "" ] && [ -f "$_CWD/mkpm.mk" ]; then
        _REPO_NAME=$(echo "$_REPO" | tr '[:lower:]' '[:upper:]')
        _REPO_ENV=$(echo export MKPM_REPO_$_REPO_NAME)
        _REPO_URI=$(echo $(awk 'sub(/\\$/,""){printf("%s",$0);next};1' "$_CWD/mkpm.mk" | \
            grep "$_REPO_ENV" | gsed 's|^.*:= ||g'))
    fi
    if _is_repo_uri "$_REPO_URI"; then
        echo "$_REPO_URI"
    fi
}

_lookup_repos() {
    env | \
        cut -d'=' -f1 | \
        grep -E 'MKPM_REPO_\w+' | \
        gsed 's|^MKPM_REPO_||g' | \
        tr '[:upper:]' '[:lower:]'
}

_remove() {
    _PACKAGE_NAME=$1
    rm -rf \
        "$_CWD/.mkpm/$_PACKAGE_NAME" \
        "$_CWD/.mkpm/-$_PACKAGE_NAME" \
        "$_CWD/.mkpm/.pkgs/$_PACKAGE_NAME" 2>/dev/null || true
    if [ "$MKPM" = "" ]; then
        gsed -i "/^\(\s{4}\|\t\)${_PACKAGE_NAME}=[0-9]\+\(\.[0-9]\+\)*\s*\\\\\?\s*$/d" "$_CWD/mkpm.mk"
        _trim_mkpm_file
    fi
}

_upgrade() {
    _REPO_NAME="$(echo $1 | tr '[:lower:]' '[:upper:]')"
    _PACKAGE_NAME=$2
    _REPO_URI=$(_lookup_repo_uri $_REPO_NAME)
    _REPO_PATH=$(_repo_path $_REPO_URI)
    if [ "$_REPO_URI" = "" ]; then
        _echo "repo name $_REPO_NAME is not valid" 1>&2
        exit 1
    fi
    if _is_repo_uri "$_REPO_NAME"; then
        _echo "repo name $_REPO_NAME is not valid" 1>&2
        exit 1
    fi
    _update_repo $_REPO_URI $_REPO_PATH
    if [ "$_PACKAGE_NAME" = "" ]; then
        _PACKAGES_ENV=$(echo export MKPM_PACKAGES_$_REPO_NAME)
        _PACKAGES=$(awk 'sub(/\\$/,""){printf("%s",$0);next};1' "$_CWD/mkpm.mk" | grep "$_PACKAGES_ENV" | gsed 's|^.*:= ||g')
        for p in $_PACKAGES; do
            _PACKAGE_NAME=$(echo $p | cut -d'=' -f1)
            _install $_PACKAGE_NAME $_REPO_URI $_REPO_NAME
        done
    else
        _install $_PACKAGE_NAME $_REPO_URI $_REPO_NAME
    fi
}

_reinstall() {
    rm -rf "$_CWD/.mkpm" 2>/dev/null || true
    if gmake --version >/dev/null 2>/dev/null; then
        gmake "$(date)	$(date)" 2>/dev/null || true
    else
        make "$(date)	$(date)" 2>/dev/null || true
    fi
}

_init() {
    if [ "$MKPM" != "" ]; then
        _echo "init cannot be run from makefile" 1>&2
        exit 1
    fi
    if [ ! -f "$_CWD/.git/HEAD" ]; then
        _echo "init must be run from the root of a git project" 1>&2
        exit 1
    fi
    if [ -f "$_CWD/mkpm.mk" ]; then
        _echo "mkpm already initialized" 1>&2
        exit 1
    fi
    rm -rf "$_CWD/.mkpm"
    cat <<EOF > "$_CWD/mkpm.mk"
############# MKPM BOOTSTRAP SCRIPT BEGIN #############
MKPM_BOOTSTRAP := $DEFAULT_MKPM_BOOTSTRAP
export PROJECT_ROOT := \$(abspath \$(dir \$(lastword \$(MAKEFILE_LIST))))
NULL := /dev/null
TRUE := true
ifneq (\$(patsubst %.exe,%,\$(SHELL)),\$(SHELL))
	NULL = nul
	TRUE = type nul
endif
include \$(PROJECT_ROOT)/.mkpm/.bootstrap.mk
\$(PROJECT_ROOT)/.mkpm/.bootstrap.mk:
	@mkdir \$(@D) 2>\$(NULL) || \$(TRUE)
	@\$(shell curl --version >\$(NULL) 2>\$(NULL) && \\
		echo curl -Lo || echo wget -O) \\
		\$@ \$(MKPM_BOOTSTRAP) >\$(NULL)
############## MKPM BOOTSTRAP SCRIPT END ##############
EOF
    if [ ! -f "$_CWD/Makefile" ]; then
        cat <<EOF > "$_CWD/Makefile"
include mkpm.mk
ifneq (,\$(MKPM_READY))

endif
EOF
    fi
    _repo_add default "$DEFAULT_MKPM_REPO"
}

_dependencies() {
    _update_repo
    echo dependencies $1
}

_prepare() {
    if [ "$MKPM" != "" ] && [ "$EXPECTED_MKPM_CLI_VERSION" != "$MKPM_CLI_VERSION" ]; then
        _echo "mkpm cli version $MKPM_CLI_VERSION does not match expected version $EXPECTED_MKPM_CLI_VERSION" 1>&2
        exit 1
    fi
    if [ ! -f "$_REPOS_PATH" ]; then
        mkdir -p "$_REPOS_PATH"
    fi
}

_update_repo() {
    _REPO_URI=$1
    _REPO_PATH=$2
    _echo "updating repo $_REPO_URI"
    if [ ! -d "$_REPO_PATH" ]; then
        git clone -q --depth 1 "$_REPO_URI" "$_REPO_PATH" || exit 1
    fi
    cd "$_REPO_PATH"
    git config advice.detachedHead false >/dev/null
    git config lfs.locksverify true >/dev/null
    git fetch -q --depth 1 --tags || exit 1
}

_repo_path() {
    echo $_REPOS_PATH/$(echo $1 | md5sum | cut -d ' ' -f1)
}

_get_default_branch() {
    git branch -r --points-at refs/remotes/origin/HEAD | grep '\->' | \
        cut -d' ' -f5 | cut -d/ -f2
}

_repo_add() {
    if [ "$MKPM" != "" ]; then
        _echo "repo-add cannot be run from makefile" 1>&2
        exit 1
    fi
    _REPO_NAME=$1
    _REPO_URI=$2
    if [ "$(_lookup_repo_uri $_REPO_NAME)" != "" ]; then
        _echo "repo $_REPO_NAME already exists" 1>&2
        exit 1
    fi
    if ! _is_repo_uri "$_REPO_URI"; then
        _echo "invalid repo uri $_REPO_URI" 1>&2
        exit 1
    fi
    _BODY="export MKPM_PACKAGES_$( \
        echo $_REPO_NAME | tr '[:lower:]' '[:upper:]' \
    ) := \\\\\n\nexport MKPM_REPO_$( \
        echo $_REPO_NAME | tr '[:lower:]' '[:upper:]' \
    ) := \\\\\n	${_REPO_URI}"
    _LINE_NUMBER=$(cat -n "$_CWD/mkpm.mk" | \
        grep "#\+ MKPM BOOTSTRAP SCRIPT BEGIN" | grep -oE '[0-9]+')
    if [ "$_LINE_NUMBER" = "" ]; then
        gsed -i -e "\$a\\\\n${_BODY}" "$_CWD/mkpm.mk"
    else
        gsed -i "${_LINE_NUMBER}i\\${_BODY}\n" "$_CWD/mkpm.mk"
    fi
    _trim_mkpm_file
    _reset
    _echo "added repo $_REPO_NAME"
}

_repo_remove() {
    if [ "$MKPM" != "" ]; then
        _echo "repo-remove cannot be run from makefile" 1>&2
        exit 1
    fi
    _REPO_NAME=$1
    if [ "$(_lookup_repo_uri $_REPO_NAME)" = "" ]; then
        _echo "repo $_REPO_NAME does not exist" 1>&2
        exit 1
    fi
    gsed -i -z "s|\s*export[ ]\+MKPM_PACKAGES_$(echo $_REPO_NAME | tr '[:lower:]' '[:upper:]' \
        )"'[ \t]\+:=[ \t]*\\[ \t]*\(\n[ \t]*[^ \t\n=]\+=[^ \t\n]\+\([ \t]\+\\\)\?[ \t]*\)*\s*export[ ]\+MKPM_REPO_'"$( \
            echo $_REPO_NAME | tr '[:lower:]' '[:upper:]' \
        )"'[ \t]\+:=[ \t]*\\[ \t]*\n[ \t]*[^\n]\+\s*|\n\n|' "$_CWD/mkpm.mk"
    _trim_mkpm_file
    _reset
    _echo "removed repo $_REPO_NAME"
}

_reset() {
    if [ -d "$_CWD/.mkpm" ]; then
        rm -rf $(find "$_CWD/.mkpm" \
            -not -path "$_CWD/.mkpm" \
            -not -path "$_CWD/.mkpm/.bootstrap.mk" \
            -not -path "$_CWD/.mkpm/.bin" \
            -not -path "$_CWD/.mkpm/.bin/**")
    fi
}

_create_cache() {
    cd "$_CWD/.mkpm"
    touch .cache.tar.gz
    tar -czf .cache.tar.gz \
        --exclude '.bootstrap' \
        --exclude '.bootstrap.mk' \
        --exclude '.cache.tar.gz' \
        --exclude '.failed' \
        --exclude '.preflight' \
        --exclude '.ready' \
        --exclude '.tmp' \
        .
}

_trim_mkpm_file() {
    gsed -i -z 's|\t\([^ \t\n=]\+=[^ \t\n]\+\)[ \t]\+\\[ \t]*\n\([ \t]*\n[ \t]*\)\+|\t\1\n\n|g' "$_CWD/mkpm.mk"
}

_echo() {
    if [ "$MKPM" = "" ]; then
        echo $@
    else
        echo "MKPM: $@"
    fi
}

if [ -f "$_CWD/.mkpm/.bin/mkpm" ] && \
    [ "$(realpath "$0")" != "$(realpath "$_CWD/.mkpm/.bin/mkpm")" ]; then
    "$_CWD/.mkpm/.bin/mkpm" $@
    exit
fi

if ! test $# -gt 0; then
    set -- "-h"
fi

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "mkpm - makefile package manager"
            echo " "
            echo "mkpm [options] command <PACKAGE>"
            echo " "
            echo "options:"
            echo "    -h, --help                    show brief help"
            echo "    -s, --silent                  silent output"
            echo " "
            echo "commands:"
            echo "    i install <PACKAGE>                   install a package from default git repo"
            echo "    i install <REPO> <PACKAGE>            install a package from git repo"
            echo "    r remove <PACKAGE>                    remove a package"
            echo "    d dependencies <PACKAGE>              dependencies required by package"
            echo "    u upgrade                             upgrade all packages from default git repo"
            echo "    u upgrade <REPO>                      upgrade all packages from git repo"
            echo "    u upgrade <REPO> <PACKAGE>            upgrade a package from git repo"
            echo "    ra repo-add <REPO_NAME> <REPO_URI>    add repo"
            echo "    rr repo-remove <REPO_NAME>            remove repo"
            echo "    reinstall                             reinstal all packages"
            echo "    init                                  initialize mkpm"
            exit 0
        ;;
        -s|--silent)
            export _SILENT=1
            shift
        ;;
        -*)
            echo "invalid option $1" 1>&2
            exit 1
        ;;
        *)
            break
        ;;
    esac
done

case "$1" in
    _install)
        export _COMMAND=install
        shift
    ;;
    i|install)
        export _COMMAND=install
        shift
        if test $# -gt 0; then
            export _PARAM1=$1
            shift
        else
            _echo "no repo specified" 1>&2
            exit 1
        fi
        if test $# -gt 0; then
            export _PARAM2=$1
            shift
        else
            export _PARAM2=$_PARAM1
            export _PARAM1=default
        fi
    ;;
    r|remove)
        export _COMMAND=remove
        shift
        if test $# -gt 0; then
            export _PARAM1=$1
            shift
        else
            _echo "no package specified" 1>&2
            exit 1
        fi
    ;;
    d|dependencies)
        export _COMMAND=dependencies
        shift
        if test $# -gt 0; then
            export _PARAM1=$1
            shift
        else
            _echo "no package specified" 1>&2
            exit 1
        fi
    ;;
    u|upgrade)
        export _COMMAND=upgrade
        shift
        if test $# -gt 0; then
            export _PARAM1=$1
            shift
        else
            export _PARAM1=default
        fi
        if test $# -gt 0; then
            export _PARAM2=$1
            shift
        fi
    ;;
    ra|repo-add)
        export _COMMAND=repo-add
        shift
        if test $# -gt 0; then
            export _PARAM1=$1
            shift
        else
            _echo "no repo name specified" 1>&2
            exit 1
        fi
        if test $# -gt 0; then
            export _PARAM2=$1
            shift
        else
            _echo "no repo uri specified" 1>&2
            exit 1
        fi
    ;;
    rr|repo-remove)
        export _COMMAND=repo-remove
        shift
        if test $# -gt 0; then
            export _PARAM1=$1
            shift
        else
            _echo "no repo name specified" 1>&2
            exit 1
        fi
    ;;
    init)
        export _COMMAND=init
        shift
    ;;
    reinstall)
        export _COMMAND=reinstall
        shift
    ;;
    *)
        _echo "invalid command $1" 1>&2
        exit 1
    ;;
esac

main
