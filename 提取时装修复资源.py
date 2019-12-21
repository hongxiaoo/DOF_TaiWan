# coding=utf-8
import os
import re
import pickle
#职业 部位 全部删除 重新补充


def list_all_files(root_dir):
    _files = []
    _list = os.listdir(root_dir)  # 列出文件夹下所有的目录与文件
    for i in range(0, len(_list)):
        path = os.path.join(root_dir, _list[i])
        if os.path.isdir(path):
            _files.extend(list_all_files(path))
        if os.path.isfile(path):
            _files.append(path)
    return _files


def GetDesktopPath():
  return os.path.join(os.path.expanduser("~"), 'Desktop')

desktop = GetDesktopPath()

avatar_dict = {}

for file in list_all_files(desktop + '\\avatar') :
    with open(file) as text:
        content = text.read()
    re_ = re.search(r'`item/avatar/.*/(.*)\.img', content).group(1)
    job = re_.split('_')[0]
    avatar_dict[job] = {}

for file in list_all_files(desktop + '\\avatar'):
    with open(file) as text:
        content = text.read()
    re_ = re.search(r'`item/avatar/.*/(.*)\.img', content).group(1)
    job = re_.split('_')[0]
    part = re_.split('_')[1]
    p_type_s = re.search(r'\[avatar type select\].*\[/avatar type select\]', content, re.S).group()
    avatar_dict[job][part] =  p_type_s







