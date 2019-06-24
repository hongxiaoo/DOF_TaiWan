import os
import tqdm

def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path

def list_element_next(element, list, minus = False):
    if element in list:
        if list.index(element)+1 < len(list):
            if minus:
                return list[list.index(element)-1]
            else:
                return list[list.index(element)+1]
        else:
            return False
    else:
        return False




list_content = open('C:\\DOF - 副本\\impfile\\equipment.lst','r',encoding='utf-8').read().lower()
shop_7 = open('C:\\DOF - 副本\\impfile\\equipmentshop7.shp','r',encoding='utf-8').read().lower()


with open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8') as equ_list:
    equ_list_code = [line.strip() for line in equ_list.readlines()]

title_book = open('C:\\DOF - 副本\\impfile\\titlebook.etc','r',encoding='utf-8').read()

itemshop = ''
for path in tqdm.tqdm(file_name('C:\\DOF - 副本\\equipment')):
    list_path = '`' + path.replace('C:\\DOF - 副本\\equipment\\', '').replace('\\', '/') + '`'
    title_content = open(path,'r',encoding='utf-8').read()
    if 'name_' in title_content or '(古老)' in title_content or list_path.lower() in shop_7:
        continue
    else:
        if list_element_next(list_path, equ_list_code, minus=True):
            code_ = list_element_next(list_path, equ_list_code, minus=True)
            if str(code_) not in title_book and '41207' in str(code_):
                itemshop += str(code_)+'\t'
            else:
                continue
        else:
            continue
print(itemshop)

