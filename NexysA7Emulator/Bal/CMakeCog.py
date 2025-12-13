import ImportScript
from Qt6AddQmlModule import Qt6AddQmlModule
from CMakeCogLib import SubdirectoryItem

def getCmake():
    m = Qt6AddQmlModule()
    m.hppFolders = ["hpp","prptHpp"]
    m.find_package_qt_components =["Concurrent","Gui"]
    m.subdirectoryItem = [SubdirectoryItem("HdlLib")]
    return m.getCmake()

#print(getCmake())
