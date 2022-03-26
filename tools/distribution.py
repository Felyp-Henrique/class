#!/usr/bin/env python3
import os
import zipfile


ZIP_PATH = os.path.join(os.getcwd(), 'class.zip')

if os.path.exists(ZIP_PATH):
    os.remove(ZIP_PATH)

with zipfile.ZipFile(ZIP_PATH, 'w') as file:
    file.write('class.lua')
    file.write('LICENSE.md')
