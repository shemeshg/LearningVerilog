
    qt_add_library(DesignContent STATIC)
    qt6_add_qml_module(DesignContent
        URI "DesignContent"
        VERSION 1.0
        RESOURCE_PREFIX "/qt/qml"
        QML_FILES
            App.qml
HeaderComponent.qml
Screen01.qml
SevenSegmenDisplay.qml
SevenSegmentDigit.qml
SwItem.qml
        RESOURCES
            icons/application-exit.png
icons/clear.png
icons/connect.png
icons/disconnect.png
icons/settings.png
        )
    