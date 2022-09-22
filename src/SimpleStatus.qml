import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Control {
    id: control

    property bool ok: true                     // Component state
    property string statOkColor: "DarkGreen"   // Status OK color
    property string statAlertColor: "#Red"     // Status Alert color
    property string text: "OK/ALERT"

    Layout.leftMargin: 5
    //    Layout.rightMargin: 35
    padding: 5

    contentItem:     Text {
        text: qsTr(parent.text)
        width: parent.width
        color: "White"

        font.pixelSize: 17
        font.capitalization: Font.AllUppercase
        font.letterSpacing: 1.5
        font.weight: Font.Bold

        fontSizeMode: Text.HorizontalFit

        //        anchors.left: parent.left
        //        anchors.bottomMargin: 70
        //        anchors.right: parent.right
        //        anchors.bottom: parent.bottom
        anchors.fill: parent

        style: Text.Normal
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }


    background : Item {
        id: backgroundContainer

        implicitWidth: Math.min(72, (root.height + 2) / 7.65)
        implicitHeight: Math.min(72, (root.height + 2) / 7.65)

        Rectangle {
            id: button

            readonly property real size: Math.min(backgroundContainer.width - 5,
                                                  backgroundContainer.height - 5)

            width: size * 2
            height: size
            radius: 5

            border.width: 2
            border.color: "#303030"

            anchors.centerIn: parent
            color: control.ok ? control.statOkColor : control.statAlertColor

            opacity: .7


        }
    }
}
