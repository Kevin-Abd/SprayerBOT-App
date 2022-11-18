import QtQuick 2.10
import QtQuick.Layouts 1.2
import "../UI"


Item {
    id: customToolbar

    property alias startButton: startButton
    property alias stopButton: stopButton
    property alias notificationsBar: notificationsBar
    property alias buttonAlertPerceived1: buttonAlertPerceived1
    property alias buttonAlertPerceived2: buttonAlertPerceived2
    property alias debugText: debugText

    RowLayout {
        anchors.fill: parent
        spacing: 5

        ButtonStart {
            id: startButton
            Layout.leftMargin: 80

        }

        ButtonAlertPerceived{
            id: buttonAlertPerceived1
            Layout.fillWidth: true
        }

        NotificationsBar {
            id: notificationsBar
            Layout.topMargin: 5
            Layout.bottomMargin: 5
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: parent.height * 0.8
            Layout.preferredWidth: parent.width * 0.4

        }

        ButtonAlertPerceived{
            id: buttonAlertPerceived2
            Layout.fillWidth: true
        }


        Text {
            id: debugText

            Layout.preferredHeight: 0
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            text: sim.state
            color: "Black"

            font.pixelSize: 8
            font.weight: Font.Bold
            font.letterSpacing: 1.5
            font.capitalization: Font.AllUppercase

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ButtonStop {
            id: stopButton
            Layout.rightMargin: 60
            Layout.alignment: Qt.AlignRight
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:100;width:1920}
}
##^##*/
