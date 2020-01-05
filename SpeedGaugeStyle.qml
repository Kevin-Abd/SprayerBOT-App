import QtQuick 2.9
import QtQuick.Controls.Styles 1.4

CircularGaugeStyle {
    id: speedGaugeStyle

    property real xCenter: outerRadius
    property real yCenter: outerRadius
    readonly property int speed: control.value
    property real needleTipWidth: outerRadius * 0.02
    property real needleBaseWidth: outerRadius * 0.06
    property real needleLength: outerRadius - tickmarkInset * 0.5

    function degToRad(degrees) {
        return degrees * (Math.PI / 180);
    }

    function paintBackground(ctx) {
        var startAngle = degToRad(minimumValueAngle - 90)

        ctx.beginPath();
        ctx.fillStyle = "whitesmoke";
        ctx.ellipse(0, 0, ctx.canvas.width, ctx.canvas.height);
        ctx.fill();

        ctx.beginPath();
        ctx.strokeStyle = "black";
        ctx.lineWidth = tickmarkInset / 10;
        ctx.arc(xCenter, yCenter, outerRadius - ctx.lineWidth * 10,
                startAngle, degToRad(maximumValueAngle - 90));
        ctx.stroke();

        ctx.beginPath();
        ctx.lineWidth = tickmarkInset / 1.25;
        ctx.strokeStyle = "green";
        ctx.arc(xCenter, yCenter, outerRadius - ctx.lineWidth / 1.5,
                degToRad(valueToAngle(5) - 90), degToRad(valueToAngle(10) - 90));
        ctx.stroke();

        ctx.beginPath();
        ctx.lineWidth = tickmarkInset / 1.25;
        ctx.strokeStyle = "red";
        ctx.arc(xCenter, yCenter, outerRadius - ctx.lineWidth / 1.5,
                degToRad(valueToAngle(0) - 90), degToRad(valueToAngle(5) - 90));
        ctx.stroke();

        ctx.beginPath();
        ctx.lineWidth = tickmarkInset / 1.25;
        ctx.strokeStyle = "red";
        ctx.arc(xCenter, yCenter, outerRadius - ctx.lineWidth / 1.5,
                degToRad(valueToAngle(10) - 90), degToRad(valueToAngle(speedometer.maximumValue) - 90));
        ctx.stroke();
    }

    minorTickmarkInset: tickmarkInset
    tickmarkInset: outerRadius * 0.15
    labelInset: outerRadius * 0.35
    minimumValueAngle: -135
    maximumValueAngle: 135
    minorTickmarkCount: 1
    tickmarkStepSize: 2
    labelStepSize: 2

    tickmark: Rectangle {
        implicitWidth: outerRadius * 0.02
        implicitHeight: outerRadius * 0.07
        color: "black"
        antialiasing: true
    }

    minorTickmark: Rectangle {
        implicitWidth: outerRadius * 0.01
        implicitHeight: outerRadius * 0.03
        antialiasing: true
        color: "black"
    }

    tickmarkLabel: Text {
        text: styleData.value
        font.pixelSize: Math.max(10, outerRadius * 0.2)
        antialiasing: true
        color: "black"
    }

    background: Canvas {
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            paintBackground(ctx);
        }
    }

    needle: Canvas {
        property real xCenter: width / 2
        property real yCenter: height / 2

        implicitWidth: needleBaseWidth
        implicitHeight: needleLength

        onPaint: {
           var ctx = getContext("2d");
           ctx.reset();

           ctx.beginPath();
           ctx.moveTo(xCenter, height);
           ctx.lineTo(xCenter - needleBaseWidth / 2, height - needleBaseWidth / 2);
           ctx.lineTo(xCenter - needleTipWidth / 2, 0);
           ctx.lineTo(xCenter, yCenter - needleLength);
           ctx.lineTo(xCenter, 0);
           ctx.closePath();
           ctx.fillStyle = Qt.rgba(1, 0, 0, 0.66);
           ctx.fill();

           ctx.beginPath();
           ctx.moveTo(xCenter, height)
           ctx.lineTo(width, height - needleBaseWidth / 2);
           ctx.lineTo(xCenter + needleTipWidth / 2, 0);
           ctx.lineTo(xCenter, 0);
           ctx.closePath();
           ctx.fillStyle = Qt.lighter(Qt.rgba(1, 0, 0, 1));
           ctx.fill();
        }
    }

   foreground: Item {
       Rectangle {
           width: outerRadius * 0.75
           height: width
           color: "#F8F8F8"
           radius: width * 0.5
           anchors.centerIn: parent

           Text {
               id: speedText

               text: speed
               color: "black"
               font.bold: true
               anchors.centerIn: parent
               font.pixelSize: outerRadius * 0.5
           }

           Text {
               text: "km/h"
               color: "black"
               anchors.top: parent.bottom
               font.pixelSize: outerRadius * 0.175
               anchors.topMargin: outerRadius * 0.1
               anchors.horizontalCenter: parent.horizontalCenter
           }
       }
   }
}
