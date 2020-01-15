from tool import *
import re

with open(GetDesktopPath() + '\\109500006.equ') as f:
    content = f.read()

new_content = content

abiliti_p = re.compile(r'''\[avatar select ability\].*\[/avatar select ability\]''', re.S)
sub_p = re.compile(r'\t\d{,2}\n\t', re.S)

ability_part_Obj = re.search(abiliti_p, content)
if ability_part_Obj:
    new_content = re.sub(abiliti_p, re.sub(sub_p, '\n\t', ability_part_Obj.group()), content)

with open(GetDesktopPath() + '\\109500006.equ', 'w') as new_f:
    new_f.write(new_content)
