import os
import re
import tqdm

def file_name(file_dir):
    file_path = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            file_path.append(os.path.join(root, file))
    return file_path

def change_equinfo(file_path):
    try:
        old_content = open(file_path, 'r',encoding='utf-8').read()
        # print(old_content)
        if 'need material' in old_content:
            content_durability = re.sub(r'''\[need material\]
	.*	.*''', r'''[need material]
    3284	100''', old_content, re.S)
            with open(file_path,'w+', encoding='utf-8') as f:
                f.write(content_durability)
        else:
            with open(file_path,'a+', encoding='utf-8') as f:
                f.write(r'''[need material]
    3284	100''')
    except:
        print(file_path+'\tFailed')


for file_path in tqdm.tqdm(file_name('C:\\DOF - 副本\\equipment')):
        change_equinfo(file_path)