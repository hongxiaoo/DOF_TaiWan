from os import listdir, path
from re import sub


def laf(root_dir):
    _files = []
    _list = listdir(root_dir)  # 列出文件夹下所有的目录与文件
    for i in range(0, len(_list)):
        lst_path = path.join(root_dir, _list[i])
        if path.isdir(lst_path):
            _files.extend(laf(lst_path))
        if path.isfile(lst_path):
            _files.append(lst_path)
    return _files


def GetDesktopPath():
    # 获取桌面路径
    return path.join(path.expanduser("~"), 'Desktop')


main_dir = GetDesktopPath() + '\\extract'

for file in laf(main_dir):
    if path.splitext(file)[1] == '.equ' and 'avatar' in file and 'skin' not in file and 'aura' not in file:
        with open(file, 'r', encoding='utf-8') as f:
            content = sub('''.grade.\n\t3''', '''[grade]\n\t2''', f.read())

        if '[enable dye]' not in content:
            content += '''\n\n[enable dye]
        1	0'''

        with open(file, 'w', encoding='utf-8') as f:
            f.write(content)
