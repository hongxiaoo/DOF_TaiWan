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

def del_more(list_path):
    try:
        code_index = equ_list_code.index(list_path)-1
        if str(equ_list_code[code_index]) in dict_content:
            return True
        else:
            return False
    except:
        print(list_path+'\twrong!')
        return False

dict_content = open('C:\\DOF - 副本\\impfile\\(r)itemdictionary.etc' ,'r', encoding='utf-8').read()

with open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8') as equ_list:
    equ_list_code = [line.strip() for line in equ_list.readlines()]

with open('C:\\DOF - 副本\\impfile\\add_equipment.lst', 'w+') as f:
    for path in tqdm.tqdm(file_name('C:\\DOF - 副本\\equipment')):
        list_path = '`' + path.replace('C:\\DOF - 副本\\equipment\\', '').replace('\\', '/') + '`'
        if del_more(list_path):
            os.remove(path)

