#!/bin/sh

echo 'd-i preseed/late_command string chmod +x /usr/sbin/post-install && sh /usr/sbin/post-install' >> \
    config/includes.installer/preseed.cfg
