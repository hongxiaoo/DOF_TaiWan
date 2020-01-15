"""
一键提取副本
"""
from tool import *
from re import findall
from os import path

# 设立工作主目录
main_dir = GetDesktopPath() + '\\extract\\'


# 读取各列表
def read_lst():
    lst_lists = []
    all_lst = ['dungeon', 'map', 'monster', 'passiveobject', 'stackable']
    for element in all_lst:
        with open(main_dir + element + '\\' + element + '.lst') as lst_file:
            lst_lists.append([line.strip().replace('/', '\\').lower() for line in lst_file.readlines()])
    return lst_lists


# 根据副本路径提取副本文件以及副本内包含的img ani map
def analyze_dgn(dfp):
    # dfp = dgn file path
    with open(dfp, 'r', encoding='utf-8') as dgn:
        f_content = dgn.read()
        ani = findall('`.*\.ani`', f_content)
        img = findall('`.*\.img`', f_content)
    if ani != []:
        ani_file_path = path.split(dfp)[0] + '\\' + ani[0].replace('`','').replace('/', '\\')
        return [ani_file_path, img]
    else:
        return ['', img]


if __name__ == '__main__':
    # for element in read_lst():
    #     print(element , '\n')
    analyze_dgn(main_dir + 'dungeon/act3/breeding.dgn'.replace('/', '\\'))
    pass
