import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Design
import Core
import Bal
import Playground

ColumnLayout {
    id: swItem
    property bool ledEnabled: false
    CoreLabel {
        text: "SW0"
    }
    CoreLabel {
        text: ledEnabled ? "<*>" : "."

    }
    CoreSwitch {
        id: verticalSwitch
        
        transform: Rotation {            
            angle: 270
            origin.x: verticalSwitch.width / 2
            origin.y: verticalSwitch.height / 2
        }
        
        onClicked: {
            ledEnabled = checked;
        }
    }
}
