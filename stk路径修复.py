# coding=utf-8
from os import path, makedirs, listdir, remove
from re import findall, S
from shutil import copyfile, move
from tool import laf, GetDesktopPath


desktop = GetDesktopPath()
with open(desktop + '\\stackable\\stackable.lst') as file:
    stk_lst = [line.strip().lower() for line in file.readlines()]

for stk_file in laf(desktop + '\\stackable'):
    if '.stk' in stk_file:

        stk_lst_path = '`' + stk_file.replace(desktop + '\\stackable\\', '').lower().replace('\\', '/') + '`'
        stk_code = path.split(stk_file)[1].split('.')[0]
        if stk_code not in stk_lst:
            print stk_lst_path
            remove(stk_file)
        else:
            stk_lst_in_lst = stk_lst[stk_lst.index(stk_code) + 1]
            # print stk_code
            # print stk_lst_path
            # print stk_lst_in_lst
            if stk_lst_path != stk_lst_in_lst:
                stk_lst[stk_lst.index(stk_code) + 1] = stk_lst_path
                # print stk_lst[stk_lst.index(stk_code) + 1]

new_stk_lst = ''

for line in stk_lst:
    new_stk_lst += line + '\n'

with open(desktop + '\\stackable\\stackable.lst', 'w+') as file:
    file.write(new_stk_lst)

