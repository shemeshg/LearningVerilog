

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Design
import Core
import Bal
import Playground

ColumnLayout {
    id: screenId
    width: parent.width
    height: parent.height
    Layout.fillWidth: true



    CoreLabel {
        text: Constants.mytype.statusText
    }

    RowLayout {

        SwItem {
            ledEnabled: true
        }
        SwItem {
            Layout.alignment: Qt.AlignHCenter
            ledEnabled: false
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
