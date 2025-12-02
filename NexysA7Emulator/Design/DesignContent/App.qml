// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import Design
import Core
import QtQuick.Layouts
import QtCore

Window {
    id: window
    width:  Constants.width
    height: Constants.height
    
    Settings {
        property alias x: window.x
        property alias y: window.y
        property alias width: window.width
        property alias height: window.height
    }

    title: "Nexyx Emulator"
    color: CoreSystemPalette.window
    



    Screen01 {
        id: mainScreen
    }


}

