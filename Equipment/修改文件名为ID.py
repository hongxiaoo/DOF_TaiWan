"""
目标：将文件的名称改为对应ID
方法：修改原文件文件名为对应ID，将lst内文件路径修改
"""
from tool import laf, GetDesktopPath, fp2lp, file_rename, lp2id


desktop = GetDesktopPath()
with open(desktop + '\\equipment\\equipment.lst', 'r+') as f:
    lst = [line.lower().strip().replace('\\', '/') for line in f.readlines()]

for file_path in laf(desktop + "\\equipment"):
    lp = fp2lp(file_path)
    if '.equ' in file_path and lp in lst:
        id = lp2id(lp, lst)
        if id:
            new_lp = fp2lp(file_rename(file_path, id))
            print(new_lp)
            lst[lst.index(id) + 1] = new_lp

with open(desktop + '\\equipment\\equipment.lst', 'w+') as f1:
    for line in lst:
        f1.write(line + '\n')

