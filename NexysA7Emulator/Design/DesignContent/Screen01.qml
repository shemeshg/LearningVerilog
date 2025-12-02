

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
        [true,  true,  true,  true,  true,  true,  false],
        // 1: B C
        [false, true,  true,  false, false, false, false],
        // 2: A B D E G
        [true,  true,  false, true,  true,  false, true ],
        // 3: A B C D G
        [true,  true,  true,  true,  false, false, true ],
        // 4: B C F G
        [false, true,  true,  false, false, true,  true ],
        // 5: A C D F G
        [true,  false, true,  true,  false, true,  true ],
        // 6: A C D E F G
        [true,  false, true,  true,  true,  true,  true ],
        // 7: A B C
        [true,  true,  true,  false, false, false, false],
        // 8: all
        [true,  true,  true,  true,  true,  true,  true ],
        // 9: A B C D F G
        [true,  true,  true,  true,  false, true,  true ]
    ]

    CoreLabel {
        text: Constants.mytype.statusText
    }

    RowLayout {

        Repeater {
            model: 16
            SwItem {
                ledEnabled: false
                swEnabled: false
                name: "SW" + (15 - index)
                onSwChanged: (val)=>{
                                 ledEnabled = val
                                 console.log(name + " " + val)
                             }
            }
        }
    }

    RowLayout {
        Repeater {
            model: 8
            SevenSegmentDigit {


                segmentMap: segmentNumberMap[7 - index]
                //onColor: "#00ff66"
                //offColor: "#003322"

            }
        }

    }
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
