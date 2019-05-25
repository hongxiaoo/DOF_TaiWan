import os


def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path


def delete_excrescent_file(file_dir, lst_path):
    with open(lst_path, 'r', encoding='utf-8') as f:
        filetxt = [line.strip() for line in f.readlines()]
    for path in file_name(file_dir):
        if path.split('.')[-1] == 'stk' or path.split('.')[-1] == 'equ':
            file_ = path.replace('\\','/').replace('C:/DOF/stackable/','`')+'`'
            if file_ not in filetxt:
                os.remove(path)


# with open('C:\\DOF\\equipment.lst', 'r', encoding='utf-8') as f:
#     filetxt = [line.strip() for line in f.readlines()]
# n = 0
# for path in file_name('C:\\DOF\\equipment'):
#     if path.split('.')[-1] == 'equ' and 'partset' not in path and 'monster' not in path and 'creature' not in path:
#         file_ = path.replace('\\','/').replace('C:/DOF/equipment/','`')+'`'
#         if file_ not in filetxt:
#             os.remove(path)
#             n+=1
# print(n)


def execute_(sql):
    try:
       cursor.execute(sql)      # 执行sql语句
       db.commit()              # 执行sql语句
    except:
       db.rollback()            # 发生错误时回滚