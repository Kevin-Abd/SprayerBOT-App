import QtQuick 2.12
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Styles 1.4

Item {
    id: base

    property real level
    property string name
    property real minValue: 0
    property real maxValue: 5
    property real tickInterval: 1
    property real minorTickInterval: 1

    Gauge {
        id: verticalGauge

        anchors.fill: parent
        value: level
        minimumValue: minValue
        maximumValue: maxValue
        tickmarkStepSize: tickInterval
        minorTickmarkCount: minorTickInterval

        style: GaugeStyle {
            id: gaugeStyle

            property real value: verticalGauge.value

            property real gaugeHeight
            property real gaugeWidth: base.width
            property string mainColor: "blue"
            property string lightColor: "lightblue"

            readonly property string notification: base.name + " level is low! Please refill soon."
            readonly property real needleOffset: ((1.435 * control.height) /
                                                  (control.maximumValue - control.minimumValue))

            onValueChanged: {
                if (value >= (0.45 * control.maximumValue)) {
                    mainColor = "#325125"
                    lightColor = "#a5cd38"
                }
                else if (value >= (0.25 * control.maximumValue) &&
                         value < (0.45 * control.maximumValue)) {
                    mainColor = "#fad201"
                    lightColor = "#FFFFE0"
                }
                else {
                    mainColor = "#d64228"
                    lightColor = "#edb1b1"
                }
            }

            background: Rectangle {
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.00;
                        color: "#919db2";
                    }
                    GradientStop {
                        position: 0.48;
                        color: "#ffffff";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#919db2";
                    }
                }
            }

            valueBar: Rectangle {
                id: valuebar
                implicitWidth: gaugeWidth - 30


                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.00;
                        color: mainColor;
                    }
                    GradientStop {
                        position: 0.5;
                        color: lightColor;
                    }
                    GradientStop {
                        position: 1.00;
                        color: mainColor;
                    }
                }
            }

            tickmark: Item {
                implicitWidth: 15
                implicitHeight: 1

                Rectangle {
                    color: "Black"
                    anchors.fill: parent
                    anchors.leftMargin: 3
                    anchors.rightMargin: 3
                }
            }

            minorTickmark: Item {
                implicitWidth: 10
                implicitHeight: 1

                Rectangle {
                    color: "Black"
                    anchors.fill: parent
                    anchors.leftMargin: 2
                    anchors.rightMargin: 4
                }
            }

            tickmarkLabel: Text {
                id: ticktext
                text: styleData.value
                font.pixelSize: 11
                antialiasing: true
                color: "black"
            }


        }
    }

    Item {
        id: label


        width: parent.width * 0.65
        height: parent.height * 0.375

        anchors {
            bottomMargin: -10
            bottom: verticalGauge.top
            horizontalCenterOffset: 11
            horizontalCenter: parent.horizontalCenter
        }

        Pane {
            anchors.fill: parent
            Material.elevation: 1

            Text {
                id: tankText

                text: level.toFixed(0)
                color: "black"
                topPadding: 5
                font.bold: true
                font.pixelSize: Math.min(12, base.width * 0.2)
                anchors {
                    verticalCenterOffset: -8
                    horizontalCenterOffset: -7.5
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Text {
                id: unitLabel

                text: "gal"
                color: "Black"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                anchors {
                    left: tankText.right
                    bottom: tankText.bottom
                    leftMargin: 3
                }
            }

            Text {
                id: tankName

                text: name
                color: "black"
                bottomPadding: 7.5
                font.pixelSize: 10
                font.letterSpacing: 0.5
                anchors {
                    top: tankText.bottom
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:2;height:90;width:80}
}
##^##*/
