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

equ_list = open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8').read().lower()
shop_content = open('C:\\DOF - 副本\\impfile\\stackableshp28.shp', 'r',encoding='utf-8').read().lower()

with open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8') as f:
    equ_list_code = [line.strip() for line in f.readlines()]

for path in tqdm.tqdm(file_name('C:\\DOF - 副本\\equipment')):
    list_path = '`' + path.replace('C:\\DOF - 副本\\equipment\\', '').replace('\\', '/') + '`'
    code_ = list_element_next(list_path, equ_list_code, minus=True)
    if str(code_) not in shop_content:
        os.remove(path)
    else:
        print(code_)
