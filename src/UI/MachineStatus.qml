import QtQuick 2.9
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Control {
    id: status
    property string text
    property string textColor
    property string color
    state: "off"
//    implicitHeight: parent.height - 10
//    implicitWidth: (parent.height - 10) * 2



    states: [
        State {
            name: "off"
            PropertyChanges {target: status; text: "OFF"}
            PropertyChanges {target: status; color: "Black"}
            PropertyChanges {target: status; textColor: "White"}
        },
        State {
            name: "nominal"
            PropertyChanges {target: status; text: "OK"}
            PropertyChanges {target: status; color: "White"}
            PropertyChanges {target: status; textColor: "Green"}
        },
        State {
            name: "warning"
            PropertyChanges {target: status; text: "ALERT!!!"}
            PropertyChanges {target: status; color: "Yellow"}
            PropertyChanges {target: status; textColor: "Blue"}
        },
        State {
            name: "blank"
            PropertyChanges {target: status; text: " "}
            PropertyChanges {target: status; color: "Yellow"}
            PropertyChanges {target: status; textColor: "Blue"}
        },
        State {
            name: "error"
            PropertyChanges {target: status; color: "firebrick"}
            PropertyChanges {target: status; text: "ERROR"}
            PropertyChanges {target: status; textColor: "White"}
        }
    ]


    contentItem:     Text {
        id: text1
        text: qsTr(parent.text)
        color: parent.textColor
        font.pixelSize: 45
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 1
        font.weight: Font.Bold
        fontSizeMode: Text.Fit

        anchors.fill: parent
        padding: 0.1 * parent.height
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
