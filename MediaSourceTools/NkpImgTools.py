# coding=utf-8
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


def is_exit_path(path):
    if not os.path.exists(path):
        os.makedirs(path)


def list_all_files(root_dir):
    _files = []
    _list = os.listdir(root_dir)  # 列出文件夹下所有的目录与文件
    for i in range(0, len(_list)):
        path = os.path.join(root_dir, _list[i])
        if os.path.isdir(path):
            _files.extend(list_all_files(path))
        if os.path.isfile(path):
            _files.append(path)
    return _files


def int2Bytes(int_num):
    """
    将img数量转化为npk文件中的2进制内容。
    通过10-16进制转换，以0补齐8位，
    补齐后内容择序，倒序进行转换，在bytes.fromhex()方法轻松转化为b''内容
    :param int_num:
    :return: 2进制内容
    """
    true_hex_count = hex(int_num)
    hex_count = true_hex_count[2:]
    while len(hex_count) < 8:
        hex_count = '0' + hex_count
    end_hex_count = ''
    for i in range(4):
        end_hex_count += hex_count[-2 - 2 * i]
        end_hex_count += hex_count[-1 - 2 * i]
    return bytes.fromhex(end_hex_count)


def bytes2int(bytes_content):
    """
    原理是对二进制流倒序成16进制，再转换为10进制
    :param bytes_content: 二进制流内容
    :return: 十进制数值
    """
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


def name2Bytes(img_name):
    """
    img名字转换对应的二进制流。
    name-ASCII，补齐256位，按位异或，得到的ASCII码再转成16进制字符串
    通过替换与补齐，转换为二进制流
    :param img_name: img名字
    :return: 二进制流
    """
    name_ascii = img_name.encode('ascii')
    while len(name_ascii) < 256:
        name_ascii += b'\x00'
    content = r''
    for i in range(256):
        hex_str = hex(img_name_mask[i] ^ name_ascii[i]).replace('0x', '')
        while len(hex_str) < 2:
            hex_str = '0' + hex_str
        hex_str = '\\x' + hex_str
        content += hex_str
    content_bytes = eval('b' + '\'' + content + '\'')
    # print(content_bytes)
    return content_bytes


def bytes2Name(name_content):
    while len(name_content) < 256:
        name_content += b'\x00'
    img_name = ''
    for i in range(256):
        # 舍去名称末尾的空格
        if name_content[i] ^ img_name_mask[i] == 0:
            continue
        img_name += chr(name_content[i] ^ img_name_mask[i])
    return img_name


def shaDecode(obj_SHA_Content):
    """
    对npk文件校验位进行校验
    :param obj_SHA_Content:npk校验位
    :return:校验码的二进制流
    """
    codeLen = int(len(obj_SHA_Content) / 17) * 17
    shaCodeContent = obj_SHA_Content[:codeLen]
    shaCode = hashlib.sha256(shaCodeContent).hexdigest()
    shaCodeHex = r''
    for i in range(32):
        hex_str = '\\x' + shaCode[2 * i:2 * i + 2]
        shaCodeHex += hex_str
    content_bytes = eval('b' + '\'' + shaCodeHex + '\'')
    # print(content_bytes)
    return content_bytes


def argb8888(pic_content):
    pixels = []
    for i in range(int(len(pic_content) / 4)):
        pixel = pic_content[4 * i: 4 + 4 * i]
        cloA = (bytes2int(pixel) & 0xff000000) >> 24
        cloR = (bytes2int(pixel) & 0x00ff0000) >> 16
        cloG = (bytes2int(pixel) & 0x0000ff00) >> 8
        cloB = (bytes2int(pixel) & 0x000000ff) >> 0
        pixels.append((cloR, cloG, cloB, cloA))
    return pixels


def argb4444(pic_content):
    pixels = []
    for i in range(int(len(pic_content) / 2)):
        pixel = pic_content[2 * i: 2 + 2 * i]
        # print(pixel)
        cloA = ((bytes2int(pixel) & 0xf000) >> 12) * 0x11
        cloR = (bytes2int(pixel) & 0x0f00) >> 8 << 4
        cloG = (bytes2int(pixel) & 0x00f0) >> 4 << 4
        cloB = (bytes2int(pixel) & 0x000f) >> 0 << 4
        pixels.append((cloR, cloG, cloB, cloA))
    return pixels


def argb1555(pic_content):
    pixels = []
    for i in range(int(len(pic_content) / 2)):
        pixel = pic_content[2 * i: 2 + 2 * i]
        cloA = ((bytes2int(pixel) & 0x8000) >> 15) * 0xff
        cloR = (bytes2int(pixel) & 0x7c00) >> 10 << 3
        cloG = (bytes2int(pixel) & 0x03e0) >> 5 << 3
        cloB = (bytes2int(pixel) & 0x001f) >> 0 << 3
        pixels.append((cloR, cloG, cloB, cloA))
    return pixels


# v4以后的调色表解析
def palette_ana(palette_count, palette):
    colors = []
    for index in range(palette_count):
        color_data = bytes2int(palette[4 * index: 4 + 4 * index])
        colA = (color_data & 0xff000000) >> 24
        colR = (color_data & 0x000000ff) >> 0
        colG = (color_data & 0x0000ff00) >> 8
        colB = (color_data & 0x00ff0000) >> 16
        colors.append((colR, colG, colB, colA))
    return colors
