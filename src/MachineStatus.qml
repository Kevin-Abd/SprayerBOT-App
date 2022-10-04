import QtQuick 2.9
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Control {
    id: status
    property string text
    property string color

//    implicitHeight: parent.height - 10
//    implicitWidth: (parent.height - 10) * 2


    state: "off"

    states: [
        State {
            name: "off"
            PropertyChanges {target: status; color: "BLACK"}
            PropertyChanges {target: status; text: "OFF"}
        },
        State {
            name: "nominal"
            PropertyChanges {target: status; color: "DarkGreen"}
            PropertyChanges {target: status; text: "OK"}
        },
        State {
            name: "warning"
            PropertyChanges {target: status; color: "goldenrod"}
            PropertyChanges {target: status; text: "ALERT!!!"}
        },
        State {
            name: "error"
            PropertyChanges {target: status; color: "firebrick"}
            PropertyChanges {target: status; text: "ERROR"}
        }
    ]


    contentItem:     Text {
        text: qsTr(parent.text)
        width: parent.width
        color: "White"
        font.pixelSize: 17
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 1.5
        font.weight: Font.Bold
        fontSizeMode: Text.HorizontalFit
        anchors.fill: parent
        style: Text.Normal
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    background : Item {
        id: backgroundContainer
        anchors.fill: parent

        Rectangle {
            id: button
            color: parent.parent.color
            anchors.fill: parent
            radius: height / 2
            border.width: 2
            border.color: "#303030"
            anchors.centerIn: parent
            opacity: enabled ? 1 : 0.3


        }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:100;width:250}
}
##^##*/
