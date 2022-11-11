import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

EngineStartStop {
    id: stopButton
    text: ""
    mainColor: "Red"
    activeColor: "#b30000"
    enabled: false

    Text {
        id: buttonLabel1

        text: qsTr("Emergency")

        width: parent.width
        color: "White"
        font.pixelSize: Math.min(8,  Math.ceil(width / 9.5))
        font.capitalization: Font.AllUppercase
        fontSizeMode: Text.HorizontalFit
        font.weight: Font.Bold
        anchors.left: parent.left
        anchors.bottomMargin: 70
        anchors.right: parent.right
        anchors.top: buttonLabel2.bottom
        anchors.bottom: parent.bottom
        style: Text.Normal
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: buttonLabel2

        text: qsTr("Stop")

        color: "#ffffff"
        font.pixelSize: 12
        font.weight: Font.Bold
        font.letterSpacing: 1.5
        font.capitalization: Font.AllUppercase
        anchors.bottomMargin: 27
        anchors.leftMargin: 2
        anchors.topMargin: -5
        anchors.fill: parent
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
    }

    onClicked: {
        if (stopButton.active) {
            stopButton.checked = true;
        }
    }

    onActivated: {
        stopButton.active = true;
        stopButton.mainColor = "#b30000";
    }
}
