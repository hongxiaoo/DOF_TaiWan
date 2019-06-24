import os
import tqdm
import pickle

rarity = {'0':'0',
          '1':'1',
          '2':'2',
          '3':'5',
          '4':'7',
          '5':'4'}

with open('C:\\Users\\tokeika\\Documents\\GitHub\\DNFTools\\Equipment\\equ_group_dict.pkl','rb+') as f:
    equ_group = pickle.load(f)
    equ_group['weaponknuckle']=10202
    print(equ_group)

with open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8') as equ_list:
    equ_list_code = [line.strip() for line in equ_list.readlines()]

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

def get_info(file_path):
    dict_info = ''
    try:
        with open(file_path,'r',encoding='utf-8') as f:
            equ_file_content = [line.strip() for line in f.readlines()]
        list_path = '`' + file_path.replace('C:\\DOF - 副本\\equipment\\', '').replace('\\', '/') + '`'
        equ_group_info = list_path.split('/')[-3]+list_path.split('/')[-2]
        elements = ['[name]','[grade]','[rarity]','[minimum level]']
        code_ = list_element_next(list_path,equ_list_code,minus=True)

        if  list_element_next('[name]',equ_file_content):
            name_ = list_element_next('[name]',equ_file_content)
        else:
            name_ = '未命名'

        if list_element_next('[grade]',equ_file_content):
            grade_ = list_element_next('[grade]',equ_file_content)
        else:
            grade_ = '80'

        if list_element_next('[rarity]',equ_file_content):
            if '傳承 : ' in name_:
                rarity_ = '3'
            elif '`boss drop`' in equ_file_content:
                rarity_ = '6'
            else:
                rarity_ = rarity[list_element_next('[rarity]',equ_file_content)]
        else:
            rarity_ = '5'

        if list_element_next('[minimum level]',equ_file_content):
            level_ = list_element_next('[minimum level]',equ_file_content)
        else:
            level_  = '80'
        with open('(r)itemdictionary.etc','a+') as f:
            if rarity_ == '6':
                boss_equ = '1'
            else:
                boss_equ = '0'
            dict_content = str(code_)+'\n'+rarity_+'\n'+level_+'\n'+grade_+'\n'+str(equ_group[equ_group_info])+'\n'+'0\n'+boss_equ+'\n0\n0\n0\n0\n0\n'+name_+'\n'
            f.write(dict_content)
            # print(dict_content)
    except:
        print(file_path)


for equ_path in file_name('C:\\DOF - 副本\\equipment'):
    get_info(equ_path)


