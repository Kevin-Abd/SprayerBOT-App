import QtQuick 2.12
import QtMultimedia 5.9
import QtQuick.Layouts 1.2

Item {
    id: videoplayer

    property string view
    property QtObject source

    Layout.preferredWidth: parent.width
    Layout.fillHeight: true
    state: "before"

    Rectangle {
        id: panel

        width: parent.width
        height: parent.height * 0.12
        color: "Gainsboro"

        Text {
            id: label

            text: qsTr(videoplayer.view)
            color: "#101010"
            padding: 5
            anchors.centerIn: parent
            font.weight: Font.DemiBold
            font.pointSize: Math.max(11, panel.height * 0.6)
        }
    }

    Rectangle {
        id: videoContainer

        width: videoplayer.width
        implicitHeight: videoplayer.height - panel.height
        anchors.top: panel.bottom

        VideoOutput {
            id: videoout

            //fillMode: VideoOutput.Stretch
            anchors.fill: parent
            autoOrientation: true
            source: videoplayer.source
        }
    }

    states: [
        State {
            name: "before"
            PropertyChanges {target: videoContainer; color: "Black" }
        },
        State {
            name: "after"
            PropertyChanges {target: videoContainer; color: "Transparent"}
            PropertyChanges {target: panel; width: videoout.contentRect.width;
                x: videoout.contentRect.x}
        }
    ]

    transitions: [
        Transition {
            from: "before"
            to: "after"
            PropertyAnimation {target: videoContainer; properties: color; duration: 500}
        }
    ]
}
