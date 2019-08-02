'''
IMG内部PNG图片操作类模块
'''
from NkpImgTools import *
from PIL import Image
# 0x10（ARGB8888）
# 0x0F（ARGB4444）
# 0x0E（ARGB1555）


v2ColorSystem = {16: 'ARGB8888', 15: 'ARGB4444', 14: 'ARGB1555'}


class Png(object):

    def _readPng(self):
        pass

    def _pngAna(self, pngAnaContent):
        self.colorSystem = v2ColorSystem[pngAnaContent[0]]
        self.width = pngAnaContent[2]
        self.height = pngAnaContent[3]
        self.decomPicC = pngAnaContent[-1]


    def _saveImgPng(self):
        imgPng = Image.new('RGBA', (self.width, self.height))
        if self.colorSystem == 'ARGB8888':
            k = 0
            for i in range(self.width):
                for j in range(self.height):
                    imgPng.putpixel((i, j), (self.decomPicC[3 + 4 * k], self.decomPicC[2 + 4 * k],
                                           self.decomPicC[1 + 4 * k], self.decomPicC[0 + 4 * k]))
                    k += 1
        imgPng.save('test.png')
        imgPng.show()


if __name__ == '__main__':

    image = Image.open('D:\\UserData\\Desktop\\test\\0.png', 'r')
    # print(image.size, image.format, image.mode)
    # img = Image.new('RGBA', (28, 28))
    # img.show()



