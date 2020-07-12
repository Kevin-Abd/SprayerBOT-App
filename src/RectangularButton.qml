import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Controls.Styles 1.4

Button {
    id: button

    property string label

    implicitWidth: 72
    implicitHeight: parent.height * 0.60

    background: Rectangle {
        radius: 5
        anchors.fill: button
        border.width: button.hovered ? 2 : 1
        border.color: "#888"
        gradient: Gradient {
            GradientStop { position: 0 ; color: button.pressed ? "#ccc" : "#eee" }
            GradientStop { position: 1 ; color: button.pressed ? "#aaa" : "#ccc" }
        }
    }

    Text {
        id: text

        text: button.label
        color: "black"
        font.pixelSize: Math.min(11, parent.height * 0.25)
        font.capitalization: Font.AllUppercase
        font.weight: Font.DemiBold
        anchors.centerIn: parent
        elide: Text.ElideRight
        width: parent.width
        wrapMode: Text.Wrap
        leftPadding: 10.5
    }
}
