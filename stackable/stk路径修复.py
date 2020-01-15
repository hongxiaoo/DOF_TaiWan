# coding=utf-8
'''
功能： 将打乱后的stackable目录下stk文件的lst路径修复，以便于随意更改stk文件的位置
'''
from os import path, remove
from tool import *

desktop = GetDesktopPath()
with open(desktop + '\\stackable\\stackable.lst') as file:
    stk_lst = [line.strip().lower() for line in file.readlines()]

for file_path in laf(desktop + '\\stackable'):
    if '.stk' in file_path:

        stk_lp = fp2lp(file_path) # 将文件路径转换为lst内路径

        stk_id = path.split(file_path)[1].split('.')[0]   # 从文件名内获取代码

        if stk_id not in stk_lst:
            print(stk_lp)
            remove(file_path)
        else:
            stk_lst_in_lst = stk_lst[stk_lst.index(stk_id) + 1] # 根据代码获取lst中的路径
            # print stk_code
            # print stk_lst_path
            # print stk_lst_in_lst
            if stk_lp != stk_lst_in_lst:    # 如果目标文件的路径与lst内路径不同，则替换为现在目标文件路径
                stk_lst[stk_lst.index(stk_id) + 1] = stk_lp
                # print stk_lst[stk_lst.index(stk_code) + 1]

new_stk_lst = ''

for line in stk_lst:
    new_stk_lst += line + '\n'

with open(desktop + '\\stackable\\stackable.lst', 'w+') as file:    # 重新写入lst文件
    file.write(new_stk_lst)
