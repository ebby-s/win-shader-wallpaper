import sys, glob, pyglet, shader
from PyQt5 import QtWidgets, QtGui, QtCore, uic
from PyQt5.QtCore import QTimer, Qt
import qtmodern.styles
import qtmodern.windows


def catch_exceptions(t,val,tb):
    QtWidgets.QMessageBox.critical(None,"An exception was raised",
                                   "Exception type: {}\n{}".format(t,val))
    old_hook(t,val,tb)

old_hook = sys.excepthook
sys.excepthook = catch_exceptions


class ShaderGalleryItem(QtWidgets.QToolButton):
    shader_id = None
    sw = None

    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton and self.sw:
            self.sw.change_shader(f'.\\glslsandbox_dump\\source\\{self.shader_id}.glsl')
            print('changing shader to', self.shader_id)
        QtWidgets.QToolButton.mousePressEvent(self, event)# 

class MyWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super(MyWindow, self).__init__()
        uic.loadUi('main.ui', self)
        css = '''
            ShaderGalleryItem:hover {
                border:1px solid palette(highlight);
                border-radius:0px;
                /*background:palette(highlight);*/
            }
            ShaderGalleryItem {
                border-radius:0px;
                /*background-color:transparent;*/
            }
        '''
        # self.setAutoFillBackground(True)
        self.setStyleSheet(css)

        dump_dir = '.\\glslsandbox_dump\\'
        self.list_of_shaders = glob.glob(f'{dump_dir}source\\*.glsl')

        # self.shaderComboBox.addItems([s.split('\\')[-1] for s in self.list_of_shaders])
        # self.shaderComboBox.currentIndexChanged.connect(self.change_shader)
        self.timescaleSlider.valueChanged.connect(self.update_timescale)
        self.updateRateSlider.valueChanged.connect(self.update_update_rate)
        self.setResButton.clicked.connect(self.update_resolution)

        self.mouseCheckBox.stateChanged.connect(self.update_mouse_input)

        self.resWidth.setValidator(QtGui.QIntValidator())
        self.resHeight.setValidator(QtGui.QIntValidator())

        self.forceButton.clicked.connect(self.force_clicked)

        style = pyglet.window.Window.WINDOW_STYLE_BORDERLESS
        self.sw = shader.ShaderWindow(width=960, height=540, config=shader.config, style=style, resizable=False)
        self.timer = QTimer()
        self.timer.timeout.connect(self.pyglet_loop)
        self.timer.start(0)

        self.resWidth.setText(str(self.sw.screen.width))
        self.resHeight.setText(str(self.sw.screen.height))

        self.scrollAreaWidgetContents = QtWidgets.QWidget()

        self.scrollArea = QtWidgets.QScrollArea(self.groupBoxOne)
        self.scrollArea.setWidget(self.scrollAreaWidgetContents)
        self.scrollArea.setWidgetResizable(True)
        # self.galleryContainerLayout = QtWidgets.QHBoxLayout(self)
        self.gridLayout = QtWidgets.QGridLayout(self.scrollAreaWidgetContents)
        # self.galleryContainerLayout.addWidget(self.scrollArea)

        w = 100
        h = 50
        row = 0
        for i, s in enumerate(self.list_of_shaders):
            shader_id = s.split('\\')[-1].split('.')[0]
            button = ShaderGalleryItem()
            button.sw = self.sw
            button.shader_id = shader_id
            button.setFixedSize(w + 4, h + 4)
            button.setIcon(QtGui.QIcon(f'{dump_dir}thumbs\\{shader_id}.png'))
            button.setIconSize(QtCore.QSize(w, h))
            button.setToolButtonStyle(Qt.ToolButtonTextUnderIcon)# 
            button.setText(shader_id)# 

            if i % 3 == 0:
                row += 1
            self.gridLayout.addWidget(button, row, i % 3)

        self.scrollAreaWidgetContents.setSizePolicy(QtWidgets.QSizePolicy.Expanding,
                                                    QtWidgets.QSizePolicy.Expanding)
        #self.scrollAreaWidgetContents.resize(1000, 800)
        #self.scrollAreaWidgetContents.adjustSize()
        #self.gridLayout.setRowMinimumHeight(0, 800)
        self.scrollArea.setFixedHeight(400)
        self.scrollArea.setFixedWidth(360)
        self.groupBoxOne.setAlignment(QtCore.Qt.AlignCenter)
        self.show()# 

    def show_gallery(self):
        self.gallery_window.show()

    def update_mouse_input(self, state):
        print(state)
        if state == 0:
            self.sw.update_mouse_pos = False
        elif state == 2:
            self.sw.update_mouse_pos = True

    def update_resolution(self):
        w, h = int(self.resWidth.text()), int(self.resHeight.text())
        self.sw.set_minimum_size(w, h)
        self.sw.set_size(w, h)

    def force_clicked(self):
        self.sw.set_behind_icons()

    def update_timescale(self, val):
        new_val = val * 0.001
        self.sw.timescale = new_val
        self.timescaleLabel.setText(str(new_val))

    def update_update_rate(self, val):
        self.sw.change_update_rate(val)
        self.updateRateLabel.setText(str(val)+" FPS")

    def change_shader(self, index):
        shader = self.list_of_shaders[index]
        result = self.sw.change_shader(shader)
        self.currentShaderLabel.setText(shader.split('\\')[-1])
        if result:
            self.currentShaderLabel.setStyleSheet("QLabel { color : green; }")
            self.statusbar.showMessage('compiled successfully')
        if not result:
            self.currentShaderLabel.setStyleSheet("QLabel { color : red; }")
            self.statusbar.showMessage('error compiling shader')
            self.sw.change_shader('.\\shader\\glslsandbox\\ShaderError.glsl')
        print(index)

    def pyglet_loop(self):
        pyglet.app.run()

    def closeEvent(self, event):
        pyglet.app.exit()


if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    window = MyWindow()

    # "modern" style
    qtmodern.styles.dark(app)
    mw = qtmodern.windows.ModernWindow(window)
    mw.show()

    # window.show()
    sys.exit(app.exec_())
