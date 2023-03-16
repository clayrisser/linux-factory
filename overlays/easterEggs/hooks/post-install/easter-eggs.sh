#!/bin/sh

sed -i 's|Defaults\(\s\+\)mail_badpass|Defaults\1mail_badpass\nDefaults\1insults|' /etc/sudoers
