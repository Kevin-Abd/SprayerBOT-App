import QtQuick 2.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3
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

        Item {
            id: item1
            Layout.preferredWidth: 0.65 * parent.width
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            RowLayout {
                anchors.fill: parent

                ButtonAlertPerceived{
                    id: buttonAlertPerceived1
                }

                NotificationsBar {
                    id: notificationsBar
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    Layout.bottomMargin: 5
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredHeight: parent.height * 0.8
                }

                ButtonAlertPerceived{
                    id: buttonAlertPerceived2
                }
            }
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
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }


    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:90;width:1000}
}
##^##*/
