import QtQuick 2.10
import QtQuick.Extras 1.4
import LiveVehicleData 1.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.3

Item {
    id: boomHeightElement

    readonly property real boomHeightValue: verticalGauge.value
    property real val

    function changeNozzle1State(value) {
        nozzle1Status.state = value
    }

    function changeNozzle2State(value) {
        nozzle2Status.state = value
    }

    function changeNozzle3State(value) {
        nozzle3Status.state = value
    }

    function changeNozzle4State(value) {
        nozzle4Status.state = value
    }

    function changeNozzle5State(value) {
        nozzle5Status.state = value
    }

    function changeNozzle6State(value) {
        nozzle6Status.state = value
    }

    implicitWidth: parent.width
    implicitHeight: verticalGauge.height

    Gauge {
        id: verticalGauge

        minimumValue: 20
        maximumValue: 30
        tickmarkStepSize: 5
        minorTickmarkCount: 4
        value: boomHeightElement.val

        style: VerticalGaugeStyle {}

        anchors {
            margins: 10
            centerIn: parent
        }
    }

    Rectangle {
        id: leftBoom

        height: 10
        width: parent.width * 0.375
        border.width: 1

        y: ((verticalGauge.value - verticalGauge.maximumValue)*(verticalGauge.height - 6.543))/
           (verticalGauge.minimumValue - verticalGauge.maximumValue) // linear intepolation w/offset

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }

        anchors {
            right: verticalGauge.left
            rightMargin: 5
        }
    }

    Rectangle {
        id: rightBoom

        width: leftBoom.width
        height: leftBoom.height
        border.width: 1

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }

        anchors {
            leftMargin: 5
            left: verticalGauge.right
            verticalCenter: leftBoom.verticalCenter
        }
    }

    Item {
        id: rightBoomNozzles

        height: rightBoom.height
        width: rightBoom.width

        anchors {
            top: rightBoom.bottom
            horizontalCenter: rightBoom.horizontalCenter
        }

        RowLayout {
            spacing: 5
            anchors.fill: parent

            Nozzle {
                id: nozzle1

                Layout.preferredHeight: parent.height
                Layout.leftMargin: parent.width * 0.1
                Layout.alignment: Qt.AlignLeft

                NozzleStatus {
                    id: nozzle1Status

                    width: rightBoom.width * 0.15
                    height: width
                }
            }

            Nozzle {
                id: nozzle2

                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: nozzle1.width
                Layout.preferredHeight: nozzle1.height
                Layout.leftMargin: -(parent.width * 0.25)

                NozzleStatus {
                    id: nozzle2Status

                    width: rightBoom.width * 0.15
                    height: width
                }
            }

            Nozzle {
                id: nozzle3

                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: nozzle1.width
                Layout.preferredHeight: nozzle1.height

                NozzleStatus {
                    id: nozzle3Status

                    width: rightBoom.width * 0.15
                    height: width
                }
            }
        }
    }

    Item {
        id: leftBoomNozzles

        height: leftBoom.height
        width: leftBoom.width
        anchors.top: leftBoom.bottom
        anchors.horizontalCenter: leftBoom.horizontalCenter

        RowLayout {
            spacing: 15
            anchors.fill: parent

            Nozzle {
                id: nozzle4

                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: parent.width * 0.1

                NozzleStatus {
                    id: nozzle4Status

                    width: leftBoom.width * 0.15
                    height: width
                }
            }

            Nozzle {
                id: nozzle5

                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: nozzle4.width
                Layout.preferredHeight: nozzle4.height
                Layout.leftMargin: parent.width * 0.25

                NozzleStatus {
                    id: nozzle5Status

                    width: leftBoom.width * 0.15
                    height: width
                }
            }

            Nozzle {
                id: nozzle6

                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: nozzle4.width
                Layout.preferredHeight: nozzle4.height

                NozzleStatus {
                    id: nozzle6Status

                    width: leftBoom.width * 0.15
                    height: width
                }
            }
        }
    }
}
