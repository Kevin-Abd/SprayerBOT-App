import QtQuick 2.12
import QtQuick.Controls.Styles 1.2

GaugeStyle {
    id: gauge

    property real gaugeHeight
    property real gaugeWidth: 10
    property string mainColor: "blue"
    property string lightColor: "lightblue"
    readonly property real needleOffset: ((1.435 * control.height) /
                                          (control.maximumValue - control.minimumValue))

    function paintSide(ctx) {
        // Calculate the longest text
        var longestText = Math.max(ctx.measureText(control.minimumValue.toString()).width,
                                   ctx.measureText(control.maximumValue.toString()).width);

        // starting x position where the tank will be drawn
        var xPos = longestText

        ctx.clearRect(xPos, ((control.maximumValue - control.minimumValue) * needleOffset), 5,
                      ((control.maximumValue - verticalGauge.minimumValue -
                        (verticalGauge.maximumValue / 3)) * needleOffset));
        ctx.fillStyle = "#d64228";
        ctx.fillRect(xPos, ((control.maximumValue - control.minimumValue) * needleOffset), 5,
                     ((control.maximumValue - verticalGauge.minimumValue - (verticalGauge.maximumValue / 3)) *
                      needleOffset));
    }

    background: Rectangle {
        implicitWidth: gaugeWidth
        implicitHeight: gaugeHeight

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.00;
                color: "#919db2";
            }
            GradientStop {
                position: 0.48;
                color: "#ffffff";
            }
            GradientStop {
                position: 1.00;
                color: "#919db2";
            }
        }
    }

    valueBar: Rectangle {
        id: valuebar

        implicitWidth: gaugeWidth
        implicitHeight: gaugeHeight

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.00;
                color: mainColor;
            }
            GradientStop {
                position: 0.5;
                color: lightColor;
            }
            GradientStop {
                position: 1.00;
                color: mainColor;
            }
        }
    }

    tickmark: Item {
        implicitWidth: 15
        implicitHeight: 1

        Rectangle {
            color: "Black"
            anchors {
                fill: parent
                leftMargin: 3
                rightMargin: 3
            }
        }

        Canvas {
            id: side

            anchors.fill: parent

            onPaint: {
                var ctx = side.getContext("2d");
                ctx.reset();
                paintSide(ctx)
            }
        }
    }

    minorTickmark: Item {
        implicitWidth: 10
        implicitHeight: 1

        Rectangle {
            color: "Black"
            anchors {
                fill: parent
                leftMargin: 2
                rightMargin: 4
            }
        }
    }

    tickmarkLabel: Text {
        text: styleData.value
        font.pixelSize: 11
        antialiasing: true
        color: "black"
    }
}
