
    qt_add_library(Playground STATIC)
    qt6_add_qml_module(Playground
        URI "Playground"
        VERSION 1.0
        RESOURCE_PREFIX "/qt/qml"
        QML_FILES
            PlaygroundComponent.qml
        RESOURCES
            
        )
    