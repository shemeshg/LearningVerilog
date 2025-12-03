

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



    // Segment enable map for digits 0..9 (A,B,C,D,E,F,G, DOT)
    // A=0, B=1, C=2, D=3, E=4, F=5, G=6
    readonly property var segmentNumberMap: [
        // 0: A B C D E F
        [false, false, false, false, false, false, true, true ],
        // 1: B C
        [true,  false, false, true,  true,  true,  true , true],
        // 2: A B D E G
        [false, false, true,  false, false, true,  false, true],
        // 3: A B C D G
        [false, false, false, false, true,  true,  false, true],
        // 4: B C F G
        [true,  false, false, true,  true,  false, false, true],
        // 5: A C D F G
        [false, true,  false, false, true,  false, false, true],
        // 6: A C D E F G
        [false, true,  false, false, false, false, false, true],
        // 7: A B C
        [false, false, false, true,  true,  true,  true, true ],
        // 8: all
        [false, false, false, false, false, false, false, true],
        // 9: A B C D F G
        [false, false, false, false, true,  false, false, true]
    ]


    CoreLabel {
        text: "Time code: " + Constants.mytype.timeStr
    }

    function formatBinStr(s){
        return s + " " +
                      parseInt(s, 2) + " lh " +
                      parseInt(s.slice(0, 8), 2) + " rh " +
                      parseInt(s.slice(8), 2)
    }

    CoreLabel {
        text: "Led str " + formatBinStr(Constants.mytype.ledStr)
    }

    CoreLabel {
        text: "Sq str " + formatBinStr(Constants.mytype.swStr)
    }


    RowLayout {

        Repeater {
            model: Constants.mytype.ledStr.length
            SwItem {
                ledEnabled: Number( Constants.mytype.ledStr[index])
                swEnabled: false
                name: "SW" + (15 - index)
                onSwChanged: (val)=>{                      
                                 let arr = Constants.mytype.swStr.split("");
                                 arr[index] = val ? "1" : "0";
                                 Constants.mytype.swStr = arr.join("");
                                 Constants.mytype.writeSwStatus();
                             }
            }
        }
    }


    /*
    Timer {
        property int i: 0
        id: updateTimer

        interval: 1000 // 1 second
        running: true
        repeat: true
        onTriggered: {
            i++;
            if (i%2){
                ssd.segments = segmentNumberMap[i%10]
                ssd.an = [false, false,false,false,false,false,false,true]
            } else {
                ssd.segments = segmentNumberMap[8]
                ssd.an = [false, false,false,false,false,false,true,false]
            }
        }
    }
    */

    SevenSegmenDisplay {
        id: ssd
    }


    GridLayout {
        columns: 4
        rowSpacing: 8
        columnSpacing: 8

        // Row 0
        CoreButton {
            text: "CPU_RESETN"
            Layout.row: 0
            Layout.column: 0
            onClicked: {
                Constants.mytype.startShalom()
            }
        }
        CoreButton {
            text: "BTNU"
            Layout.row: 0
            Layout.column: 2   // directly above BTNC
        }

        // Row 1
        CoreButton {
            text: "BTNL"
            Layout.row: 1
            Layout.column: 1
        }
        CoreButton {
            text: "BTNC"
            Layout.row: 1
            Layout.column: 2
        }
        CoreButton {
            text: "BTNR"
            Layout.row: 1
            Layout.column: 3
        }

        // Row 2
        CoreButton {
            text: "BTND"
            Layout.row: 2
            Layout.column: 2   // centered below BTNC
        }
    }
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
