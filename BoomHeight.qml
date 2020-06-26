import QtQuick 2.10
import QtQuick.Extras 1.4
import LiveVehicleData 1.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.3
import "NotificationsManager.js" as NotificationsManager

Item {
    id: boomHeightElement

    readonly property string notification1: "Nozzle 1 is blocked! Please check the sprayer!"
    readonly property string notification2: "Nozzle 2 is blocked! Please check the sprayer!"
    readonly property string notification3: "Nozzle 3 is blocked! Please check the sprayer!"
    readonly property string notification4: "Nozzle 4 is blocked! Please check the sprayer!"
    readonly property string notification5: "Nozzle 5 is blocked! Please check the sprayer!"
    readonly property string notification6: "Nozzle 6 is blocked! Please check the sprayer!"
    readonly property string highHeightWarning: "The boom height is too high!"
    readonly property string lowHeightWarning: "The boom height is too low!"
    readonly property real boomHeightValue: verticalGauge.value
    property real val

    function changeNozzle1State(value) {
        if (value === "blocked") {
            nozzle1Status.state = "blocked"
            if (NotificationsManager.numberOfEntries(notificationsList, notification1) === 0) {
                notificationsList.append({message: notification1, status: "error"})
                NotificationsManager.removeNotification(notificationsList, notificationsList.allClear)
            }

        } else if (value === "on") {
            nozzle1Status.state = "on"
            NotificationsManager.removeNotification(notificationsList, notification1)
        } else {
            nozzle1Status.state = "off"
            NotificationsManager.removeNotification(notificationsList, notification1)
        }
    }

    function changeNozzle2State(value) {
        if (value === "blocked") {
            nozzle2Status.state = "blocked"
            if (NotificationsManager.numberOfEntries(notificationsList, notification2) === 0) {
                notificationsList.append({message: notification2, status: "error"})
                NotificationsManager.removeNotification(notificationsList, notificationsList.allClear)
            }
        } else if (value === "on") {
            nozzle2Status.state = "on"
            NotificationsManager.removeNotification(notificationsList, notification2)
        } else {
            nozzle2Status.state = "off"
            NotificationsManager.removeNotification(notificationsList, notification2)
        }
    }

    function changeNozzle3State(value) {
        if (value === "blocked") {
            nozzle3Status.state = "blocked"
            if (NotificationsManager.numberOfEntries(notificationsList, notification3) === 0) {
                notificationsList.append({message: notification3, status: "error"})
                NotificationsManager.removeNotification(notificationsList, notificationsList.allClear)
            }
        } else if (value === "on") {
            nozzle3Status.state = "on"
            NotificationsManager.removeNotification(notificationsList, notification3)
        } else {
            nozzle3Status.state = "off"
            NotificationsManager.removeNotification(notificationsList, notification3)
        }
    }

    function changeNozzle4State(value) {
        if (value === "blocked") {
            nozzle4Status.state = "blocked"
            if (NotificationsManager.numberOfEntries(notificationsList, notification4) === 0) {
                notificationsList.append({message: notification4, status: "error"})
                NotificationsManager.removeNotification(notificationsList, notificationsList.allClear)
            }
        } else if (value === "on") {
            nozzle4Status.state = "on"
            NotificationsManager.removeNotification(notificationsList, notification4)
        } else {
            nozzle4Status.state = "off"
            NotificationsManager.removeNotification(notificationsList, notification4)
        }
    }

    function changeNozzle5State(value) {
        if (value === "blocked") {
            nozzle5Status.state = "blocked"
            if (NotificationsManager.numberOfEntries(notificationsList, notification5) === 0) {
                notificationsList.append({message: notification5, status: "error"})
                NotificationsManager.removeNotification(notificationsList, notificationsList.allClear)
            }
        } else if (value === "on") {
            nozzle5Status.state = "on"
            NotificationsManager.removeNotification(notificationsList, notification5)
        } else {
            nozzle5Status.state = "off"
            NotificationsManager.removeNotification(notificationsList, notification5)
        }
    }

    function changeNozzle6State(value) {
        if (value === "blocked") {
            nozzle6Status.state = "blocked"
            if (NotificationsManager.numberOfEntries(notificationsList, notification6) === 0) {
                notificationsList.append({message: notification6, status: "error"})
                NotificationsManager.removeNotification(notificationsList, notificationsList.allClear)
            }
        } else if (value === "on") {
            nozzle6Status.state = "on"
            NotificationsManager.removeNotification(notificationsList, notification6)
        } else {
            nozzle6Status.state = "off"
            NotificationsManager.removeNotification(notificationsList, notification6)
        }
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
