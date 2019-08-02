import sys
from PyQt5.QtWidgets import (QApplication, QWidget,
                            QPushButton, QToolTip)
from PyQt5.QtGui import QIcon, QFont


class Example(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        QToolTip.setFont(QFont('SansSerif', 10))
        self.setToolTip('This is a<b>QWidget</b> widget')

        btn = QPushButton('Button', self)
        btn.setToolTip('This is a<b>QWidget</b> widget')
        btn.resize(btn.sizeHint())
        btn.move(50, 50)



        self.setGeometry(300, 300, 300, 200)
        self.setWindowTitle('ToolTips')
        self.setWindowIcon(QIcon('D:\\UserData\\Desktop\\test\\0.PNG'))
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())