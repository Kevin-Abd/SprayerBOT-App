import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10
import QtMultimedia 5.12
import PhidgetFeedback 1.0

Item {
    id: phidgetFeedback

    function activate(){
        pInterface.activate()
    }

    function deactivate(){
        pInterface.deactivate()
    }

    PhidgetQml{
        id: pInterface
    }
}
