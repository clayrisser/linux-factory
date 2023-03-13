#!/bin/sh

sed -i 's|Defaults       mail_badpass|Defaults   mail_badpass\nDefaults  insults|' /etc/sudoers
