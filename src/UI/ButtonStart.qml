import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

EngineStartStop {
    id: startButton

    Text {
        id: startText

        text: qsTr("Start")
        color: "White"

        font.pixelSize: 12
        font.weight: Font.Bold
        font.letterSpacing: 1.5
        font.capitalization: Font.AllUppercase

        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    onClicked: {
        if (startButton.active) {
            startButton.checked = true;
        }
    }

    onActivated: {
        /* Change the active property of the EngineStartStop element
          to true and the main color property to indicate that the
          start button is active */
        startButton.active = true;
        startButton.mainColor = "#17a81a";
    }
}
