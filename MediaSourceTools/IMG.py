'''
IMG文件操作类模块
'''
from NkpImgTools import *
import zlib
from PNG import *

v2IndexType = [bytes2int(b'\x10'), bytes2int(b'\x0f'), bytes2int(b'\x0e')]


class Img(object):

    def __init__(self, filePath):
        self.filePath = filePath
        self._readImg()

    def _readImg(self):
        with open(self.filePath, 'rb') as imgFile:
            self.header = imgFile.read(16)
            # 获取索引表大小
            self.indexSize = bytes2int(imgFile.read(4))
            # 保留内容
            self.unsignedE = imgFile.read(4)
            # 获取img版本
            self.imgEdition = bytes2int(imgFile.read(4))
            # 获取索引表数量
            self.indexCount = bytes2int(imgFile.read(4))
            self._imgEditionReadC(imgFile)

    def _imgEditionReadC(self, imgFile):
        edition = self.imgEdition
        if edition == 2:
            # 版本不同，以下读取内容不同
            indexContent = imgFile.read(self.indexSize)
            self.indexContents = self._v2ImgIndexContentSplit(indexContent)
            self.indexAnas = self._v2ImgPicAnas()
            # 剩余字节流为贴图数据
            self.picContents = imgFile.read()
            self._v2ImgPicContentSplit()
        if edition == 4:
            pass

    # 对于v2格式的img文件的操作方法
    # 分割索引内容
    def _v2ImgIndexContentSplit(self, IndexContent):
        '''
        用来按序分割v2格式下img文件的索引表项内容
        :param IndexContent: v2格式下img文件的索引表内容
        :return: 返回一个按序排列的索引表项列表
        '''
        self.indexContents = []
        # 设置判定类型的偏移地址
        typeFlagAddress = 0
        # 如果存在索引数量的话
        if self.indexCount:
            # 根据数量来进行一个for循环遍历出imgIndex的内容
            for index in range(self.indexCount):
                if IndexContent[typeFlagAddress] == 17:
                    self.indexContents.append(IndexContent[typeFlagAddress: (2 + typeFlagAddress)])
                    typeFlagAddress += 2
                if IndexContent[typeFlagAddress] in v2IndexType:
                    self.indexContents.append(IndexContent[typeFlagAddress: (36 + typeFlagAddress)])
                    typeFlagAddress += 36
        return self.indexContents

    # 获取图片内容分析
    def _v2ImgPicAnas(self):
        '''
        对v2格式的img文件索引内容进行分析
        :return: 返回一个img索引序号做key，分析内容为值的字典
        '''
        indexAnas = {}
        for index in range(self.indexCount):
            indexContent = self.indexContents[index]
            if len(indexContent) == 36:
                # 颜色系统
                colorSystem = bytes2int(indexContent[:4])
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
                indexAnas[index] = [colorSystem, zlibState, picWidth, picHeight, picSize,
                                    posX, posY, frameWidth, frameHeight]
            elif len(indexContent) == 2:
                picPoint = indexContent[-1]
                indexAnas[index] = picPoint
        return indexAnas

    # 获取图片内容
    def _v2ImgPicContentSplit(self):
        '''
        将图片资源分析分割,并加入到对应的PNG分析
        :return:
        '''
        # 设定一个index序号和分割到的pic文件流的字典
        # 设定分割起点
        picSplitStartP = 0
        for index in range(self.indexCount):
            if type(self.indexAnas[index]) == list:
                picSize = self.indexAnas[index][4]
                # 分割部分大小为 picSize 分割起点设置为0，并每次分割，增加picSize
                picContent = self.picContents[picSplitStartP: picSplitStartP + picSize]
                # 解压缩zlib格式
                if self.indexAnas[index][1] == 6:
                    self.indexAnas[index].append(zlib.decompress(picContent))
                else:
                    self.indexAnas[index].append(picContent)
                picSplitStartP += picSize
            else:
                # 如果不是图片索引则跳过
                continue
        return True

    # v4格式img文件的操作方法


if __name__ == "__main__":
    a = Img('D:\\UserData\\Desktop\\test\\v28888.img')
    image = Image.open('D:\\UserData\\Desktop\\test\\0.png', 'r')
    width = a.indexAnas[0][-1][2]
    height = a.indexAnas[0][-1][3]
    print(image.size[0], image.size[1])
    relist = a.indexAnas[0][-1][::-1]
    rgbaPixel = []
    for i in range(int(len(relist) / 4)):
        A = relist[4 * i]
        R = relist[1 + 4 * i]
        G = relist[2 + 4 * i]
        B = relist[3 + 4 * i]
        rgbaPixel.append((R, G, B, A))
    k = 0
    for i in range(image.size[0]):
        for j in range(image.size[1]):
            print('1', k, image.getpixel((i, j)))
            print('2', k, rgbaPixel[k])
            k += 1






