# coding=utf-8
# import os
import pickle
import re
from tool import laf, GetDesktopPath
import os

desktop = GetDesktopPath()
with open('../../stackable/avatar_type.pk', 'rb') as pick:
    avatar_dict = pickle.load(pick)

# print (avatar_dict)

for file_path in laf(desktop + '\\equipment'):
    if os.path.splitext(file_path)[1] == '.equ' and 'avatar' in file_path:
        with open(file_path, 'r', encoding='utf-8',errors='ignore') as text:
            content = text.read()
        # try:

        # 匹配职业
        result = re.search(r'`item/avatar/(.*)/(.*)\.img', content)
        if result is not None:
            re_ = result.group(2)
            if result.group(1) != 'common':
                job = re_.split('_')[0]
                part = re_.split('_')[1]
                if part == 'atong':
                    part = 'abody'
                p = '''\[avatar type select\][^/]*\[/avatar type select\]'''
                # 修复时装购买期限
                new_content = re.sub(p, '', content, re.S) + '\n' + avatar_dict[job][part]
                content = new_content

        # 修复时装属性选择
        abiliti_p = re.compile(r'''\[avatar select ability\].*\[/avatar select ability\]''', re.S)
        sub_p = re.compile(r'\t\d{,2}\n\t', re.S)
        # 匹配content中是否有ability
        ability_part_Obj = re.search(abiliti_p, content)
        if ability_part_Obj:
            # 替换国服时装文件中的index
            new_content2 = re.sub(abiliti_p, re.sub(sub_p, '\n\t', ability_part_Obj.group()), content)
            content = new_content2
        # 添加染色
        if '[enable dye]' not in content:
            content += '''\n\n[enable dye]
        1	0'''

        with open(file_path, 'w+', encoding='utf-8') as new_file:
            new_file.write(content)
        #
        # except:
        #     print(file_path + '\t error')
        #     break





