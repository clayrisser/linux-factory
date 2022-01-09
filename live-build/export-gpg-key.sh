#!/bin/sh

if [ "$KEYSEVER" = "" ]; then
	KEYSEVER=hkp://pool.sks-keyservers.net
fi
_FINGERPRINT="$1"
if [ "$_FINGERPRINT" = "" ]; then
	echo "missing fingerprint" >&2
	exit 1
fi
shift
_FILENAME="$1"
if [ "$_FILENAME" = "" ]; then
	_FILENAME=$_FINGERPRINT
elif [ "$_FILENAME" = "--armor" ]; then
	_FILENAME=$_FINGERPRINT.asc
else
	shift
fi
_ARGS="$@"

gpg --keyserver $KEYSERVER --recv-keys $_FINGERPRINT
gpg $_ARGS --export $_FINGERPRINT > $_FILENAME
cat $_FILENAME | gpg --list-packets --verbose
