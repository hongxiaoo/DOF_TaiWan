import hashlib
import os
# img名称按位异或密码
img_name_mask = b"puchikon@neople dungeon and fighter " \
                b"DNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNF" \
                b"DNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNF" \
                b"DNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNF" \
                b"DNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNF" \
                b"DNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNFDNF" \
                b"DNFDNFDNFDNFDNFDNFDNFDNF\x00"


def int2Bytes(intNum):
    '''
    将img数量转化为npk文件中的2进制内容。
    通过10-16进制转换，以0补齐8位，
    补齐后内容择序，倒序进行转换，在bytes.fromhex()方法轻松转化为b''内容
    :param img_count: img数量
    :return: 2进制内容
    '''
    ture_hex_count = hex(intNum)
    hex_count = ture_hex_count[2:]
    while len(hex_count) < 8:
        hex_count = '0' + hex_count
    end_hex_count = ''
    for i in range(4):
        end_hex_count += hex_count[-2 - 2 * i]
        end_hex_count += hex_count[-1 - 2 * i]
    return bytes.fromhex(end_hex_count)


def name2Bytes(img_name):
    '''
    img名字转换对应的二进制流。
    name-ASCII，补齐256位，按位异或，得到的ASCII码再转成16进制字符串
    通过替换与补齐，转换为二进制流
    :param img_name: img名字
    :return: 二进制流
    '''
    name_ascii = img_name.encode('ascii')
    while len(name_ascii) < 256:
        name_ascii += b'\x00'
    content = r''
    for i in range(256):
        hex_str = hex(img_name_mask[i] ^ name_ascii[i]).replace('0x', '')
        while len(hex_str) < 2:
            hex_str = '0'+hex_str
        hex_str = '\\x' + hex_str
        content += hex_str
    content_bytes = eval('b' + '\'' + content + '\'')
    # print(content_bytes)
    return content_bytes


def shaDecode(obj_SHA_Content):
    '''
    对npk文件校验位进行校验
    :param obj_SHA_Content:npk校验位
    :return:校验码的二进制流
    '''
    codeLen = int(len(obj_SHA_Content) / 17) * 17
    shaCodeContent = obj_SHA_Content[:codeLen]
    shaCode = hashlib.sha256(shaCodeContent).hexdigest()
    shaCodeHex = r''
    for i in range(32):
        hex_str = '\\x' + shaCode[2*i:2*i+2]
        shaCodeHex += hex_str
    content_bytes = eval('b' + '\'' + shaCodeHex + '\'')
    # print(content_bytes)
    return content_bytes


def bytes2int(bytes_content):
    '''
    原理是对二进制流倒序成16进制，再转换为10进制
    :param bytes_content: 二进制流内容
    :return: 十进制数值
    '''
    hex_content = ''
    flag = len(bytes_content)
    while flag > 0:
        hex_str = hex(bytes_content[flag - 1]).replace('0x', '')
        while len(hex_str) < 2:
            hex_str = '0' + hex_str
        hex_content += hex_str
        flag -= 1
    int_content = int(hex_content, 16)
    return int_content


def encodeName(name_content):
    while len(name_content) < 256:
        name_content += b'\x00'
    img_name = ''
    for i in range(256):
        # 舍去名称末尾的空格
        if name_content[i] ^ img_name_mask[i] == 0:
            continue
        img_name += chr(name_content[i] ^ img_name_mask[i])
    return img_name


def isExit(filePath):
    if not os.path.exists(filePath):
        os.makedirs(filePath)