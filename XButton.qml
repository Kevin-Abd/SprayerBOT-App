import QtQuick 2.0
import QtQuick.Controls 2.10

Button {
    id: xButton

    width: Math.max(15, parent.width * 0.1)
    height: Math.max(20, parent.height * 0.2)

    anchors {
        right: parent.right
        top: parent.top
        rightMargin: -2.5
        topMargin: -7.5
    }

    Text {
        text: qsTr("x")
        font.pixelSize: 10
        anchors.centerIn: parent
    }
}
