import sys
import bz2
import struct
import binascii

NPKstr = "NeoplePack_Bill"
password = 'puchikon@neople dungeon and fighterDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNF '
def decompress_spk(path):
    with open(path,  'rb+') as f:
        content = f.read()
        print(content)
        # header = f.read(20)
        #
        # if NPKstr in str(header):
        #     print('This file is a NPK')
        #     img_count = str(header)[24]
        #     for count in range(int(img_count)):
        #         content = f.read(264)
        #         adress = content[:4]
        #         size = content[5:8]
        #         name = content[8:264]
        #         print(name)
        #     jiaoyan = f.read(32)
        # else:
        #     print('This file is not a NPK')
# for i in password:
#     print(ord(i))
decompress_spk('E:\\(去除 驴)sprite_character_common_privatestore_donkey.NPK')
