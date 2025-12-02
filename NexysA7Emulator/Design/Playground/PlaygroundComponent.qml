import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Design
import Core
import Bal
import QtCharts



Column  {


    Connections {
        target: Constants.mytype
        function onAddTextToConsole(s) {
            myDummyTextField.text = s;
        }
    }
    ColumnLayout {
        CoreLabel {
            text: "Write whatever you want"
        }
        CoreButton {
            text: "Example"
            Timer {
                id: delayTimer
                interval: 2000  // 2 seconds
                repeat: false
                onTriggered: {
                    // 2 seconds have passed
                    if (Constants.mytype.connStatus === MyType.ConnStatus.CONNECTED) {
                        Constants.mytype.writeKeys("\n")
                    }

                }
            }
            onClicked: {
                if (Constants.mytype.connStatus !== MyType.ConnStatus.CONNECTED) {
                    Constants.mytype.openSerialPort()
                }
                delayTimer.start()


            }
        }
        CoreLabel {
            id: myDummyTextField
            text: "example response you may parse\nPaint a graph or whatever"
        }
        ColumnLayout {
            ChartView {
                width: 400
                height: 300
                theme: ChartView.ChartThemeBrownSand
                antialiasing: true

                ValueAxis {
                    id: axisX
                    min: 0
                    max: 100
                    titleText: "Time (s)"
                }

                ValueAxis {
                    id: axisY
                    min: 0
                    max: 100
                    titleText: "Temperature (°C)"
                }

                LineSeries {
                    id: tempSeries
                    name: "Temperature"
                    axisX: axisX
                    axisY: axisY
                }
            }

            Timer {
                id: updateTimer
                interval: 1000 // 1 second
                running: true
                repeat: true
                onTriggered: {
                    // Simulate incoming temperature from Arduino
                    var temp = Math.random() * 40 + 10 // Replace with actual serial input
                    tempSeries.append(axisX.max, temp)
                    axisX.max += 1
                    if (temp > axisY.max) axisY.max = temp + 5
                }
            }
        }
    }



}

