from tool import *
import os

desktop = GetDesktopPath()

with open(desktop + '\\equipment\\equipment.lst', 'r+') as f:
    equ_list = [line.replace('\\', '/').lower().strip() for line in f.readlines()]

# print(equ_list)


for file_path in laf(desktop + '\\equipment'):
    if '.equ' in file_path and fp2lp(file_path) not in equ_list:
        print(file_path)
        os.remove(file_path)
