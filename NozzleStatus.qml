import QtQuick 2.0

Item {
    id: nozzleStatus

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.bottom
    state: "off"

    Triangle {
        id: spraying

        opacity: 0
        anchors.fill: parent
        anchors.topMargin: parent.height        // default orientation is bottom edge at the top
    }

    Rectangle {
        id: blocked

        anchors.fill: parent
        color: "Red"
        opacity: 0

        Text {
            text: qsTr("x")
            font.pixelSize: parent.width * 0.7
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset: -1.5
            }
        }
    }

    states: [
        State {
            name: "off"
            PropertyChanges {target: spraying; opacity: 0}
            PropertyChanges {target: blocked; opacity: 0}
        },
        State {
            name: "on"
            PropertyChanges {target: spraying; opacity: 1}
            PropertyChanges {target: blocked; opacity: 0}
        },
        State {
            name: "blocked"
            PropertyChanges {target: blocked; opacity: 1}
            PropertyChanges {target: spraying; opacity: 0}
        }
    ]

    transitions: [
        Transition {
            from: "on"
            to: "blocked"
            PropertyAnimation {target: blocked; properties: opacity; duration: 500;
                easing.type: Easing.InSine}
        },
        Transition {
            from: "blocked"
            to: "on"
            PropertyAnimation {target: spraying; properties: opacity; duration: 500;
                easing.type: Easing.InSine}
        }
    ]

}
