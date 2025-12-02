// SevenSegmentDigit.qml
import QtQuick

Item {
    id: root
    property int digit: 0              // 0..9
    property color onColor: "#ff2d2d"  // lit segment color
    property color offColor: "#330000" // unlit segment color
    property int thickness: 4         // segment thickness
    property real cornerRadius: thickness / 2
    property bool anOn: false

    // Aspect: width is ~0.6 of height for standard proportions
    implicitWidth: 30
    implicitHeight: 50

    // Segment enable map for digits 0..9 (A,B,C,D,E,F,G)
    // A=0, B=1, C=2, D=3, E=4, F=5, G=6
    readonly property var segmentMap: [
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

    // Helpers for sizing
    readonly property real w: width
    readonly property real h: height
    readonly property real pad: thickness * 0.6

    // Segment A (top)
    Rectangle {
        id: segA
        width: w - 2 * (pad + thickness)
        height: thickness
        radius: cornerRadius
        color: segmentMap[root.digit][0] ? onColor : offColor
        anchors.top: parent.top
        anchors.topMargin: pad
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Segment B (top-right)
    Rectangle {
        id: segB
        width: thickness
        height: (h - 4 * pad - 3 * thickness) / 2
        radius: cornerRadius
        color: segmentMap[root.digit][1] ? onColor : offColor
        anchors.top: segA.bottom
        anchors.topMargin: pad
        anchors.right: parent.right
        anchors.rightMargin: pad + thickness
    }

    // Segment C (bottom-right)
    Rectangle {
        id: segC
        width: thickness
        height: (h - 4 * pad - 3 * thickness) / 2
        radius: cornerRadius
        color: segmentMap[root.digit][2] ? onColor : offColor
        anchors.top: segG.bottom
        anchors.topMargin: pad
        anchors.right: parent.right
        anchors.rightMargin: pad + thickness
    }

    // Segment D (bottom)
    Rectangle {
        id: segD
        width: w - 2 * (pad + thickness)
        height: thickness
        radius: cornerRadius
        color: segmentMap[root.digit][3] ? onColor : offColor
        anchors.bottom: parent.bottom
        anchors.bottomMargin: pad
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Segment E (bottom-left)
    Rectangle {
        id: segE
        width: thickness
        height: (h - 4 * pad - 3 * thickness) / 2
        radius: cornerRadius
        color: segmentMap[root.digit][4] ? onColor : offColor
        anchors.top: segG.bottom
        anchors.topMargin: pad
        anchors.left: parent.left
        anchors.leftMargin: pad + thickness
    }

    // Segment F (top-left)
    Rectangle {
        id: segF
        width: thickness
        height: (h - 4 * pad - 3 * thickness) / 2
        radius: cornerRadius
        color: segmentMap[root.digit][5] ? onColor : offColor
        anchors.top: segA.bottom
        anchors.topMargin: pad
        anchors.left: parent.left
        anchors.leftMargin: pad + thickness
    }

    // Segment G (middle)
    Rectangle {
        id: segG
        width: w - 2 * (pad + thickness)
        height: thickness
        radius: cornerRadius
        color: segmentMap[root.digit][6] ? onColor : offColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: anDot
        width: thickness
        height: thickness
        radius: width / 2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: thickness * 0.5
        anchors.bottomMargin: thickness * 0.5
        color: root.anOn ? root.onColor : root.offColor
    }
}
