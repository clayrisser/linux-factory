#!/usr/bin/env python

import sys
import os

if os.geteuid() != 0:
    print('Must have root privileges')
    exit(1)

command = sys.argv[len(sys.argv) - 1]

if command == 'valid':
    invalid_users = os.popen('awk -F: \'$3 == 999\' /etc/passwd').read()
    if len(invalid_users) > 0:
        print('Lower following users permissions . . .')
        print(invalid_users)
    else:
        print('all clear')
elif command == 'packages':
    os.system('dpkg-query -W --showformat=\'${Installed-Size}\t${Package}\n\' | sort -nr | less')
elif command == 'debconf':
    os.system('debconf-get-selections')
elif command == 'clean':
    os.system('apt-get clean')
    print('cleaned apt-get')
    os.system('''
    rm -rf /tmp/* ~/.bash_history \
    /usr/bin/dbinit \
    /usr/bin/dbtool \
    /var/lib/dbus/machine-id \
    /sbin/initctl
    dpkg-divert --rename --remove /sbin/initctl
    ''')
    print('cleaned temporary files')
    print('system cleaned')
elif command == 'exit':
    os.system('''
    dbtool clean
    umount /proc || umount -lf /proc
    umount /sys
    umount /dev/pts
    ''')
    print('unmounted /proc /sys /dev/pts')
    os.system('exit')
else:
    print('Invalid command')
    exit(1)
