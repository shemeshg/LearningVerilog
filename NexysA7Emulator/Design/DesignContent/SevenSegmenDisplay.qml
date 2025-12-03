import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Design
import Core
import Bal
import Playground

RowLayout {
    id: componentId
    property var an: [false, false,false,false,false,false,false,false]
    property var segments: [false,  false,  false,  false,  false,  false,  false]
    property string onColor: "#00ff66"
    property string offColor : "#003322"
    Repeater {
        model: 8
        SevenSegmentDigit {
            //index
            segmentMap: an[index] ? segments :
                                    [true,  true,  true,  true,  true,  true,  true, true]
            onColor: componentId.onColor
            offColor: componentId.offColor
        }
        
    }
    
}
