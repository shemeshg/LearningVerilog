import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Design
import Core
import Bal

ColumnLayout {
    id: headerComponentId
    GroupBox {
        visible: loaderId.sourceComponent !== terminalBodyId
        Layout.margins:  CoreSystemPalette.font.pixelSize
        Layout.fillWidth: true
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            CoreButton {
                Layout.leftMargin:   CoreSystemPalette.font.pixelSize /2
                Layout.rightMargin:    CoreSystemPalette.font.pixelSize
                onClicked: {
                    loaderId.sourceComponent = terminalBodyId
                }
                text: "back"
            }
        }
    }
    
    GroupBox {
        visible: loaderId.sourceComponent === terminalBodyId
        Layout.margins:  CoreSystemPalette.font.pixelSize
        Layout.fillWidth: true
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            CoreButton {
                enabled: Constants.mytype.connStatus !== MyType.ConnStatus.CONNECTED
                onClicked: {
                    Constants.mytype.openSerialPort()
                }
                icon.name: "Connect"
                icon.source: Qt.resolvedUrl(
                                 "icons/connect.png")
                hooverText: "Connect to serial port"
                icon.color: undefined
                isIconAnomation: false
                icon.width: CoreSystemPalette.font.pixelSize * 2
                icon.height: CoreSystemPalette.font.pixelSize * 2
            }
            CoreButton {
                enabled: Constants.mytype.connStatus === MyType.ConnStatus.CONNECTED
                onClicked: {
                    Constants.mytype.closeSerialPort()
                }
                icon.name: "Disconnect"
                icon.source: Qt.resolvedUrl(
                                 "icons/disconnect.png")
                hooverText: "Disconnect from serial port"
                icon.color: undefined
                isIconAnomation: false
                icon.width: CoreSystemPalette.font.pixelSize * 2
                icon.height: CoreSystemPalette.font.pixelSize * 2
            }
            CoreButton {
                enabled: Constants.mytype.connStatus !== MyType.ConnStatus.CONNECTED
                onClicked: {
                    loaderId.sourceComponent = terminalSettingsId
                }
                icon.name: "Configure"
                icon.source: Qt.resolvedUrl(
                                 "icons/settings.png")
                hooverText: "Configure serial port"
                icon.color: undefined
                isIconAnomation: false
                icon.width: CoreSystemPalette.font.pixelSize * 2
                icon.height: CoreSystemPalette.font.pixelSize * 2
            }
            CoreButton {
                onClicked: {
                    loaderId.consoleLogStr = "";
                }
                icon.name: "Clear"
                icon.source: Qt.resolvedUrl(
                                 "icons/clear.png")
                hooverText: "Clear data"
                icon.color: undefined
                isIconAnomation: false
                icon.width: CoreSystemPalette.font.pixelSize * 2
                icon.height: CoreSystemPalette.font.pixelSize * 2
            }
            CoreButton {
                onClicked: {
                    Qt.quit()
                }
                icon.name: "Quit"
                icon.source: Qt.resolvedUrl(
                                 "icons/application-exit.png")
                hooverText: "Quit"
                icon.color: undefined
                isIconAnomation: false
                icon.width: CoreSystemPalette.font.pixelSize * 2
                icon.height: CoreSystemPalette.font.pixelSize * 2
            }

            Item {
                Layout.fillWidth: true
            }

            CoreButton {
                text: "🛝"
                font.pointSize: CoreSystemPalette.font.pixelSize * 1.5
                isIconAnomation: false
                hooverText: "Playground (Empty canvas to build your own thing)"
                onClicked: {
                    loaderId.sourceComponent = playgroundId
                }
            }

            
        }
    }
    
}
