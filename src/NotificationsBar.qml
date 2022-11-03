import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Rectangle {
    id: notificationsBar

    /* This element displays notifications about the different elements
       presented on the UI, using both text and */

    property string alert: "Alert Message"

    radius: parent.width * 0.25

    border.width: 1
    border.color: "black"

    Layout.topMargin: 5
    Layout.bottomMargin: 5
    Layout.alignment: Qt.AlignCenter
    Layout.preferredWidth: parent.width * 0.5
    Layout.preferredHeight: parent.height * 0.8

    function setState(message, state){
        alert = message
        statusIndicator1.state = state
        statusIndicator2.state = state
    }

    MachineStatus {
        id: statusIndicator1
        height: parent.height
        width: parent.width * 0.15
        Layout.alignment: Qt.AlignLeft
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    MachineStatus {
        id: statusIndicator2
        height: parent.height
        width: parent.width * 0.15
        Layout.alignment: Qt.AlignRight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: notificationsContainer.right
        anchors.leftMargin: 0
    }

    Item {
        id: notificationsContainer

        height: parent.height * 0.8
        width: parent.width * 0.7
        anchors.left: statusIndicator1.right
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: alertMessage

            text: qsTr(notificationsBar.alert)
            font.pixelSize: Math.max(12, parent.width * 0.0425)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            fontSizeMode: Text.Fit
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:50;width:800}
}
##^##*/
