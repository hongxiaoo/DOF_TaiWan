from tqdm import tqdm
import pickle
avatar_dict = pickle.load(open('avatar.pkl', 'rb'))


def line_code(key):
    '''
    获取equ列表中时装的代码
    :param key:
    :return:
    '''
    type_code = []
    for ava_type in ['cap', 'skin', 'coat', 'face', 'hair', 'shoes', 'belt', 'neck', 'pants']:
        type_code += [equipment_list[equipment_list.index(line) - 1] for line in dict_[key] if ava_type in line]
        equs = [line for line in dict_[key] if ava_type in line]
        equ_finished(equs, ava_type, key)
    return type_code


def equ_finished(equs, ava_type, key):
    '''
    补齐时装缺少的[avatar type select]，[avatar select ability]
    :param equs:
    :param ava_type:
    :param key:
    :return:
    '''
    for equ in equs:
        equ_path = 'C:\\DOF\\equipment\\'+equ.replace('`', '').replace('/', '\\')
        with open(equ_path, 'r+', encoding='utf-8') as f:
            equ_infos = [line.strip() for line in f.readlines()]
            if ava_type == 'coat':
                if '[avatar select ability]' not in equ_infos:
                    f.write(avatar_dict['type_coat'][key])
            else:
                if '[avatar select ability]' not in equ_infos:
                    f.write(avatar_dict['ability'][ava_type])
            if '[avatar type select]' not in equ_infos:
                f.write(avatar_dict['select'][ava_type])


def write_code(codes):
    '''
    输出商城单件时装的代码
    :param codes:
    :return:
    '''
    with open('shopavatar.txt', 'w') as f:
        index = 1000000
        for code in codes:
            line = '\t{}\t{}\t3\t0\t0\t-1\t-1\t{}\t4\t0\t0\t-1\t\n'.format(str(index), code, code)
            f.write(line)
            index += 1


def zhiye_equs():
    '''
    输出职业：对应所有时装文件列表的字典
    :return:
    '''
    swordman = [line for line in equipment_list if 'swordman/avatar/' in line]
    gunner = [line for line in equipment_list if 'gunner/avatar/' in line]
    atgunner = [line for line in equipment_list if 'gunner/at_avatar/' in line]
    fighter = [line for line in equipment_list if 'fighter/avatar/' in line]
    atfighter = [line for line in equipment_list if 'fighter/at_avatar/' in line]
    mage = [line for line in equipment_list if 'mage/avatar/' in line]
    atmage = [line for line in equipment_list if 'mage/at_avatar/' in line]
    priest = [line for line in equipment_list if 'priest/avatar/' in line]
    thief = [line for line in equipment_list if 'thief/avatar/' in line]
    zhiye_dict = {'swordman':swordman, 'gunner':gunner, 'atgunner':atgunner, 'fighter':fighter, 'atfighter':atfighter,
                  'mage':mage, 'atmage':atmage, 'priest':priest, 'thief':thief}
    return zhiye_dict


if __name__ == '__main__':
    with open('C:\\DOF\\equipment.lst', 'r') as f:
        equipment_list = [line.strip() for line in f.readlines()]
    codes = []
    dict_ = zhiye_equs()
    for key in tqdm(dict_.keys()):
        codes += line_code(key)
    write_code(codes)



