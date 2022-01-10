#!/bin/sh

EOF=EOF
exec cat <<EOF | sh
cat <<EOF
$(cat $1 | \
    sed 's|`|\\`|g' | \
    sed 's|\$|\\\$|g' | \
    sed "s|${OPEN:-<%}|\`eval echo |g" | \
    sed "s|${CLOSE:-%>}|\`|g")
$EOF
EOF
