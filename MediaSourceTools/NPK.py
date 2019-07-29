from NkpImgTools import *


class Npk(object):

    def __init__(self, file_path):
        # name  :NPK文件名，从路径中分割
        self.name = file_path.split('\\')[-1]
        self.filePath = file_path
        # header:NPK文件头
        # data1 :表示img数量的四字节二进制文件流
        # data2 :img索引表，列表形式
        # data3 :校验码SHA256
        # data4 :img内容
        [self.header, self.data1, self.data2, self.data3, self.data4, self.img_count] = self._readObj()
        self.imgAnalyse = self._imgAnalyse()

    @property
    def _data2Content(self):
        self.data2Content = b''
        if self.img_count > 0:
            for imgIndexContent in self.data2:
                self.data2Content += imgIndexContent
        return self.data2Content

    @property
    def _dataContents(self):
        self.dataContents = self.header + self.data1 + self._data2Content + self.data3 + self.data4
        return self.dataContents

    def _readObj(self):
        with open(self.filePath, 'rb') as content:
            # 分割npk文件流
            self.header = content.read(16)
            self.data1 = content.read(4)
            self.img_count = bytes2int(self.data1)
            self.data2 = []
            # 如果数量为零，data2为空
            if self.img_count > 0:
                for i in range(self.img_count):
                    self.data2.append(content.read(264))
            self.data3 = content.read(32)
            # data4为img文件内容的列表
            self.data4 = content.read()
        return [self.header, self.data1, self.data2, self.data3, self.data4, self.img_count]

    def _imgAnalyse(self):
        '''
        根据imgIndex索引表内容返回分析的img内容
        :param img_index: img编号，从0开始
        :return:img在data4中的地址偏移量，sizeof(img)，imgName
        '''
        self.imgAnalyse = {}
        for index in range(self.img_count):
            img_index_content = self.data2[index]
            address = img_index_content[:4]
            size = img_index_content[4:8]
            name = encodeName(img_index_content[8:-1])
            self.imgAnalyse[index] = [bytes2int(address), bytes2int(size), name]
        return self.imgAnalyse

    def _saveNpk(self, flagIndex = True):
        self.dataContents = self._dataContents
        if flagIndex:
            with open(self.filePath.replace('.NPK', '-bak.NPK'), 'wb') as newObj:
                newObj.write(self.dataContents)
        else:
            with open(self.filePath, 'wb') as newObj:
                newObj.write(self.dataContents)

    def _listAll(self):
        '''
        列出所有img的序号和名称
        :return:返回一个{序号：名称}的dict
        '''
        indexNames = {}
        for index in range(self.img_count):
            print(index, '\t', self.imgAnalyse[index][2], '\t')
            indexNames[index] = self.imgAnalyse[index][2]
        return indexNames

    def _renameImg(self, renameIndex):
        '''
        重命名img
        :param renameIndex: 重命名img序号
        :return: 修改结果
        '''
        # 判断renameIndex是否存在
        if self.img_count == 0:
            renameIndex = -1
            print('当前NPK文件Img数量为0，无可改名Img')
        else:
            while renameIndex not in range(self.img_count):
                renameIndex = int(input('输入编号错误，请重新输入，如需退出重命名，输入-1'))
                if renameIndex == -1:
                    break
            if renameIndex == -1:
                return False
            else:
                # 先赋值原名
                oldName = self.imgAnalyse[renameIndex][-1]
                print("即将修改：", renameIndex, '\t', oldName)
                newName = input('newName = ')
                newNameBytes = name2Bytes(newName)
                # 更改data2中已修改的img索引内容
                try:
                    self.data2[renameIndex] = self.data2[renameIndex][:8] + newNameBytes
                    self.imgAnalyse[renameIndex][2] = newName
                    self.data3 = self._updateSHA()
                    print(oldName, "——已修改为——", self.imgAnalyse[renameIndex][-1])
                    return True
                except:
                    print(oldName, '——修改失败——')
                    return False

    def _addImg(self, imgObjPath):
        '''
        在NPK文件流 <末尾> 新添加一个img文件
        :param imgObjPath: img path
        :return:
        '''
        with open(imgObjPath,'rb') as imgObj:
            imgContent = imgObj.read()
        # 刷新dataContents
        self.dataContents = self._dataContents
        # 偏移地址，在末尾添加img，前面的内容只有data2中新添加264字节，偏移地址在原NPK总长基础上+264
        imgContentAddress = len(self.dataContents) +264
        bytesAddress = int2Bytes(imgContentAddress)
        # newImg`s size
        size = len(imgContent)
        bytesSize = int2Bytes(size)
        # 获取新添加img文件的名字，一般用路径来分割
        imgName = imgObjPath.split('\\')[-1]
        bytesName = name2Bytes(imgName)
        # 建立新索引目录内容
        newImgIndexContent = bytesAddress + bytesSize + bytesName
        # 在末尾插入一个264字节的新索引，前面的img位置偏移增加264
        for index in range(self.img_count):
            self.data2[index] = int2Bytes(self.imgAnalyse[index][0]+264) + self.data2[index][4:]
        # img数量+1
        self.img_count += 1
        # 重新计算data1
        self.data1 = int2Bytes(self.img_count)
        # 插入新索引内容
        self.data2.append(newImgIndexContent)
        # 直接在NPK末尾增加img文件流
        self.data4 += imgContent
        # 重新校验SHA值
        self.data3 = self._updateSHA()
        # 添加imgAnalyse索引
        self.imgAnalyse[self.img_count-1] = [imgContentAddress, size, imgName]

    def _insertImg(self, imgObjPath, insertIndex):
        pass

    def _replaceImg(self, imgObjPath, replaceImgIndex):
        with open(imgObjPath,'rb') as imgObj:
            imgContent = imgObj.read()
        # 刷新dataContents
        self.dataContents = self._dataContents
        oldSize = self.imgAnalyse[replaceImgIndex][1]
        newSize = len(imgContent)
        offSet = newSize - oldSize
        # 改变替换后的imgIndexContent后面imgIndexContent的位置偏移
        # img索引最大值 = 总数 - 1
        for i in range(replaceImgIndex+1, self.img_count):
            self.data2[i] = int2Bytes(self.imgAnalyse[i][0] + offSet) + self.data2[i][4:]
        # newImg`s size
        bytesSize = int2Bytes(newSize)
        # 新索引内容
        self.data2[replaceImgIndex] = self.data2[replaceImgIndex][:4] + bytesSize + self.data2[replaceImgIndex][8:]
        self._updateSHA()
        # 修改data4内容
        date_3Len = len(self.header + self.data1 + self.data2Content + self.data3)
        address = self.imgAnalyse[replaceImgIndex][0]
        oldImgContentS = address-date_3Len
        self.data4 = self.data4[:oldImgContentS] + imgContent + self.data4[oldImgContentS + oldSize:]

    def _delImg(self, delImgIndex):
        '''
        删除Img
        :param delImgIndex: 删除Img的编号
        :return:是否成功删除
        '''
        if delImgIndex < self.img_count:
            self.dataContents = self._dataContents
            # 获取被删除imgSize
            delSize = self.imgAnalyse[delImgIndex][1]
            # 删除img内容
            date_3Len = len(self.header + self.data1 + self.data2Content + self.data3)
            address = self.imgAnalyse[delImgIndex][0]
            oldImgContentS = address-date_3Len
            self.data4 = self.data4[:oldImgContentS] + self.data4[oldImgContentS + delSize:]
            # img数量 - 1
            self.img_count -= 1
            # 重新计算img数量
            self.data1 = int2Bytes(self.img_count)
            # 删除data2中的索引
            del self.data2[delImgIndex]
            # 所有剩余索引，地址偏移 - 264
            for i in range(self.img_count):
                self.data2[i] = int2Bytes(self.imgAnalyse[i][0] - 264) + self.data2[i][4:]
            # 在被删除索引后所有索引地址偏移 - 删除imgSize
            for i in range(delImgIndex+1, self.img_count):
                self.data2[i] = int2Bytes(self.imgAnalyse[i][0] - delSize) + self.data2[i][4:]
            self.data3 = self._updateSHA()
            # 更新imgAnalyse索引
            del self.imgAnalyse[delImgIndex]
            imgAnalyseValues = self.imgAnalyse.values()
            newKeys = range(self.img_count)
            self.imgAnalyse = dict(zip(newKeys, imgAnalyseValues))

            return True
        else:
            print("输入序号有误，序号的范围应为0 -", self.img_count)
            self._listAll()
            return False

    def _dropImg(self, dropIndex = -1, dropAll = False):
        if dropAll:
            filePath = self._getSavePath()
            self.dataContents = self._dataContents
            for index in range(self.img_count):
                imgNamePath = filePath + self.imgAnalyse[index][-1].split('/')[-1]
                dropImgContent = self._getImgContent(index)
                self._saveImg(dropImgContent, imgNamePath)
            return True
        else:
            if  int(dropIndex) > -1 and int(dropIndex) < self.img_count:
                self.dataContents = self._dataContents
                filePath = self._getSavePath(dropIndex)
                dropImgContent = self._getImgContent(dropIndex)
                imgNamePath = filePath + self.imgAnalyse[dropIndex][-1].split('/')[-1]
                self._saveImg(dropImgContent, imgNamePath)
                print('已提取：' + self.imgAnalyse[dropIndex][-1])
                return True
            else:
                print('输入序号有误，序号范围因为0 - ', self.img_count -1, '内的整数\n', '请重新输入序号，输入 -1 退出')
                reIndex = int(input())
                while reIndex != -1:
                    if self._dropImg(reIndex):
                        break

    def _getImgContent(self, imgIndex):
        dropSize = self.imgAnalyse[imgIndex][1]
        # 提取img内容
        date_3Len = len(self.header + self.data1 + self.data2Content + self.data3)
        address = self.imgAnalyse[imgIndex][0]
        dropImgContentSP = address - date_3Len
        dropImgContent = self.data4[dropImgContentSP:dropImgContentSP + dropSize]
        return dropImgContent

    def _saveImg(self, imgContent, imgNamePath):
        with open(imgNamePath, 'wb') as imgFile:
            imgFile.write(imgContent)

    def _getSavePath(self, imgIndex = 0):
        '''
        获取提取Img的文件夹路径
        :param imgIndex: 提取的img编号，默认为0，方便进行批量提取
        :return: 文件夹路径
        '''
        filePath = ''
        for path in self.filePath.split('\\')[:-1]:
            filePath += path + '\\'
        for path in self.imgAnalyse[imgIndex][-1].replace('/', '\\').split('\\')[:-1]:
            filePath += path + '\\'
        # 文件是否存在，不存在则创建
        isExitPath(filePath)
        return filePath

    def _updateSHA(self):
        '''
        重新计算SHA256值并赋值给self.data3（SHA校验码）
        :return: 新SHA256值
        '''
        return shaDecode(self.header + self.data1 + self._data2Content)


if __name__ == '__main__':
    for file in list_all_files('D:\\UserData\\Desktop\\test'):
        if '.NPK' in file:
            npkObj = Npk(file)
            print(npkObj.name, "Img数量为：", npkObj.img_count)
            # npkObj._renameImg(0)
            # npkObj._delImg(0)
            # npkObj._addImg('D:\\UserData\\Desktop\\test\\testimg.img')
            # npkObj._saveObj()
            # npkObj._listAll()
            npkObj._dropImg(-1, dropAll=False)
            break

