# coding=utf-8
import os
import pickle
import re

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
with open('avatar_type.pk','rb') as pick:
    avatar_dict = pickle.load(pick)

print avatar_dict

for file in list_all_files(desktop + '\\avatar'):
    if '.equ' in file:
        with open(file) as text:
            content = text.read()
        try:
            re_ = re.search(r'`item/avatar/.*/(.*)\.img', content).group(1)
            job = re_.split('_')[0]
            part = re_.split('_')[1]
            p = '''\[avatar type select\][^/]*\[/avatar type select\]'''
            new_content = re.sub(p, '', content, re.S) + '\n' + avatar_dict[job][part]

            if '[enable dye]' not in new_content:
                new_content += '''\n\n[enable dye]
            1	0'''

            with open(file, 'w+') as new_file:
                new_file.write(new_content)
        except:
            print file + '\t error'




