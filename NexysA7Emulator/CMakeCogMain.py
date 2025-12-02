from jinja2 import Environment, FileSystemLoader
import os

template_dict = {"APP_NAME": "Nexys-A7-Emulator",
           "APP_VER": "0.0.1",
           "QT_COMPONENTS": [ "Quick","Widgets"],
           "APP_DESCRIPTION": "Nexys A7 Emulator",
           "APP_VENDOR": "shemeshg",
           "APP_IDENTIFIER": "com.shemeshg.letsgetserial",
           "APP_CONTACT":"https://github.com/shemeshg",
           "QML_DIRS": ["Design","Bal"],
           "MAIN_QML_URI": "mainQml",
           "CPACK_DEBIAN_PACKAGE_DEPENDS": [],
           "add_subdirectory_lib": ["Bal"],
           "add_subdirectory_qt": ["Design/Design",
                      "Design/DesignContent",
                      "Design/Core",
                      "Design/Playground"]
           }

template_dict["add_subdirectory_lib_target"] = [os.path.basename(path) for path in template_dict["add_subdirectory_lib"]]
template_dict["add_subdirectory_qt_target"] = [os.path.basename(path) + "plugin" for path in template_dict["add_subdirectory_qt"]]

environment = Environment(loader=FileSystemLoader("."))
template = environment.get_template("CMakeCogMain.j2")


content = template.render(
    template_dict
)

def getCmake():   
    return content
#print(getCmake())
