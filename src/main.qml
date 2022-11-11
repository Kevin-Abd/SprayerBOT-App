import QtQuick 2.10
import QtMultimedia 5.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3
import "UI"
import "Layouts"

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
        height: 90
        background: Item {
            id: toolbarBg
            /* This background item helps keep the ToolBar the same "Whitesmoke"
              color specified for the ApplicationWindow */
            anchors.fill: parent
        }

        CustomToolbar {
            id: toolbar
            anchors.fill: parent
            startButton.onActivated: {
                // play all the videos
                videoLayout.play();
                /* Deactivate emergency stop button by changing the EngineStartStop
                   active and mainColor properties, and the DelayButton checked property.
                   This will be done everytime the stat button is pressed regardless of
                   whether or not the stop button was active prior */
                // stopButton.active = false;
                // stopButton.checked = false;
                // stopButton.mainColor = "Red";

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

            stopButton.onActivated: {
                toolbar.stopButton.active = true;
                toolbar.stopButton.mainColor = "#b30000";

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

            Component.onCompleted: {
                buttonAlertPerceived1.activated.connect(statusManager.userOverride)
                buttonAlertPerceived2.activated.connect(statusManager.userOverride)
            }

        }

    }

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


    NotificationsList {
        id: notifications
    }

    StatusManager{
        id: statusManager
        alertSoundEffect: alertSoundEffect
        phidgetFeedback: phidgetFeedback
        notificationsBar: toolbar.notificationsBar
        buttonAlertPerceived1: toolbar.buttonAlertPerceived1
        buttonAlertPerceived2: toolbar.buttonAlertPerceived2
    }


    Simulation {
        id: sim

        property var list_tutorial_alerts: {
            "visual" :          { code: "021",  message : "Example Visual Alert"},
            "auditory" :        { code: "022",  message : "Example Auditory Alert"},
            "tactile" :         { code: "023",  message : "Example Tactile Alert"},
            "visual_auditory" : { code: "024",  message : "Example Visual+Auditory Alert"},
            "visual_tactile" :  { code: "025",  message : "Example Visual+Tactile Alert"},
        }

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

            "high rpm": { code: "142",  message : "The engine rpm is too high!"},
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

        onTutorialAlertChanged: {
            if (tutorialAlert === "NA") {
                notifications.removeWarning(list_tutorial_alerts["visual"])
                notifications.removeWarning(list_tutorial_alerts["auditory"])
                notifications.removeWarning(list_tutorial_alerts["tactile"])
                notifications.removeWarning(list_tutorial_alerts["visual_auditory"])
                notifications.removeWarning(list_tutorial_alerts["visual_tactile"])
            } else {
                console.debug("[Debug]", `Tutorial alert: ${tutorialAlert}`)
                notifications.setTutorial(tutorialAlert, list_tutorial_alerts[tutorialAlert])
            }
        }

        onRpmChanged: {
            graphicalDisplay.rpm = rpm
            if (rpm > 6) {
                notifications.addWarning(list_alerts["high rpm"])
            } else {
                notifications.removeWarning(list_alerts["high rpm"])
            }
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

        Component.onCompleted: {
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
