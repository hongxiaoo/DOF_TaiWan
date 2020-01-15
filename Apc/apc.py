from tool import *
import re
desktop = GetDesktopPath()
comment_list = []
for file_path in laf(desktop + '\\aicharacter'):
    # print(os.path.splitext(file_path))
    if os.path.splitext(file_path)[1] == '.aic':
        with open(file_path, 'r+', encoding='utf-8') as f:
            content = f.read()
            path = file_path.split(desktop + '\\')[1]
            p = '`(.*)`'
            apc_name = re.findall(p, content)[0]
            comment = '  <Comment FileName="{path_}" Text="{name}" />\n'.format(path_ = path, name = apc_name)
            print(comment)
            comment_list.append(comment)
with open(desktop + '\\Comment.xml', 'a+', encoding='utf-8') as new_f:
    for line in comment_list:
        new_f.write(line)

