

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
import QtCore

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

    Connections {
        target: Constants.mytype
        function onLedChanged(led) {
            ledStr = led.toString(2).padStart(16, "0")
        }
    }

    RowLayout {
        CoreButton {
            text: "start"
            onClicked: Constants.mytype.start();
        }
        CoreButton {
            text: "stop"
            onClicked: Constants.mytype.stop();
        }
        CoreLabel {
            text: "simulationSecond: "
        }

        CoreTextField {
            readOnly: true
            text: Constants.mytype.simulationSecond
        }
    }

    CoreLabel {
        text: "Time code: " + Constants.mytype.statusText
    }

    function formatBinStr(s){
        return s + " " +
                parseInt(s, 2) + " lh " +
                parseInt(s.slice(0, 8), 2) + " rh " +
                parseInt(s.slice(8), 2)
    }

    CoreLabel {
        text: "Led str " + formatBinStr(ledStr)
    }

    property string ledStr: "0000000000000000"
    property string swStr: "0000000000000000"
    CoreLabel {
        text: "Sq str " + formatBinStr(swStr)
    }


    RowLayout {

        Repeater {
            model: ledStr.length
            SwItem {
                ledEnabled: Number( ledStr[index])
                swEnabled: false
                name: "SW" + (15 - index)
                onSwChanged: (val)=>{
                                 let arr = swStr.split("");
                                 arr[index] = val ? "1" : "0";
                                 swStr = arr.join("");
                                 writeBtnStatus();
                             }
                onColor: CoreSystemPalette.isDarkTheme ? "#00ff66" : "#ff2d2d"
                offColor : CoreSystemPalette.isDarkTheme ?"#003322" : "#CCCCCC"
            }
        }
    }




    function stringToBoolArray(str) {
        return str.split("").map( (c) => c === "1");
    }

    SevenSegmenDisplay {
        property string onColor: CoreSystemPalette.isDarkTheme ? "#00ff66" : "#ff2d2d"
        property string offColor : CoreSystemPalette.isDarkTheme ?"#003322" : "#CCCCCC"
    }

    function bl2Str(bl){
        return bl ? "1": "0"
    }

    function writeBtnStatus(){
        Constants.mytype.writeBtnStatus(
                    Number(cpuResetn.pressed) ,
                    Number(btnu.pressed) ,
                    Number(btnl.pressed) ,
                    Number(btnc.pressed) ,
                    Number(btnr.pressed) ,
                    Number(btnd.pressed) ,
                    parseInt(swStr, 2)
                    );
    }

    GridLayout {
        columns: 4
        rowSpacing: 8
        columnSpacing: 8

        // Row 0
        CoreButton {
            id:cpuResetn
            text: "CPU_RESETN"
            Layout.row: 0
            Layout.column: 0
            onPressedChanged:   {
                writeBtnStatus();
            }
        }
        CoreButton {
            id: btnu
            text: "BTNU"
            Layout.row: 0
            Layout.column: 2   // directly above BTNC
            onPressedChanged:   {
                writeBtnStatus();
            }
        }

        // Row 1
        CoreButton {
            id: btnl
            text: "BTNL"
            Layout.row: 1
            Layout.column: 1
            onPressedChanged:   {
                writeBtnStatus();
            }
        }
        CoreButton {
            id: btnc
            text: "BTNC"
            Layout.row: 1
            Layout.column: 2
            onPressedChanged:   {
                writeBtnStatus();
            }
        }
        CoreButton {
            id: btnr
            text: "BTNR"
            Layout.row: 1
            Layout.column: 3
            onPressedChanged:   {
                writeBtnStatus();
            }
        }

        // Row 2
        CoreButton {
            id: btnd
            text: "BTND"
            Layout.row: 2
            Layout.column: 2   // centered below BTNC
            onPressedChanged:   {
                writeBtnStatus();
            }
        }
    }

    RowLayout {

        Repeater {
            model: Constants.mytype.rgbLeds
            ColumnLayout {
                CoreLabel {
                    text: "rgb " + index
                }
                Rectangle {
                    width: 20; height: 20
                    color: modelData
                }
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
