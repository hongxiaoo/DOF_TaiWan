"""
IMG文件操作类模块
"""
import zlib
from PNG import *

v2IndexType = [0x10, 0x0f, 0x0e]
v5DDS_Index_Type = [0x12, 0x13, 0x14]
colorSystem = {2: {16: 'ARGB8888', 15: 'ARGB4444', 14: 'ARGB1555'},
               4: {14: 'ABGR8888'},
               5: {14: 'ABGR8888'}, }


class Img(object):

    def __init__(self, filePath):
        self.name = filePath.split('\\')[-1]
        self.indexContents = []
        self.filePath = filePath
        self._readImg()

    def _readImg(self):
        with open(self.filePath, 'rb') as imgFile:
            self.header = imgFile.read(16)
            # 获取索引表大小
            self.index_size = bytes2int(imgFile.read(4))
            # 保留内容
            self.keep_content = imgFile.read(4)
            # 获取img版本
            self.edition = bytes2int(imgFile.read(4))
            # 获取索引表数量
            self.index_count = bytes2int(imgFile.read(4))
            # 根据img类型读取img文件内容
            self._img_content_read(imgFile)

    def _img_content_read(self, imgFile):
        # V4
        if self.edition == 4:
            palette_count = bytes2int(imgFile.read(4))
            palette = imgFile.read(4*palette_count)
            self.palette_colors = palette_ana(palette_count, palette)
            # print(self.palette_count)
            # print(self.palette)

        # V5
        if self.edition == 5:
            dds_index_count = bytes2int(imgFile.read(4))
            img_size = bytes2int(imgFile.read(4))
            palette_count = bytes2int(imgFile.read(4))
            palette = imgFile.read(4*palette_count)
            dds_index_content = imgFile.read(28 * dds_index_count)

        # V6
        if self.edition == 6:
            # 读取颜色分类
            palette_type_count = bytes2int(imgFile.read(4))
            palette_types = {}
            for i in range(palette_type_count):
                palette_count = bytes2int(imgFile.read(4))
                palette = imgFile.read(4 * palette_count)
                palette_types[i] = [palette_count, palette]

        # V2

        indexContent = imgFile.read(self.index_size)
        # 索引内容分割
        self.indexContents = self.index_content_split(indexContent)
        self.indexAna = self.index_Ana()
        # 剩余字节流为贴图数据
        self.picContents = imgFile.read()
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
                    self.indexContents.append(IndexContent[typeFlagAddress: (8 + typeFlagAddress)])
                    typeFlagAddress += 8
                elif IndexContent[typeFlagAddress] in v2IndexType:
                    self.indexContents.append(IndexContent[typeFlagAddress: (36 + typeFlagAddress)])
                    typeFlagAddress += 36
                elif IndexContent[typeFlagAddress] in v5DDS_Index_Type:
                    self.indexContents.append(IndexContent[typeFlagAddress: (64 + typeFlagAddress)])
                    typeFlagAddress += 64
        return self.indexContents

    # 获取图片内容分析
    def index_Ana(self):
        """
        对v2格式的img文件索引内容进行分析
        :return: 返回一个img索引序号做key，分析内容为值的字典
        """
        global colorSystem
        indexAna = {}
        for i in range(self.index_count):
            indexContent = self.indexContents[i]
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
            if type(self.indexAna[i]) == list:
                picSize = self.indexAna[i][4]
                # 分割部分大小为 picSize 分割起点设置为0，并每次分割，增加picSize
                picContent = self.picContents[picSplitStartP: picSplitStartP + picSize]
                # 解压缩zlib格式
                if self.indexAna[i][1] == 6:
                    self.indexAna[i].append(zlib.decompress(picContent))
                else:
                    self.indexAna[i].append(picContent)
                picSplitStartP += picSize
            else:
                # 如果不是图片索引则跳过
                continue
        return True

    def v4_color_pixel(self):
        for element in self.indexAna.keys():
            pic_ana = self.indexAna[element]
            if type(pic_ana) == list:
                if pic_ana[2] * pic_ana[3] * 2 == pic_ana[4]:
                    self.indexAna[element][0] = 'ARGB1555'
                    continue
                pixels = []
                replace_flag = True
                for i in pic_ana[-1]:
                    pixels.append(self.palette_colors[i])
                if replace_flag:
                    self.indexAna[element][-1] = pixels


if __name__ == "__main__":
    a = Img('D:\\UserData\\Desktop\\test\\v4.img')
    # print(a.palette_colors)
    save_directory = os.path.abspath('.') + '\\' + a.name
    for index in a.indexAna.keys():
        if type(a.indexAna[index]) == list:
            image = Pic(a.indexAna[index])
            is_exit_path(save_directory)
            image.save(save_directory + '\\' + str(index) + '.png')
