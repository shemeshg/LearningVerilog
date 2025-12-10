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
    property string onColor: CoreSystemPalette.isDarkTheme ? "#00ff66" : "#ff2d2d"
    property string offColor : CoreSystemPalette.isDarkTheme ?"#003322" : "#330000"

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
                displayState[7- (index + 1)] = segments
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
