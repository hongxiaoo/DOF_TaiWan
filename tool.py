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
    # 获取桌面路径
    return os.path.join(os.path.expanduser("~"), 'Desktop')


def iep(dir_path):
    # 如果路径不存在则创建
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)


def fp2lp(file_path):
    """
    文件路径转换为列表中路径
    :param file_path: 文件的系统路径
    :return: 该文件在list中的路径
    """
    split_path = ''
    if 'equipment' in file_path:
        split_path = '`' + file_path.split('equipment\\')[1].replace('\\', '/').lower() + '`'
    elif 'stackable' in file_path:
        split_path = '`' + file_path.split('stackable\\')[1].replace('\\', '/').lower() + '`'
    elif 'aicharacter' in file_path:
        split_path = '`' + file_path.split('aicharacter\\')[1].replace('\\', '/').lower() + '`'
    # 其他路径待添加
    return split_path


def lst_sort(lst_path_list):
    """
    lst文件排序
    :param lst_path_list: lst文件路径的一个列表
    :return: 返回空
    """
    for path in lst_path_list:
        with open(path) as f1:
            list_ = [line.strip() for line in f1.readlines()]
            new_order_lst = [int(element) for element in list_[::2][1:]]
            new_order_lst.sort()

            new_stk_lst = '#PVF_File' + '\n'
            for element in new_order_lst:
                new_stk_lst += str(element) + '\n' + list_[list_.index(str(element)) + 1] + '\n'

        with open(path, 'w') as f2:
            f2.write(new_stk_lst)
    return None


def lst_de_reprocessing(lst_path_list):
    """
    lst文件去重
    :param lst_path_list: 一个包含lst文件路径的列表
    :return: 返回空
    """
    for path in lst_path_list:
        with open(path) as f1:
            list_ = [line.strip() for line in f1.readlines()]
        codes = list_[::2]
        # print codes[1:]
        new_codes = []
        for code in codes:  # 去重codes列表
            if code not in new_codes:
                new_codes.append(code)
        content = ''
        for code in new_codes:  # 根据codes列表再重新写入新lst文件
            content += code + ' \n' + list_[list_.index(code) + 1] + '\n'
        with open(path, 'w+') as new_file:
            new_file.write(content)
    return None


def file_rename(file_path, new_name):
    """
    更改文件名
    :param file_path:文件路径
    :param new_name: 修改后名称，不加后缀
    :return: 返回修改后文件路径
    """
    path_ = os.path.split(file_path)[0]
    ext = os.path.splitext(file_path)[1]
    new_path = path_ + '\\' + new_name + ext
    os.rename(file_path, new_path)
    return new_path


def id2lp(item_id, lst):
    """
    将id转换为lst中的path
    :param item_id: id
    :param lst: lst列表
    :return: 如果存在于lst就返回lp，否则返回False
    """
    if item_id in lst:
        lp = lst[lst.index(item_id) + 1]
        return lp
    else:
        return False


def lp2id(lp, lst):
    """
    将lst中的path转换为id
    :param lp:lst中的path
    :param lst: lst列表
    :return: 如果存在于lst就返回id，否则返回False
    """
    if lp.lower() in lst:
        item_id = lst[lst.index(lp) - 1]
        return item_id
    else:
        return False


def lst2list(lst_file_path):
    """
    将lst文件转换为list列表对象
    :param lst_file_path: lst文件路径
    :return: list对象
    """
    with open(lst_file_path, 'r') as lst_file:
        lst_list = [line.lower().strip() for line in lst_file.readlines()]

    return lst_list


def lst_compare(lst1, lst2):
    different = '同样代码，不同文件\n'
    in1not2 = '---------------------------\n在lst1不在lst2\n'
    in2not1 = '---------------------------\n在lst2不在lst1\n'

    ids_list = list(set(lst1[::2] + lst2[::2]))
    for item_code in ids_list:
        if item_code in lst1 and item_code in lst2:
            if id2lp(item_code, lst1) == id2lp(item_code, lst2):
                continue
            else:
                different += item_code + '\t' + id2lp(item_code, lst1) + '\n'
                different += item_code + '\t' + id2lp(item_code, lst2) + '\n'
        elif item_code in lst1 and item_code not in lst2:
            in1not2 += item_code + '\t' + id2lp(item_code, lst1) + '\n'
        elif item_code not in lst1 and item_code in lst2:
            if 'atswordman' in id2lp(item_code, lst2):
                continue
            in2not1 += item_code + '\t' + id2lp(item_code, lst2) + '\n'

    with open(GetDesktopPath() + '\\compare.txt', 'w') as f:
        f.write(different + in1not2 + in2not1)


if __name__ == '__main__':
    desktop = GetDesktopPath()
    for file in laf(desktop + '\\equipment'):
        print(file)
        break
