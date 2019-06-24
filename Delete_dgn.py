import os
import tqdm

def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path

stk_list = open('C:\\DOF - 副本\\impfile\\dungeon.lst', 'r',encoding='utf-8').read().lower()
for path in tqdm.tqdm(file_name('C:\\DOF - 副本\\dungeon')):
    list_path = '`' + path.replace('C:\\DOF - 副本\\dungeon\\', '').replace('\\', '/') + '`'
    if '.dgn' in list_path and list_path.lower() not in stk_list:
        try:
            print(list_path)
            os.remove(path)
        except:
            print(path)
for root, dirs, files in os.walk('C:\\DOF - 副本\\dungeon', topdown=False):
    # do something like os.remove(file)
    if not os.listdir(root):
        os.rmdir(root)
        print(root)