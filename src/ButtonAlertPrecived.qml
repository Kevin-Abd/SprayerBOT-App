import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

DelayButton {
    id: control

    property bool active: false                 // button state
    property int pressCounter: 0                // number of times the button is pressed
    property string mainColor: "darkgoldenrod"  // button when deactivated
    property string activeColor: "goldenrod"    // button color when activated

    delay: 500                                  // 350 ms
    Layout.leftMargin: 10

    text: ""                            // Clears the default text

    Text {
        id: buttonLabel1

        text: qsTr("Alert Precived")
        wrapMode: Text.WordWrap

        style: Text.Normal
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        width: parent.width
        color: "White"
        font.pixelSize: 11
        font.capitalization: Font.AllUppercase
        fontSizeMode: Text.HorizontalFit
        font.weight: Font.Bold
    }



    background: Item {
        id: backgroundContainer

        implicitWidth: Math.min(72, (root.height + 2) / 7.65)
        implicitHeight: Math.min(72, (root.height + 2) / 7.65)

        Rectangle {
            id: button

            readonly property real size: Math.min(backgroundContainer.width - 5,
                                                  backgroundContainer.height - 5)
            width: size
            height: size

            border.width: 1
            radius: size / 2
            border.color: "#606060"
            anchors.centerIn: parent
            opacity: enabled ? 1 : 0.3
            color: control.down ? control.activeColor : control.mainColor
        }
    }

    // draws a black line around the button as it's loading
    Canvas {
        id: canvas

        anchors.fill: backgroundContainer

        Connections {
            target: control
            onProgressChanged: canvas.requestPaint()
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "Black"
            ctx.lineWidth = 4
            ctx.beginPath()
            var startAngle = Math.PI / 5 * 7
            var endAngle = startAngle + control.progress * Math.PI / 5 * 10
            ctx.arc(width / 2, height / 2, width / 2  - ctx.lineWidth / 2 - 1, startAngle, endAngle)
            ctx.stroke()
        }
    }
}
