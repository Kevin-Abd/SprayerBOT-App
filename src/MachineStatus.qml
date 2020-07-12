import QtQuick 2.9
import QtQuick.Extras 1.4

Item {
    id: status

    state: "off"

    StatusIndicator {
        id: indicator

        anchors.centerIn: parent
    }

    states: [
        State {
            name: "off"
            PropertyChanges {target: indicator; color: "Red"}
            PropertyChanges {target: indicator; active: false}
        },
        State {
            name: "nominal"
            PropertyChanges {target: indicator; color: "Green"}
            PropertyChanges {target: indicator; active: true}
        },
        State {
            name: "warning"
            PropertyChanges {target: indicator; color: "Yellow"}
            PropertyChanges {target: indicator; active: true}
        },
        State {
            name: "error"
            PropertyChanges {target: indicator; color: "Red"}
            PropertyChanges {target: indicator; active: true}
        }
    ]
}
