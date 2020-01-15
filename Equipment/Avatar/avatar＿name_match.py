from tool import *
import re
import pymysql

desktop = GetDesktopPath()

conn = pymysql.connect(host = 'localhost', user = 'root', password = 'Tokeikaonly1', port = 3306, db = 'dnf')
cursor = conn.cursor()

for file_path in laf(desktop + '\\equipment'):
    if os.path.splitext(file_path)[1] == '.equ':
        with open(file_path, 'r', encoding='utf-8') as ava_f:
            content = ava_f.read()
            name = re.findall('`(.*)`', content)
            model = re.findall('''\[variation\]
	(\d*	\d*)

\[layer variation\]''', content, re.S)
            ava_type = re.findall('`item/avatar/.*/(.*)\.img`', content)
            if name == [] or model == [] or ava_type == []:
                continue
            elif 'name_' in name[0] or name[0] == '' or '找不到代' in name[0]:
                continue
            else:
                SQL = '''INSERT INTO CN_avatar(name, type, model) VALUES ('{name_}', '{type_}', '{modle_}')'''.format(name_ = name[0],
                                                                                                                type_ = ava_type[0],
                                                                                                                modle_ = str(model[0][0]) + str(model[0][1]))
                print(SQL)
                try:
                    cursor.execute(SQL)
                    conn.commit()
                except:
                    conn.rollback()

conn.close()

