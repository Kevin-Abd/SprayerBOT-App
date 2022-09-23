import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Control {
    id: control

    readonly property string statOkColor: "DarkGreen"
    readonly property string statOkText: "OK"

    readonly property string statAlertColor: "firebrick"
    readonly property string statAlertText: "ALERT!!!"

    property bool ok: true

    property string text: ok ? statOkText: statAlertText
    property string color: ok ? statOkColor: statAlertColor

    Layout.leftMargin: 5
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
            color: control.color

            width: size * 2
            height: size
            radius: 5

            border.width: 2
            border.color: "#303030"
            anchors.centerIn: parent
            opacity: enabled ? 1 : 0.3


        }
    }

    function setStatus(state) {

        if (state === "off" || state === "nominal"){
            control.ok = true
//            console.info(state)
        }
        else if (state === "warning" || state === "error"){
            control.ok = false
//            console.info(state)
        }
        else{
            console.warn(state)
        }
    }

}
