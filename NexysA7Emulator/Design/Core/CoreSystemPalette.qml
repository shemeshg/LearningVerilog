pragma Singleton

import QtQuick

SystemPalette {
    id: systemPalette

        colorGroup: SystemPalette.Active

        property bool isDarkTheme: Application.styleHints.colorScheme === Qt.ColorScheme.Dark

        property font font: Qt.font({
                                                 "family": Qt.application.font.family,
                                                 "pixelSize": Qt.application.font.pixelSize
                                             })
    }
