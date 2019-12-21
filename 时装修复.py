# coding=utf-8
# import os
import pickle
import re
from tool import laf, GetDesktopPath


desktop = GetDesktopPath()
with open('avatar_type.pk','rb') as pick:
    avatar_dict = pickle.load(pick)

print avatar_dict

for file in laf(desktop + '\\avatar'):
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




