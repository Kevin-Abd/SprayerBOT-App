import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Rectangle {
    id: notificationsBar

    /* This element displays notifications about the different elements
       presented on the UI, using both text and */

    property string alert // holds the current notification message on display

    radius: parent.width * 0.25

    border.width: 1
    border.color: "gray"

    Layout.topMargin: 5
    Layout.bottomMargin: 5
    Layout.alignment: Qt.AlignCenter
    Layout.preferredWidth: root.width * 0.6
    Layout.preferredHeight: parent.height * 0.8

    function setState(message, state){
        alert = message
        statusIndicator.state = state
    }

    MachineStatus {
        id: statusIndicator

        /* Uses the StatusIndicator element to display the state of the machine
           and the severity of the notification. */
        height: notificationsBar.height
        width: height * 2.5
        Layout.alignment: Qt.AlignLeft
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Item {
        id: notificationsContainer

        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.left: statusIndicator.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: alertMessage

            text: qsTr(notificationsBar.alert)
            font.pixelSize: Math.max(12, parent.width * 0.0425)
            horizontalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            anchors.centerIn: parent
            anchors.leftMargin: 7.5
            width: parent.width
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.25;height:50;width:600}
}
##^##*/
