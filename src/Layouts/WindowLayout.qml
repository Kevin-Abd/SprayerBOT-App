import QtQuick 2.10
import QtMultimedia 5.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3

ColumnLayout{
    RowLayout {
        id: toolbar



    }

    RowLayout {
        id: rowLayout
        width: 100
        height: 100

        Image {
            id: image
            width: 100
            height: 100
            source: "qrc:/qtquickplugin/images/template_image.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image1
            width: 100
            height: 100
            source: "qrc:/qtquickplugin/images/template_image.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image2
            width: 100
            height: 100
            source: "qrc:/qtquickplugin/images/template_image.png"
            fillMode: Image.PreserveAspectFit
        }
    }

    RowLayout {
        id: rowLayout1
        width: 100
        height: 100
    }
}
