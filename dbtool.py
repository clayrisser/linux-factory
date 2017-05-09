#!/usr/bin/env python

import sys
import os

if os.geteuid() != 0:
    print('Must have root privileges')
    exit(1)

if (sys.argv[len(sys.argv)] == 'clean'):
    print('cleaning')
else:
    print('Invalid command')
    exit(1)
