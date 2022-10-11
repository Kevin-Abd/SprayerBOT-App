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
                    leftPlayer.play();
                    frontPlayer.play();
                    rightPlayer.play();

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

                    leftPlayer.pause();
                    frontPlayer.pause();
                    rightPlayer.pause();

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

            Item {
                id: videos

                Layout.preferredWidth: parent.width /3
                Layout.preferredHeight: parent.height * 0.35

                RowLayout {
                    spacing: 7
                    anchors.fill: parent


                    VideoPlayer {
                        id: video1

                        source: leftPlayer          // allows for the creation of multiple videos
                        view: "Left Boom"           // video label

                        MediaPlayer {
                            id: leftPlayer

                            source: "../media/left.mp4"
                            loops: MediaPlayer.Infinite
                            onPlaybackStateChanged: video1.state = "after"
                        }
                    }

                    VideoPlayer {
                        id: video2

                        source: frontPlayer
                        view: "Front View"

                        MediaPlayer {
                            id: frontPlayer

                            source: "../media/front.mp4"
                            loops: MediaPlayer.Infinite
                            onPlaybackStateChanged: video2.state = "after"
                        }
                    }

                    VideoPlayer {
                        id: video3

                        source: rightPlayer
                        view: "Right Boom"

                        MediaPlayer {
                            id: rightPlayer

                            source: "../media/right.mp4"
                            loops: MediaPlayer.Infinite
                            onPlaybackStateChanged: video3.state = "after"
                        }
                    }
                }
            } // End of videos
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

        readonly property string startupInstruction: "To begin, press and hold the START button."
        readonly property string restarInstruction: "Press and hold the START button to start the machine"
        readonly property string allClearMessage: "All systems are normal"

        property NotificationsList list : NotificationsList {

        }


        function setSpecial(mode){
            if (mode === "start") list.setSingle(startupInstruction, "off")
            else if (mode === "stopped") list.setSingle(restarInstruction, "off")
            else if (mode === "clear") list.clear()

            statusManager.checkForNewStatus()
        }


        function addWarning(message) {
            if (list.index(message) === -1) {
                list.add(message, "warning")
                statusManager.checkForNewStatus()
            }
        }

        function removeWarning(message) {
            var res = list.removeIfpresent(message)
            if (res === true)
                statusManager.checkForNewStatus()
        }

        function getUnprocessed(){
            return list.getUnprocessed()
        }

        function setProccessed(message){
            return list.process(message)
        }

    }

    StatusManager{
        id: statusManager
        alertSoundEffect: alertSoundEffect
        phidgetFeedback: phidgetFeedback
        notificationsBar: notificationsBar
        buttonAlertPerceived: buttonAlertPerceived
    }


    Timer {
        id: timer

        triggeredOnStart: true
        interval: 5000
        running: true
        repeat: true

        onTriggered: {
            // statusManager.checkForNewStatus()
        }
    }

    Simulation {
        id: sim

        readonly property string notification1: "Nozzle 1 is blocked! Please check the sprayer!"
        readonly property string notification2: "Nozzle 2 is blocked! Please check the sprayer!"
        readonly property string notification3: "Nozzle 3 is blocked! Please check the sprayer!"
        readonly property string notification4: "Nozzle 4 is blocked! Please check the sprayer!"
        readonly property string notification5: "Nozzle 5 is blocked! Please check the sprayer!"
        readonly property string notification6: "Nozzle 6 is blocked! Please check the sprayer!"
        readonly property string highHeightWarning: "The boom height is too high!"
        readonly property string lowHeightWarning: "The boom height is too low!"

        readonly property string highSpeedWarning: "The machine is moving too fast!"
        readonly property string lowSpeedWarning: "The machine is moving too slow!"

        onSpeedChanged: {
            graphicalDisplay.speed = speed

            if (speed > 0 && speed <= 3) {
                notifications.addWarning(lowSpeedWarning)
                notifications.removeWarning(highSpeedWarning)
            } else if (speed > 6) {
                notifications.addWarning(highSpeedWarning)
                notifications.removeWarning(lowSpeedWarning)
            } else {
                notifications.removeWarning(lowSpeedWarning)
                notifications.removeWarning(highSpeedWarning)
            }
        }

        onRpmChanged: {
            graphicalDisplay.rpm = rpm
        }

        onBoomHeightChanged: {
            graphicalDisplay.broomHeight = boomHeight
            if (boomHeight > 28) {
                notifications.addWarning(highHeightWarning)
                notifications.removeWarning(lowHeightWarning)
            } else if (boomHeight < 22) {
                notifications.addWarning(lowHeightWarning)
                notifications.removeWarning(highHeightWarning)
            } else {
                notifications.removeWarning(highHeightWarning)
                notifications.removeWarning(lowHeightWarning)
            }
        }

        onTankLevel1Changed: {
            graphicalDisplay.tankLevel1 = sim.tankLevel1

        }

        onAppRate1Changed: {
            graphicalDisplay.appRate1 = appRate1
        }

        onTankLevel2Changed: {
            graphicalDisplay.tankLevel2 = sim.tankLevel2
        }

        onAppRate2Changed: {
            graphicalDisplay.appRate2 = appRate2
        }

        onNozzle1StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle1State(nozzle1Status)
        }
        onNozzle2StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle2State(nozzle2Status)
        }
        onNozzle3StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle3State(nozzle3Status)
        }
        onNozzle4StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle4State(nozzle4Status)
        }
        onNozzle5StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle5State(nozzle5Status)
        }
        onNozzle6StatusChanged: {
            graphicalDisplay.broomHeightElement.changeNozzle6State(nozzle6Status)
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
        leftPlayer.stop()
        frontPlayer.stop()
        rightPlayer.stop()
        sim.start = false
        // liveValue.stopUpdates()
    }
} // End of ApplicationWindow
