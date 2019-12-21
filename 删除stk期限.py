# coding=utf-8
from os import path, makedirs, listdir
from re import findall, S, sub
from shutil import copyfile, move
from tool import laf, GetDesktopPath



desktop = GetDesktopPath()

for stk_file in laf(desktop + '\\stackable'):
    if '.stk' in stk_file:
        with open(stk_file) as stk_:
            content = stk_.read()
            if '[expiration date]' in content:
                content = sub(r'\[expiration date\]\n.*\n', '', content, S)
        with open(stk_file, 'w+') as stk_2:
            stk_2.write(content)
