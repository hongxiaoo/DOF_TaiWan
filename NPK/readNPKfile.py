import os
from functools import reduce
import hashlib
class Npk():
    def __init__(self, file_path):
        self.file_path = file_path


def list_of_groups(init_list, children_list_len):
    list_of_groups = zip(*(iter(init_list),) *children_list_len)
    end_list = [list(i) for i in list_of_groups]
    count = len(init_list) % children_list_len
    end_list.append(init_list[-count:]) if count !=0 else end_list
    return end_list


def read_NPK(npk_file):
    NPKcontent = open(npk_file,'rb').read()
    NPKheader = NPKcontent[:20]
    IMGcount = NPKheader[-4]

    data2 = NPKcontent[20:20+264*IMGcount]
    img_files = list_of_groups(data2,264)
    print(IMGcount)
    data3 = NPKcontent[20+264*IMGcount:52+264*IMGcount]

    data3_code = hashlib.sha256(NPKcontent[:17]).hexdigest()
    print(data3_code,len(data3_code))
    print(data3)
    if data3_code == data3:
        print('yes')
    else:
        print('no')
read_NPK('C:\\Users\\tokeika\\Desktop\\装备特效.NPK')

