#!/usr/bin/env python3

import zipfile
import sys

with zipfile.ZipFile(sys.argv[1], 'r') as zip_ref:
   zip_ref.extractall(sys.argv[2])
