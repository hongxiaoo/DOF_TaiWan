# coding=utf-8
from os import path, makedirs, listdir
from re import findall, S, sub
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

for stk_file in list_all_files(desktop + '\\stackable'):
    if '.stk' in stk_file:
        with open(stk_file) as stk_:
            content = stk_.read()
            if '[expiration date]' in content:
                content = sub(r'\[expiration date\]\n.*\n', '', content, S)
        with open(stk_file, 'w+') as stk_2:
            stk_2.write(content)
