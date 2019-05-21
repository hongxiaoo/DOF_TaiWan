import os
import pymysql
from tqdm import tqdm

elementSQL_dict = {'[name]': '名称', '[name2]': 'name2', '[minimum level]': '等级', '[grade]': '掉落等级',
                 '[rarity]': '稀有度', '[item group name]': '类型'}
equipment_type = {'amulet': '项链', 'ring': '戒指', 'wrist': '手镯', 'magic stone': '魔法石', 'support': '辅助装备',
                  'cl waist': '布甲 腰带', 'ha waist': '重甲 腰带', 'la waist': '轻甲 腰带', 'lt waist': '皮甲 腰带',
                  'mt waist': '板甲 腰带',
                  'cl coat': '布甲 上衣', 'ha coat': '重甲 上衣', 'la coat': '轻甲 上衣', 'lt coat': '皮甲 上衣',
                  'mt coat': '板甲 上衣',
                  'cl pants': '布甲 裤子', 'ha pants': '重甲 裤子', 'la pants': '轻甲 裤子', 'lt pants': '皮甲 裤子',
                  'mt pants': '板甲 裤子',
                  'cl shoes': '布甲 鞋子', 'ha shoes': '重甲 鞋子', 'la shoes': '轻甲 鞋子', 'lt shoes': '皮甲 鞋子',
                  'mt shoes': '板甲 鞋子',
                  'cl shoulder': '布甲 头肩', 'ha shoulder': '重甲 头肩', 'la shoulder': '轻甲 头肩', 'lt shoulder': '皮甲 头肩',
                  'mt shoulder': '板甲 头肩',
                  'bglove': '拳套', 'claw': '爪', 'gauntlet': '臂铠', 'knuckle': '手套', 'tonfa': '东方棍',
                  'automatic': '自动手枪', 'bowgun': '手弩', 'hcannon': '手炮', 'musket': '步枪', 'revolver': '左轮枪',
                  'broom': '扫把', 'pole': '棍棒', 'rod': '魔杖', 'spear': '长矛', 'staff': '法杖',
                  'axe': '斧头', 'cross': '十字架', 'rosary': '念珠', 'scythe': '镰刀', 'totem': '图腾',
                  'beamswd': '光剑', 'club': '钝器', 'lswd': '巨剑', 'katana': '太刀', 'ssword': '短剑',
                  'dagger': '匕首', 'twinswd': '双剑', 'wand': '手杖'}


def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path


def execute_(sql):
    try:
       cursor.execute(sql)      # 执行sql语句
       db.commit()              # 执行sql语句
    except:
       db.rollback()            # 发生错误时回滚


def equipment_info(file_path):

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            txt = [line.strip() for line in f.readlines()]
            keys = '代码'
            values = equipment_code(file_path)
            for element in ['[name]', '[name2]', '[minimum level]', '[grade]', '[rarity]', '[item group name]']:
                if element in txt:
                    keys += ',' + elementSQL_dict[element]
                    value = txt[txt.index(element)+1].split('\t')[0].replace('`', '')
                    if element == '[item group name]':
                        values += ",'" + equipment_type[value] + "'"
                    else:
                        values += ",'" + value + "'"
            sql = "INSERT INTO equipment({})VALUES ({})".format(keys, values)
            execute_(sql)
    except:
        print(file_path+'\tFailed')


def equipment_code(file_path):
    equlistname = '`' + file_path[17:].replace('\\', '/') + '`'
    if equlistname in equipment_list:
        code = "'"+equipment_list[equipment_list.index(equlistname)-1]+"'"
    else:
        code = None
    return code


with open('C:\\DOF\\equipment.lst', 'r') as f:
    equipment_list = [line.strip() for line in f.readlines()]
db = pymysql.connect(host='localhost', user='root', password='', database='dnf')
cursor = db.cursor()
for file_path in tqdm(file_name('C:\\DOF\\equipment\\character')):
    equipment_info(file_path)
db.close()
