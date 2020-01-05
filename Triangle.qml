import QtQuick 2.10
import QtQuick.Shapes 1.12

Shape {
    id: triangle

    anchors.fill: parent

    ShapePath {
        fillColor: "Green"
        startX: 0; startY: 0
        PathLine { x: 0; y: 0 }
        PathLine { x: parent.width; y: 0 }
        PathLine { x: (parent.width / 2); y: -parent.height }
    }
}
