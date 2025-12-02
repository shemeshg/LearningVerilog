from string import Template
from typing import List
from pathlib import Path



class SubdirectoryItem:
    folder: str
    exeName: str
    def __init__(self, folder: str, exeName: str = ""):
        if exeName == "":
            exeName = folder 
        self.folder: str = folder
        self.exeName: str = exeName        

class CMakeCog:
    exeName: str
    subdirectoryItem: List[SubdirectoryItem] = []
    libType: str = "STATIC"
    libFiles: List[str] = []
    targetIncludeDirs: List[str] = [] 

    def __init__(self, exeName: str):
        self.exeName: str = exeName

    def libFilesExtendCppAndH(self, path: List[Path]):
        for p in path:
            self.libFilesExtend(p, ['*.h', '*.cpp']) 
        

    
    def libFilesExtend(self, path: Path, exts: List[str]):
        path = Path(path)
        if path.is_dir():
            for ext in exts:
                self.libFiles.extend(sorted(str(p) for p in path.glob(ext)))


    def add_library(self) -> str:
        t: Template = Template("""
add_library(${exeName} ${libType}
  ${libFiles}
)        
                     """)
        libFiles: str = "\n".join(self.libFiles)
        return t.safe_substitute(exeName = self.exeName,
                                 libType = self.libType,
                                 libFiles = libFiles)

    def add_qt6_add_qml_module(self) -> str:
        t: Template = Template( """
qt6_add_qml_module(${exeName}
        URI ${exeName}
        VERSION 1.0
        SOURCES
         )
""")
        return t.safe_substitute(exeName = self.exeName)

    def cmake_minimum_required(self) -> str:
        return """cmake_minimum_required(VERSION 3.14)"""

    def project(self) -> str:
        t: Template = Template("""project(${exeName} LANGUAGES CXX)""")    
        return t.substitute(exeName = self.exeName)
    
    def CMAKE_CXX_STANDARD(self) -> str:
        return """
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
"""

    find_package_qt_components: List[str] = []

    def find_package_qt(self) -> str:
        t: Template = Template("""
find_package(QT NAMES Qt6 Qt5 COMPONENTS ${components} REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${components} REQUIRED)
""")
        return t.safe_substitute(components = " ".join(self.find_package_qt_components))

    def add_subdirectory(self) -> str:
        t: Template = Template("""add_subdirectory(${folder})""")
        return "\n".join([t.substitute(folder=item.folder) for item in self.subdirectoryItem])

    def target_link_libraries(self) -> str:
        libs: List[str] = []        
        t: Template = Template("""target_link_libraries(${exeName} PRIVATE ${libs}) """)        
        libs.extend(['Qt${QT_VERSION_MAJOR}::' + s for s in self.find_package_qt_components])
        libs.extend([itm.exeName for itm in self.subdirectoryItem])
        return t.substitute(exeName = self.exeName, 
                            libs = "\n".join(libs))
    
    def target_compile_definitions(self) -> str:
        t: Template = Template("""target_compile_definitions(${exeName} PRIVATE ${exeNameLib}) """)  
        exeNameLib: str = self.exeName.upper() + "_LIBRARY"
        return t.substitute(exeNameLib = exeNameLib, exeName = self.exeName)
    
    def target_include_directories(self) -> str:
        t: Template = Template("""
target_include_directories(${exeName} PRIVATE ${targetIncludeDirs})                     
        """)
        return t.substitute(exeName = self.exeName,
                            targetIncludeDirs = "\n".join(self.targetIncludeDirs))