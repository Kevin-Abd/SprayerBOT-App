import QtQuick 2.12

Rectangle {
    id: nozzleElement

    implicitWidth: height * 0.5
    border.width: 1

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop {
            position: 0.00;
            color: "#404040";
        }
        GradientStop {
            position: 0.48;
            color: "#C0C0C0";
        }
        GradientStop {
            position: 1.00;
            color: "#404040";
        }
    }
}
