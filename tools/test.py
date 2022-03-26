#!/usr/bin/env python3
import os
import subprocess
import glob
import shutil


LUA_BIN = shutil.which('lua')

DIR_TEST = os.path.join(os.getcwd(), 'test')

GLOB_TEST = os.path.join(DIR_TEST, 'test_*.lua')

TERM_GREEN = '\033[1;32m'
TERM_YELLOW = '\033[1;33m'
TERM_END = '\033[0m'

for test_file in glob.glob(GLOB_TEST):
    command = f"{ LUA_BIN } { test_file }".split()
    file = os.path.basename(test_file)
    print(f"\n{ TERM_YELLOW }[ RUNNING '{ file }' ]{ TERM_END }\n")
    process = subprocess.Popen(command, stdout=subprocess.PIPE)
    out, status = process.communicate()
    print(out.rstrip().decode('utf-8'))
    if process.returncode == 1:
        exit(1)

print(f"{ TERM_GREEN }SUCCESS!{ TERM_END }")
