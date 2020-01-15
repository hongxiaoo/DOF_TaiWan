# coding=utf-8
from re import findall, S
from shutil import copyfile, move
from tool import laf, GetDesktopPath, iep
from os import path


# 时装礼包组成


def get_lst(lst_path):
    """
    获取提取目标equ/stk 路径
    """
    with open(lst_path + '\\equipment\\equipment.lst') as file1:
        equ_lst = [line.strip().lower().replace('/', '\\') for line in file1.readlines()]
    with open(lst_path + '\\stackable\\stackable.lst') as file2:
        stk_lst = [line.strip().lower().replace('/', '\\') for line in file2.readlines()]

    return equ_lst, stk_lst


def extract_code(pkg_path):
    with open(pkg_path) as pkg:
        content = pkg.read()
    codes = []

    if '[package data selection]' in content:
        p1 = r'\[package data selection\]\n(.*)'
        code_ = findall(p1, content)
        for ex_code in code_:
            codes += ex_code.strip().split('\t')[::2]

    if '[equipment]' in content:
        p1 = r'\[equipment\]\n(.*)'
        code_ = findall(p1, content)
        for ex_code in code_:
            codes += ex_code.strip().split('\t')[::2]

    if '[package data]' in content:
        p2 = r'\[package data\]\n(.*)\[/package data\]'
        code_ = findall(p2, content, S)[0]
        codes += code_.strip().split('\t')[::3]

    if '[avatar]' in content:
        p1 = r'\[avatar\]\n(.*)'
        code_ = findall(p1, content)
        for ex_code in code_:
            codes += ex_code.strip().split('\t')[::4]

    # 去重
    codes_final = []
    for ex_code in codes:
        if ex_code not in codes_final:
            codes_final.append(ex_code)
    return codes_final


def copy_file(extract_file_path):
    # 创建提取后文件上级目录
    iep(path.split(extract_file_path)[0].replace('Desktop', 'Desktop\\new'))
    # 拷贝提取文件
    copyfile(extract_file_path, extract_file_path.replace('Desktop', 'Desktop\\new'))


if __name__ == '__main__':
    desktop = GetDesktopPath()
    # 获取equ stk 的lst
    equ, stk = get_lst(desktop)
    # 创建一个储存从礼包中提取的 stk或者equ 的代码
    extract_codes = []
    log = ''

    for package in laf(desktop + '\\extract'):
        # 先写入礼包lst
        pkg_lst_path = '`' + package.replace(desktop + '\\extract\\stackable\\', '').lower() + '`'

        if pkg_lst_path in stk:
            pkg_code = stk[stk.index(pkg_lst_path) - 1]

            with open(desktop + '\\new_stk.lst', 'a+') as newlst:
                newlst.write(pkg_code + '\n' + pkg_lst_path.replace('\\', '/') + '\n')
        extract_codes += extract_code(package)

    # 移动礼包文件到新文件夹
    move(desktop + '\\extract', desktop + '\\new')

    for code in extract_codes:
        # 提取文件与写入新列表
        if code in equ:
            ex_path = equ[equ.index(code) + 1]
            file_path = desktop + '\\equipment\\' + ex_path.replace('`', '')
            copy_file(file_path)
            with open(desktop + '\\new_equ.lst', 'a+') as newlst:
                newlst.write(code + '\n' + ex_path.replace('\\', '/') + '\n')
        elif code in stk:
            ex_path = stk[stk.index(code) + 1]
            file_path = desktop + '\\stackable\\' + ex_path.replace('`', '')
            copy_file(file_path)
            with open(desktop + '\\new_stk.lst', 'a+') as newlst:
                newlst.write(code + '\n' + ex_path.replace('\\', '/') + '\n')
        else:
            log += code + '\t error'

    if log:
        with open(desktop + '\\log.txt', 'w+') as log_file:
            log_file.write(log)
