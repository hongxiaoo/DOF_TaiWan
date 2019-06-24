import os
import tqdm



def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path

def add_equ(list_path):
    '''
    将不存在的equ新添加进lst
    :param list_path: 路径
    :param code: 代码
    :return:
    '''
    file_name = list_path.split('/')[-1]
    if file_name.lower()  in equ_list:
        print(file_name)
        return False
    else:
        return 1

equ_code = 41207001
# 新加equ初始代码
equ_list = open('C:\\DOF - 副本\\impfile\\equipment.lst', 'r',encoding='utf-8').read().lower()
print(equ_list)
with open('C:\\DOF - 副本\\impfile\\add_equipment.lst', 'w+') as f:
    for path in tqdm.tqdm(file_name('C:\\DOF - 副本\\equipment')):
        equ_content = open(path,'r', encoding='utf-8').read()
        if '.equ' not in path:
            os.remove(path)
            continue
        else:
            if 'name_'  in equ_content or '活動' in equ_content or  '(舊)'  in equ_content or '(古老)'  in equ_content or 'avatar' in path:
                os.remove(path)
            else:
                list_path = '`' + path.replace('C:\\DOF - 副本\\equipment\\', '').replace('\\', '/') + '`'
                if add_equ(list_path):         #如果添加，代码数+1
                    f.write(str(equ_code) + '\n' + list_path + '\n')
                    equ_code += 1
