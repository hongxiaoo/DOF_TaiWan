from tool import GetDesktopPath, lst_sort, lst_de_reprocessing

desktop = GetDesktopPath()
lst_paths = []
flag = int(input('''
equ:    1
stk:    2
all:    0
'''))

if flag == 1:
    lst_paths = [desktop + '\\equipment.lst']

elif flag == 2:
    lst_paths = [desktop + '\\stackable.lst']

elif flag == 0:
    lst_paths = [desktop + '\\stackable.lst', desktop + '\\equipment.lst']

print(lst_paths)
if lst_paths:
    lst_de_reprocessing(lst_paths)
    lst_sort(lst_paths)
