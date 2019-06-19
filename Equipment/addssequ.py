import os
import tqdm
import pickle
import pprint



def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path

def add_equ(list_path,code):
    if list_path  in equ_list:
        return False
    else:
        f.write(str(code)+ '\n'+ list_path+ '\n')
        print(list_path)
        return True

def add_equ_dictinfo(list_path):
    pass

equ_code = 412061805
equ_list = open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8').read()
with open('C:\\DOF - 副本\\impfile\\add_equipment.lst', 'w+') as f:
    for path in tqdm.tqdm(file_name('C:\\DOF - 副本\\equipment')):
        equ_content = open(path,'r', encoding='utf-8').read()
        if 'name_'  in equ_content:
            os.remove(path)
        elif '活動' in equ_content:
            os.remove(path)
        elif '(舊)'  in equ_content:
            os.remove(path)
        elif '(古老)'  in equ_content:
            os.remove(path)
        else:
            list_path = '`' + path.replace('C:\\DOF - 副本\\equipment\\', '').replace('\\', '/') + '`'
            if add_equ(list_path,equ_code):
                equ_code += 1
