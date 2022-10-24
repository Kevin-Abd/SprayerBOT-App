import QtQuick 2.10
import QtMultimedia 5.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    id: root

    readonly property int pr: Screen.devicePixelRatio

    visible: true                                   // Whether the window is visible on the screen.
    minimumWidth: 640                               // Hardcoded minimum window Width
    minimumHeight: 480                              // Hardcoded minimum window Height
    color: "Whitesmoke"
    visibility: "Maximized"                         // Window start Maximized on all platforms
    title: qsTr("SprayerBOT")

    header: ToolBar {
        background: Item {
            id: toolbar

            /* This background item helps keep the ToolBar the same "Whitesmoke"
              color specified for the ApplicationWindow */

            anchors.fill: parent
        }

        RowLayout {
            anchors.fill: parent

            EngineStartStop {
                id: startButton

                Text {
                    id: startText

                    text: qsTr("Start")
                    color: "White"

                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.letterSpacing: 1.5
                    font.capitalization: Font.AllUppercase

                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: {
                    if (startButton.active) {
                        startButton.checked = true;
                    }
                }

                onActivated: {
                    /* Change the active property of the EngineStartStop element
                      to true and the main color property to indicate that the
                      start button is active */
                    startButton.active = true;
                    startButton.mainColor = "#17a81a";

                    // play all the videos
                    videoLayout.play();
                    /* Deactivate emergency stop button by changing the EngineStartStop
                       active and mainColor properties, and the DelayButton checked property.
                       This will be done everytime the stat button is pressed regardless of
                       whether or not the stop button was active prior */
                    stopButton.active = false;
                    stopButton.checked = false;
                    stopButton.mainColor = "Red";

                    graphicalDisplay.coverageMap.active = true           // Activate the map's "navigating" state
                    graphicalDisplay.coverageMap.state = "navigating"

                    //liveValue.startUpdates()          // Start receiving updates from agbotwebserver
                    if (sim.start == false) {
                        sim.start = true                // start simulation
                    }
                    else {
                        sim.pause = false
                        graphicalDisplay.appRate1.value = sim.appRate1
                        graphicalDisplay.appRate2.value = sim.appRate2
                        graphicalDisplay.speed.value = sim.speed
                    }

                    /* Start the mahine with nominal status */
                    notifications.setSpecial("clear")
                }
            }

            EngineStartStop {
                id: stopButton

                //                Layout.topMargin: 5
                //                Layout.leftMargin: -5
                //                Layout.rightMargin: 15
                //                Layout.bottomMargin: 5
                //                Layout.alignment: Qt.AlignRight

                text: ""
                mainColor: "Red"
                activeColor: "#b30000"

                Text {
                    id: buttonLabel1

                    text: qsTr("Emergency")

                    width: parent.width
                    color: "White"
                    font.pixelSize: Math.min(8,  Math.ceil(width / 9.5))
                    font.capitalization: Font.AllUppercase
                    fontSizeMode: Text.HorizontalFit
                    font.weight: Font.Bold
                    anchors.left: parent.left
                    anchors.bottomMargin: 70
                    anchors.right: parent.right
                    anchors.top: buttonLabel2.bottom
                    anchors.bottom: parent.bottom
                    style: Text.Normal
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    id: buttonLabel2

                    text: qsTr("Stop")

                    color: "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    font.letterSpacing: 1.5
                    font.capitalization: Font.AllUppercase
                    anchors.bottomMargin: 27
                    anchors.leftMargin: 2
                    anchors.topMargin: -5
                    anchors.fill: parent
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignHCenter
                }

                onClicked: {
                    if (stopButton.active) {
                        stopButton.checked = true;
                    }
                }

                onActivated: {
                    stopButton.active = true;
                    stopButton.mainColor = "#b30000";

                    videoLayout.pause()

                    startButton.active = false
                    startButton.checked = false
                    startButton.mainColor = "Green";

                    graphicalDisplay.coverageMap.active = false
                    // liveValue.stopUpdates()
                    if (sim.start == true) {
                        sim.pause = true                // pause simulation
                    }

                    notifications.setSpecial("stopped")
                }
            }

            NotificationsBar {
                id: notificationsBar
                anchors.centerIn: parent
                // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            ButtonAlertPerceived{
                id: buttonAlertPerceived

                Component.onCompleted: {
                    buttonAlertPerceived.activated.connect(statusManager.userOverride)
                }
            }
        }
    } // End of ToolBar

    Item {
        id: contentItem

        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            VideoLayout {
                id: videoLayout
            }
            GraphicalDisplay{
                id: graphicalDisplay

                Component.onCompleted: {
                    speed: sim.speed
                    rpm: sim.rpm
                    broomHeight: sim.boomHeight
                    tankLevel1: sim.tankLevel1
                    tankLevel2: sim.tankLevel2
                    appRate1: sim.appRate1
                    appRate2: sim.appRate2
                    broomNozzle1: sim.nozzle1Status
                    broomNozzle2: sim.nozzle2Status
                    broomNozzle3: sim.nozzle3Status
                    broomNozzle4: sim.nozzle4Status
                    broomNozzle5: sim.nozzle5Status
                    broomNozzle6: sim.nozzle6Status
                }
            }
        }
    } // End of contentItem

    AlertSoundEffect {
        id: alertSoundEffect
    }

    PhidgetFeedback {
        id: phidgetFeedback
    }


    QtObject {
        id: notifications

        property var list_instruction: {
            "start":   { code: "001",  message : "To begin, press and hold the START button."},
            "restart": { code: "002",  message : "Press and hold the START button to start the machine"},
            "normal":  { code: "003",  message : "All systems are normal"},

        }


        property NotificationsList list : NotificationsList {

        }


        function setSpecial(mode){
            if (mode === "start")
                list.setSingle(list_instruction["start"].code ,list_instruction["start"].message, "off")
            else if (mode === "stopped")
                list.setSingle(list_instruction["restart"].code, list_instruction["restart"].message, "off")
            else if (mode === "clear")
                list.clear()

            statusManager.checkForNewStatus()
        }


        function addWarning(alert) {
            if (list.index(alert.code) === -1) {
                list.add(alert.code, alert.message, "warning")
                statusManager.checkForNewStatus()
            }
        }

        function removeWarning(alert) {
            var res = list.removeIfpresent(alert.code)
            if (res === true)
                statusManager.checkForNewStatus()
        }

        function getUnprocessed(){
            return list.getUnprocessed()
        }

        function setProccessed(code){
            return list.process(code)
        }

    }

    StatusManager{
        id: statusManager
        alertSoundEffect: alertSoundEffect
        phidgetFeedback: phidgetFeedback
        notificationsBar: notificationsBar
        buttonAlertPerceived: buttonAlertPerceived
    }


    Simulation {
        id: sim

        property var list_alerts: {
            "low speed":  { code: "101",  message : "The machine is moving too slow!"},
            "high speed": { code: "102",  message : "The machine is moving too fast!"},

            "high broom": { code: "111",  message : "The broom height is too high!"},
            "low broom":  { code: "112",  message : "The broom height is too low!"},

            "blocked nozzle 1": { code: "121",  message : "Nozzle 1 is blocked! Please check the sprayer!"},
            "blocked nozzle 2": { code: "122",  message : "Nozzle 2 is blocked! Please check the sprayer!"},
            "blocked nozzle 3": { code: "123",  message : "Nozzle 3 is blocked! Please check the sprayer!"},
            "blocked nozzle 4": { code: "124",  message : "Nozzle 4 is blocked! Please check the sprayer!"},
            "blocked nozzle 5": { code: "125",  message : "Nozzle 5 is blocked! Please check the sprayer!"},
            "blocked nozzle 6": { code: "126",  message : "Nozzle 6 is blocked! Please check the sprayer!"},

            "low tank 1": { code: "131",  message : "Tank 1 level is low! Please refill soon."},
            "low tank 2": { code: "132",  message : "Tank 2 level is low! Please refill soon."},

        }

        onSpeedChanged: {
            graphicalDisplay.speed = speed

            if (speed > 0 && speed <= 3) {
                notifications.addWarning(list_alerts["low speed"])
                notifications.removeWarning(list_alerts["high speed"])
            } else if (speed > 6) {
                notifications.addWarning(list_alerts["high speed"])
                notifications.removeWarning(list_alerts["low speed"])
            } else {
                notifications.removeWarning(list_alerts["low speed"])
                notifications.removeWarning(list_alerts["high speed"])
            }
        }

        onStateChanged: {
            statusManager.updateState(state)
        }

        onRpmChanged: {
            graphicalDisplay.rpm = rpm
        }

        onBoomHeightChanged: {
            graphicalDisplay.broomHeight = boomHeight
            if (boomHeight > 28) {
                notifications.addWarning(list_alerts["high broom"])
                notifications.removeWarning(list_alerts["low broom"])
            } else if (boomHeight < 22) {
                notifications.addWarning(list_alerts["low broom"])
                notifications.removeWarning(list_alerts["high broom"])
            } else {
                notifications.removeWarning(list_alerts["high broom"])
                notifications.removeWarning(list_alerts["low broom"])
            }
        }

        onTankLevel1Changed: {
            graphicalDisplay.tankLevel1 = sim.tankLevel1

            if (sim.tankLevel1 < 6.25)
                notifications.addWarning(list_alerts["low tank 1"])
            else
                notifications.removeWarning(list_alerts["low tank 1"])
        }

        onAppRate1Changed: {
            graphicalDisplay.appRate1 = appRate1
        }

        onTankLevel2Changed: {
            graphicalDisplay.tankLevel2 = sim.tankLevel2

            if (sim.tankLevel2 < 1.25)
                notifications.addWarning(list_alerts["low tank 2"])
            else
                notifications.removeWarning(list_alerts["low tank 2"])
        }

        onAppRate2Changed: {
            graphicalDisplay.appRate2 = appRate2
        }

        onNozzle1StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle1State(nozzle1Status)

            if (nozzle1Status === "blocked")
                notifications.addWarning(list_alerts["blocked nozzle 1"])
            else
                notifications.removeWarning(list_alerts["blocked nozzle 1"])
        }
        onNozzle2StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle2State(nozzle2Status)

            if (nozzle2Status === "blocked")
                notifications.addWarning(list_alerts["blocked nozzle 2"])
            else
                notifications.removeWarning(list_alerts["blocked nozzle 2"])
        }
        onNozzle3StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle3State(nozzle3Status)

            if (nozzle3Status === "blocked")
                notifications.addWarning(list_alerts["blocked nozzle 3"])
            else
                notifications.removeWarning(list_alerts["blocked nozzle 3"])
        }
        onNozzle4StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle4State(nozzle4Status)

            if (nozzle4Status === "blocked")
                notifications.addWarning(list_alerts["blocked nozzle 4"])
            else
                notifications.removeWarning(list_alerts["blocked nozzle 4"])
        }
        onNozzle5StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle5State(nozzle5Status)

            if (nozzle5Status === "blocked")
                notifications.addWarning(list_alerts["blocked nozzle 5"])
            else
                notifications.removeWarning(list_alerts["blocked nozzle 5"])
        }
        onNozzle6StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle6State(nozzle6Status)

            if (nozzle6Status === "blocked")
                notifications.addWarning(list_alerts["blocked nozzle 6"])
            else
                notifications.removeWarning(list_alerts["blocked nozzle 6"])
        }
    }

    Loader {
        source: "Simulation.qml"
        onLoaded: {
            graphicalDisplay.speed = sim.speed
            graphicalDisplay.rpm = sim.rpm
            graphicalDisplay.broomHeight = sim.boomHeight
            graphicalDisplay.tankLevel1 = sim.tankLevel1
            graphicalDisplay.tankLevel2 = sim.tankLevel2
            graphicalDisplay.appRate1 = sim.appRate1
            graphicalDisplay.appRate2 = sim.appRate2
        }
    }

    onClosing: {
        videoLayout.stop()
        sim.start = false
        // liveValue.stopUpdates()
    }
} // End of ApplicationWindow
