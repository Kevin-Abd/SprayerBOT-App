import QtQuick 2.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.10

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

        value: level
        anchors.fill: parent
        minimumValue: minValue
        maximumValue: maxValue
        tickmarkStepSize: tickInterval
        minorTickmarkCount: minorTickInterval

        style: VerticalGaugeStyle {
            id: gaugeStyle

            property real value: control.value
            readonly property string notification: base.name + " level is low! Please refill soon."

            gaugeWidth: base.width

            onValueChanged: {
                if (value >= (0.45 * control.maximumValue)) {
                    mainColor = "#325125"
                    lightColor = "#a5cd38"
                    notificationsList.removeWarning(notification)
                }
                else if (value >= (0.25 * control.maximumValue) &&
                         value < (0.45 * control.maximumValue)) {
                    mainColor = "#fad201"
                    lightColor = "#FFFFE0"
                    notificationsList.removeWarning(notification)
                }
                else {
                    mainColor = "#d64228"
                    lightColor = "#edb1b1"
                    notificationsList.addWarning(notification)
                }
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
            horizontalCenterOffset: 22.5
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
