#!/bin/sh

CONFD_TMP=$(pwd)/.mkpm/.tmp/confd
mkdir -p $CONFD_TMP/conf.d $CONFD_TMP/templates
cp $2 $CONFD_TMP/templates/file.tmpl
cat <<EOF > $CONFD_TMP/confd.toml
backend = "file"
confdir = "$CONFD_TMP"
file = ["$(pwd)/$1"]
onetime = true
keys = ["/myapp/database/url"]
EOF
cat <<EOF > $CONFD_TMP/conf.d/config.toml
[template]
src = "file.tmpl"
dest = "$3"
EOF
shift 3
exec confd -config-file $CONFD_TMP/confd.toml $@
 