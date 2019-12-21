import os

def GetDesktopPath():
  return os.path.join(os.path.expanduser("~"), 'Desktop')

desktop = GetDesktopPath()


with open (desktop + '\\equipment.lst') as file:
    list_ = [line.strip() for line in file.readlines()]

    new_order_lst = [ int(element) for element in list_[::2][1:] ]
    new_order_lst.sort()

    new_stk_lst = '#PVF_File' + '\n'
    for element in new_order_lst:
        new_stk_lst += str(element) + '\n' + list_[list_.index(str(element)) + 1] + '\n'

with open (desktop + '\\equipment.lst', 'w') as file:
    file.write(new_stk_lst)