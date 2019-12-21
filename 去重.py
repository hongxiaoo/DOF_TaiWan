import os
from tool import laf, GetDesktopPath

desktop = GetDesktopPath()

try:
    with open (desktop + '\\stackable.lst') as file:
        list_ = [line.strip() for line in file.readlines()]
    codes = list_[::2]
    # print codes[1:]
    new_codes = list(set(codes[1:]))
    content = '#PVF_File\n'
    for code in new_codes:
        content += code +' \n' + list_[list_.index(code) + 1] + '\n'
    with open (desktop + '\\stackable.lst', 'w+') as new_file:
        new_file.write(content)
except:
    print 'error'

try:
    with open(desktop + '\\equipment.lst') as file:
        list_ = [line.strip() for line in file.readlines()]
    codes = list_[::2]
    # print codes[1:]
    new_codes = list(set(codes[1:]))
    content = '#PVF_File\n'
    for code in new_codes:
        content += code + ' \n' + list_[list_.index(code) + 1] + '\n'
    with open(desktop + '\\equipment.lst', 'w+') as new_file:
        new_file.write(content)
except:
    print 'error'
