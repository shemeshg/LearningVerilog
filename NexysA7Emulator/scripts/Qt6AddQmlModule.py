from CMakeCogLib import CMakeCog
from GenHpp import GenHpp

class Qt6AddQmlModule:
    hppFolders = []
    find_package_qt_components =[]

    def getCmake(self):
        s = []
        cmc = CMakeCog("Bal")


        genHpp = GenHpp(cmc.exeName)
        genHpp.makeDirectories = [f"${{CMAKE_CURRENT_BINARY_DIR}}/{item}" for item in self.hppFolders]
        genHpp.hppGenFilesTemplates = ["${CMAKE_SOURCE_DIR}/scripts/hppTemplates.txt"]
        genHpp.hppGenFilesGlobes = [f"{item}/*.hpp" for item in self.hppFolders]
        genHpp.parseHppPyPath = "${CMAKE_SOURCE_DIR}/scripts/parseHpp.py"


        s.append(genHpp.getStr())

        cmc.find_package_qt_components = self.find_package_qt_components
        if len(self.find_package_qt_components) != 0:
            s.append(cmc.find_package_qt())

        cmc.libFilesExtendCppAndH([''])

        cmc.libFiles.extend(genHpp.getDefineFiles("${CMAKE_CURRENT_BINARY_DIR}/"))
        cmc.targetIncludeDirs += genHpp.makeDirectories 



        s.append(cmc.add_library())
        s.append(cmc.add_qt6_add_qml_module())

        s.append(cmc.target_include_directories())
        s.append(cmc.target_link_libraries())

        s.append(genHpp.add_dependencies())
        return "\n".join(s)