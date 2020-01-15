# coding=utf-8
# import os
import re
# import pickle
from tool import laf, GetDesktopPath

# 职业 部位 全部删除 重新补充


desktop = GetDesktopPath()

avatar_dict = {}

for file in laf(desktop + '\\avatar'):
    with open(file) as text:
        content = text.read()
    re_ = re.search(r'`item/avatar/.*/(.*)\.img', content).group(1)
    job = re_.split('_')[0]
    avatar_dict[job] = {}

for file in laf(desktop + '\\avatar'):
    with open(file) as text:
        content = text.read()
    re_ = re.search(r'`item/avatar/.*/(.*)\.img', content).group(1)
    job = re_.split('_')[0]
    part = re_.split('_')[1]
    p_type_s = re.search(r'\[avatar type select\].*\[/avatar type select\]', content, re.S).group()
    avatar_dict[job][part] = p_type_s
