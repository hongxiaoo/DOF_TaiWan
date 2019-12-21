# coding=utf-8
from os import path, makedirs, listdir, remove
from re import findall, S
from shutil import copyfile, move
def GetDesktopPath():
    return path.join(path.expanduser("~"), 'Desktop')


def list_all_files(root_dir):
    _files = []
    _list = listdir(root_dir)  # 列出文件夹下所有的目录与文件
    for i in range(0, len(_list)):
        lst_path = path.join(root_dir, _list[i])
        if path.isdir(lst_path):
            _files.extend(list_all_files(lst_path))
        if path.isfile(lst_path):
            _files.append(lst_path)
    return _files


desktop = GetDesktopPath()
with open(desktop + '\\stackable\\stackable.lst') as file:
    stk_lst = [line.strip().lower() for line in file.readlines()]

for stk_file in list_all_files(desktop + '\\stackable'):
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

