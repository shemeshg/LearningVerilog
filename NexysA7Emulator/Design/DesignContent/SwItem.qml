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
    property bool swEnabled: false
    property string name : "SW"
    signal swChanged(bool value)

    CoreLabel {
        text: name
    }
    CoreLabel {
        text: ledEnabled ? "<*>" : "."

    }
    CoreSwitch {
        id: verticalSwitch

        checked: swEnabled

        
        transform: Rotation {            
            angle: 270
            origin.x: verticalSwitch.width / 2
            origin.y: verticalSwitch.height / 2
        }
        
        onToggled:  {
            swItem.swChanged(checked);
        }
    }
}
