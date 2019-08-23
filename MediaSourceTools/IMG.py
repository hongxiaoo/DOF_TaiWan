"""
IMG文件操作类模块
"""
import zlib
from PNG import *
empty_v2 = b'Neople Img File\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00'
v2IndexType = [0x10, 0x0f, 0x0e]
v5DDS_Index_Type = [0x12, 0x13, 0x14]
colorSystem = {2: {16: 'ARGB8888', 15: 'ARGB4444', 14: 'ARGB1555'},
               4: {14: 'ABGR8888'},
               5: {14: 'ABGR8888'}, }


class Img:

    def __init__(self):
        # #######通用属性
        # img name
        self.name = ''
        # img 文件头
        self.header = b'Neople Img File\x00'
        # 索引表大小
        self.index_contents_size = 0
        # 保留空间
        self.keep_content = b'\x00\x00\x00\x00'
        # img版本
        self.edition = 0
        # 索引表数量
        self.index_count = 0
        self.index_contents = b''
        # 索引表分割内容
        self.index_contents_split_list = []
        # 索引内容分析
        self.index_content_analyse_contents = {}
        # 图片内容
        self.pic_contents = b''
        # 图片内容分割
        self.pic_contents_split_list = []
        # 导入的img全部数据
        self.import_img_content = b''
        # 一个空的img字节流
        self.empty_img = b''

        # ########V4及以后的属性
        # V4调色板数据
        self.palette_colors = []

    def from_npk(self, img_content):
        self.import_img_content = img_content[3]
        self.name = img_content[2]

    def from_img(self, file_path):
        try:
            with open(file_path, 'rb') as img_file:
                self.import_img_content = img_file.read()
                self.name = file_path.split('\\')[-1]
                return True
        except:
            print('文件读取失败，请检查文件路径与文件是否正确')
            return False

    def read_content(self):
        self.header = self.read_(16)
        # 获取索引表大小
        self.index_contents_size = bytes2int(self.read_(4))
        # 保留内容
        self.keep_content = self.read_(4)
        # 获取img版本
        self.edition = bytes2int(self.read_(4))
        # 获取索引表数量
        self.index_count = bytes2int(self.read_(4))
        # 根据img类型读取img文件内容
        self.img_content_read()

    def img_content_read(self):
        # V4
        if self.edition == 4:
            palette_count = bytes2int(self.read_(4))
            palette = self.read_(4*palette_count)
            self.palette_colors = palette_ana(palette_count, palette)
            # print(self.palette_count)
            # print(self.palette)

        # V5
        if self.edition == 5:
            dds_index_count = bytes2int(self.read_(4))
            img_size = bytes2int(self.read_(4))
            palette_count = bytes2int(self.read_(4))
            palette = self.read_(4*palette_count)
            dds_index_content = self.read_(28 * dds_index_count)

        # V6
        if self.edition == 6:
            # 读取颜色分类
            palette_type_count = bytes2int(self.read_(4))
            palette_types = {}
            for i in range(palette_type_count):
                palette_count = bytes2int(self.read_(4))
                palette = self.read_(4 * palette_count)
                palette_types[i] = [palette_count, palette]

        # V2
        self.index_contents = self.read_(self.index_contents_size)
        # 索引内容分割
        self.index_contents_split_list = self.index_content_split(self.index_contents)
        self.index_content_analyse_contents = self.index_Ana()
        # 剩余字节流为贴图数据
        self.pic_contents = self.read_(-1)
        self.pic_content_split()

        # V4类型调色板的图片像素获取
        if self.edition == 4:
            self.v4_color_pixel()

    # 分割索引内容
    def index_content_split(self, IndexContent):
        """
        用来按序分割v2格式下img文件的索引表项内容
        :param IndexContent: v2格式下img文件的索引表内容
        :return: 返回一个按序排列的索引表项列表
        """
        # 设置判定类型的偏移地址
        typeFlagAddress = 0
        # 如果存在索引数量的话
        if self.index_count:
            # 根据数量来进行一个for循环遍历出imgIndex的内容
            for i in range(self.index_count):
                if IndexContent[typeFlagAddress] == 17:
                    self.index_contents_split_list.append(IndexContent[typeFlagAddress: (8 + typeFlagAddress)])
                    typeFlagAddress += 8
                elif IndexContent[typeFlagAddress] in v2IndexType:
                    self.index_contents_split_list.append(IndexContent[typeFlagAddress: (36 + typeFlagAddress)])
                    typeFlagAddress += 36
                elif IndexContent[typeFlagAddress] in v5DDS_Index_Type:
                    self.index_contents_split_list.append(IndexContent[typeFlagAddress: (64 + typeFlagAddress)])
                    typeFlagAddress += 64
        return self.index_contents_split_list

    # 获取图片内容分析
    def index_Ana(self):
        """
        对v2格式的img文件索引内容进行分析
        :return: 返回一个img索引序号做key，分析内容为值的字典
        """
        global colorSystem
        indexAna = {}
        for i in range(self.index_count):
            indexContent = self.index_contents_split_list[i]
            if len(indexContent) == 8:
                picPoint = indexContent[-4]
                indexAna[i] = picPoint
            elif len(indexContent) == 36:
                # 颜色系统
                color_system = colorSystem[self.edition][bytes2int(indexContent[:4])]
                # 压缩状态
                zlibState = bytes2int(indexContent[4:8])
                # 图像宽
                picWidth = bytes2int(indexContent[8:12])
                # 图像高
                picHeight = bytes2int(indexContent[12:16])
                # picSize 图像大小，所占空间
                picSize = bytes2int(indexContent[16:20])
                # X坐标
                posX = bytes2int(indexContent[20:24])
                # Y坐标
                posY = bytes2int(indexContent[24:28])
                # 帧域宽
                frameWidth = bytes2int(indexContent[28:32])
                # 帧域高
                frameHeight = bytes2int(indexContent[32:-1])
                indexAna[i] = [color_system, zlibState, picWidth, picHeight, picSize,
                               posX, posY, frameWidth, frameHeight]
            # dds特殊索引
            elif len(indexContent) == 64:
                pass
        return indexAna

    # 获取图片内容
    def pic_content_split(self):
        """
        将图片资源分析分割,并加入到对应的PNG分析
        :return:
        """
        # 设定一个index序号和分割到的pic文件流的字典
        # 设定分割起点
        picSplitStartP = 0
        for i in range(self.index_count):
            if type(self.index_content_analyse_contents[i]) == list:
                picSize = self.index_content_analyse_contents[i][4]
                # 分割部分大小为 picSize 分割起点设置为0，并每次分割，增加picSize
                picContent = self.pic_contents[picSplitStartP: picSplitStartP + picSize]
                # 解压缩zlib格式
                if self.index_content_analyse_contents[i][1] == 6:
                    self.index_content_analyse_contents[i].append(zlib.decompress(picContent))
                else:
                    self.index_content_analyse_contents[i].append(picContent)
                picSplitStartP += picSize
            else:
                # 如果不是图片索引则跳过
                continue
        return True

    def v4_color_pixel(self):
        for element in self.index_content_analyse_contents.keys():
            pic_ana = self.index_content_analyse_contents[element]
            if type(pic_ana) == list:
                if pic_ana[2] * pic_ana[3] * 2 == pic_ana[4]:
                    self.index_content_analyse_contents[element][0] = 'ARGB1555'
                    continue
                pixels = []
                replace_flag = True
                for i in pic_ana[-1]:
                    pixels.append(self.palette_colors[i])
                if replace_flag:
                    self.index_content_analyse_contents[element][-1] = pixels

    def save_all_pic(self):
        save_directory = os.path.abspath('.') + '\\' + self.name
        for index in self.index_content_analyse_contents.keys():
            if type(self.index_content_analyse_contents[index]) == list:
                image = Pic(self.index_content_analyse_contents[index])
                is_exit_path(save_directory)
                image.save(save_directory + '\\' + str(index) + '.png')

    def read_(self, int_num=-1):
        if int_num == -1:
            read_content = self.import_img_content[::]
            self.import_img_content = []
        else:
            read_content = self.import_img_content[0:int_num]
            self.import_img_content = self.import_img_content[int_num:]
        return read_content

    def save(self):
        pass

    def switch2_v2(self):
        pass


if __name__ == "__main__":
    a = Img()
    a.from_img('D:\\UserData\\Desktop\\test\\v4.img')
    a.read_content()
    print(a.header, '\n',
          a.index_contents_size, '\n',
          a.keep_content, '\n',
          a.edition, '\n',
          a.index_count, '\n',
          a.palette_colors, '\n',
          a.index_contents, '\n',
          a.pic_contents)
