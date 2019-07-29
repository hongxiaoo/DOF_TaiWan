from NPK import Npk
from IMG import Img
import os


def list_all_files(rootdir):
    _files = []
    list = os.listdir(rootdir) #列出文件夹下所有的目录与文件
    for i in range(0,len(list)):
        path = os.path.join(rootdir,list[i])
        if os.path.isdir(path):
            _files.extend(list_all_files(path))
        if os.path.isfile(path):
            _files.append(path)
    return _files


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





