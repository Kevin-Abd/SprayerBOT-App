import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Controls.Material 2.10

Item {
    id: applicationRateElement

    property real value

    implicitWidth: parent.width * 0.40
    implicitHeight: parent.height * 0.7

    Pane {
        id: applicationRate

        anchors.fill: parent
        Material.elevation: 3

        Text {
            id: valueText

            text: value.toFixed(0)

            color: "Black"
            font.bold: true
            font.pixelSize: Math.max(20, parent.width * 0.25)
            topPadding: 5

            anchors {
                verticalCenterOffset: -10
                horizontalCenterOffset: -10
                leftMargin: unitLabel.width
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }

        Text {
            id: unitLabel

            text: " L/Ha"

            color: "Black"
            font.weight: Font.DemiBold
            font.pixelSize: Math.max(10, parent.width * 0.125)

            anchors {
                left: valueText.right
                bottom: valueText.bottom
                bottomMargin: 3
            }
        }

        Text {
            id: rateLabel

            text: "Application Rate"

            color: "black"
            font.letterSpacing: 1.15
            font.pixelSize: Math.max(7, parent.width * 0.1)
            bottomPadding: 5

            anchors {
                top: valueText.bottom
                topMargin: 5
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
