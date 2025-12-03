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

    property var displayState: [
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true],
        [true,  true,  true,  true,  true,  true,  true, true]
    ]
    onAnChanged: {
        an.forEach(function(currentValue, index, array) {
            if(currentValue){
                displayState[7- index] = segments
                displayState = [...displayState]

            }
        });
                 }

    Repeater {
        model: displayState



        SevenSegmentDigit {
            //index
            segmentMap: displayState[7-index]
            onColor: componentId.onColor
            offColor: componentId.offColor
        }

        
    }
    
}
