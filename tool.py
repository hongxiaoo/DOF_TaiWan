# coding=utf-8

import os

def laf(root_dir):
    _files = []
    _list = os.listdir(root_dir)  # 列出文件夹下所有的目录与文件
    for i in range(0, len(_list)):
        lst_path = os.path.join(root_dir, _list[i])
        if os.path.isdir(lst_path):
            _files.extend(laf(lst_path))
        if os.path.isfile(lst_path):
            _files.append(lst_path)
    return _files


def GetDesktopPath():
    return os.path.join(os.path.expanduser("~"), 'Desktop')


def iep(dir_path):
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)