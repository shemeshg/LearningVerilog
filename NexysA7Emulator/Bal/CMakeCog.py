import ImportScript
from Qt6AddQmlModule import Qt6AddQmlModule

def getCmake():
    m = Qt6AddQmlModule()
    m.hppFolders = ["hpp","prptHpp"]
    m.find_package_qt_components =["SerialPort","Concurrent","Gui"]
    return m.getCmake()

#print(getCmake())
