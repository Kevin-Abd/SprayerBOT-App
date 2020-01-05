import QtQuick 2.10
import QtMultimedia 5.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3
import "NotificationsManager.js" as NotificationsManager

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

                    coverageMap.active = true       // Activate the map's "navigating" state
                    coverageMap.state = "navigating"
                    liveValue.startUpdates()        // Start receiving updates from agbotwebserver

                    /* Replace the notifications bar with an empty string while removing
                      removing instructional and nominal messages from the notifications list. */
                    NotificationsManager.removeNotification(notificationsList,
                                                            notificationsList.startupInstruction)
                    NotificationsManager.removeNotification(notificationsList,
                                                            notificationsList.allClear)
                    NotificationsManager.removeNotification(notificationsList,
                                                            notificationsList.emergency)

                    notificationsBar.alert = ""
                    statusIndicator.state = "off"
                }
            }

            Rectangle {
                id: notificationsBar

                /* This element displays notifications about the different elements
                   presented on the UI, using both text and */

                property string alert          // holds the current notification message on display

                radius: parent.width * 0.25

                border.width: 1
                border.color: "gray"

                Layout.topMargin: 5
                Layout.bottomMargin: 5
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width * 0.45
                Layout.preferredHeight: parent.height * 0.45

                MachineStatus {
                    id: statusIndicator

                    /* Uses the StatusIndicator element to display the state of the machine
                       and the severity of the notification. */
                    height: notificationsBar.height
                    width: height
                    Layout.leftMargin: 10
                    Layout.alignment: Qt.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    id: notificationsContainer

                    height: parent.height * 0.9
                    width: parent.width * 0.9
                    anchors.left: statusIndicator.right
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: alertMessage

                        text: qsTr(notificationsBar.alert)
                        font.pixelSize: Math.max(11, parent.width * 0.035)
                        horizontalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        anchors.centerIn: parent
                        anchors.leftMargin: 7
                        width: parent.width
                    }
                }
            }

            EngineStartStop {
                id: stopButton

                Layout.topMargin: 5
                Layout.leftMargin: -5
                Layout.rightMargin: 15
                Layout.bottomMargin: 5
                Layout.alignment: Qt.AlignRight

                text: ""                            // Clears the default text
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
                    anchors.bottomMargin: 63.75
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
                    anchors.bottomMargin: 25
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

                    coverageMap.active = false
                    liveValue.stopUpdates()

                    NotificationsManager.removeNotification(notificationsList,
                                                            notificationsList.startupInstruction)
                    NotificationsManager.removeNotification(notificationsList,
                                                            notificationsList.allClear)

                    statusIndicator.state = "error"
                    notificationsBar.alert = "The machine has been stopped!"
                    notificationsList.append({message: notificationsList.emergency,
                                                 status: "error"})
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

                Layout.preferredWidth: parent.width
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

            Item {
                id: graphicalElements

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.65

                RowLayout {
                    anchors.fill: parent

                    Item {
                        id: sprayerElements

                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.width * 0.7

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                id: sprayerInfoContainer

                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.4

                                ColumnLayout {
                                    anchors.fill: parent

                                    Item {
                                        id: tankContainer

                                        Layout.preferredHeight: parent.height * 0.75
                                        Layout.preferredWidth: parent.width

                                        ColumnLayout {
                                            anchors.fill: parent

                                            Item {
                                                id: tank1Container

                                                Layout.preferredWidth: parent.width
                                                Layout.preferredHeight: parent.height / 2.5

                                                RowLayout {
                                                    spacing: 5
                                                    anchors.fill: parent

                                                    TankLevel {
                                                        id: tank1

                                                        name: "Tank 1"
                                                        maxValue: 100
                                                        tickInterval: 25
                                                        minorTickInterval: 0
                                                        Layout.leftMargin: parent.width * 0.0725
                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.preferredHeight: parent.height * 0.8
                                                        Layout.preferredWidth: Math.min
                                                                               (67.5, parent.width *
                                                                                0.3)
                                                    }

                                                    ApplicationRate {
                                                        id: rate1

                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.alignment: Qt.AlignCenter

                                                        onWidthChanged: {
                                                            if (width <= 119) {
                                                                Layout.leftMargin = 30;
                                                            } else {
                                                                Layout.leftMargin = -25
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            Item {
                                                id: tank2Container

                                                Layout.preferredWidth: parent.width
                                                Layout.preferredHeight: parent.height / 2.5

                                                RowLayout {
                                                    spacing: 5
                                                    anchors.fill: parent

                                                    TankLevel {
                                                        id: tank2

                                                        name: "Tank 2"
                                                        maxValue: 20
                                                        tickInterval: 5
                                                        minorTickInterval: 0
                                                        Layout.leftMargin: parent.width * 0.0925
                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.preferredHeight: parent.height * 0.8
                                                        Layout.preferredWidth: Math.min
                                                                               (67.5, parent.width *
                                                                                0.3)
                                                    }

                                                    ApplicationRate {
                                                        id: rate2

                                                        Layout.topMargin: parent.height * 0.25
                                                        Layout.alignment: Qt.AlignCenter

                                                        onWidthChanged: {
                                                            if (width <= 119) {
                                                                Layout.leftMargin = 20;
                                                            } else {
                                                                Layout.leftMargin = -35
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } // End of tankContainer

                                    Item {
                                        id: weatherContainer

                                        Layout.preferredHeight: parent.height * 0.25
                                        Layout.preferredWidth: parent.width

                                        Weather {
                                            anchors.fill: parent
                                        }
                                    } // End of weatherContainer
                                }
                            } // End of sprayerInfoContainer

                            Item {
                                id: boomContainer

                                Layout.preferredWidth: parent.width * 0.6
                                Layout.preferredHeight: parent.height

                                ColumnLayout {
                                    spacing: 0
                                    anchors.fill: parent

                                    Item {
                                        id: labelContainer

                                        Layout.preferredWidth: parent.width
                                        Layout.preferredHeight: parent.height * 0.15
                                        Layout.topMargin: -7.5

                                        Pane {
                                            id: container

                                            width: parent.width * 0.25
                                            height: Math.max(40, width * 0.45)

                                            Material.elevation: 2

                                            anchors {
                                                verticalCenter: parent.verticalCenter
                                                horizontalCenter: parent.horizontalCenter
                                                verticalCenterOffset: 5
                                                horizontalCenterOffset: 7
                                            }

                                            Text {
                                                id: valueText

                                                text: boomHeightElement.boomHeightValue.toFixed(0)

                                                font.pixelSize: Math.max(14, parent.width * 0.25)
                                                font.bold: true
                                                color: "Black"
                                                topPadding: 5

                                                anchors {
                                                    verticalCenter: parent.verticalCenter
                                                    horizontalCenter: parent.horizontalCenter
                                                    verticalCenterOffset: -10
                                                    horizontalCenterOffset: -10
                                                }
                                            }

                                            Text {
                                                id: unitLabel

                                                text: " cm"

                                                color: "Black"
                                                font.weight: Font.DemiBold
                                                font.pixelSize: Math.max(12, parent.width * 0.20)
                                                anchors.left: valueText.right
                                                anchors.bottom: valueText.bottom

                                            }

                                            Text {
                                                id: label

                                                text: "Boom Height"

                                                color: "black"
                                                bottomPadding: 3.5
                                                font.letterSpacing: 1.15
                                                font.pixelSize: Math.max(7, parent.width * 0.11)

                                                anchors {
                                                    topMargin: 3.5
                                                    bottom: parent.bottom
                                                    top: valueText.bottom
                                                    horizontalCenter: parent.horizontalCenter
                                                }
                                            }
                                        }
                                    } // End of labelContainer

                                    BoomHeight {
                                        id: boomHeightElement

                                        Layout.topMargin: -25
                                    }
                                }
                            } // End of boomContainer
                        }
                    } // End of sprayerElements

                    Item {
                        id: vehicleElements

                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.width * 0.3

                        ColumnLayout {
                            spacing: 0
                            anchors.fill: parent

                            Item {
                                id: travelSpeed

                                Layout.preferredWidth: parent.width
                                Layout.preferredHeight: parent.height * 0.45

                                CircularGauge {
                                    id: speedometer

                                    readonly property string highSpeedWarning: "The machine is moving too fast!"
                                    readonly property string lowSpeedWarning: "The machine is moving too slow!"

                                    height: parent.height * 0.90
                                    width: height

                                    stepSize: 1
                                    maximumValue: 15            // maximum speed
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.width * 0.025
                                    anchors.verticalCenter: parent.verticalCenter

                                    style: SpeedGaugeStyle {}
                                }
                            }

                            Item {
                                id: mapArea

                                Layout.preferredHeight: parent.height * 0.55
                                Layout.preferredWidth: parent.width

                                CoverageMap {
                                    id: coverageMap

                                    anchors.fill: parent
                                }
                            }
                        }
                    } // End of vehicleElements
                }
            } // End of graphicalElements
        }
    } // End of contentItem

    ListModel {
        id: notificationsList

        readonly property string startupInstruction: "To begin, press and hold the START button."
        readonly property string emergency: "The machine has been stopped!"
        readonly property string allClear: "All systems are normal"

        ListElement {
            message: "To begin, press and hold the START button."
            status: "off"
        }
    }

    Timer {
        id: timer

        property real counter: 0

        function setAlertMessage() {
            notificationsBar.alert = notificationsList.get(counter).message;
            statusIndicator.state = notificationsList.get(counter).status;
        }

        triggeredOnStart: true
        interval: 5000
        running: true
        repeat: true

        onTriggered: {
            if (notificationsList.count === 0) {
                notificationsList.set(0, {message: notificationsList.allClear, status: "nominal"})
                counter = 0
                setAlertMessage()
            }

            if (counter < notificationsList.count) {
                setAlertMessage()
                counter++
            } else {
                counter = 0
                setAlertMessage()
            }
        }
    }

    ValueSource {
        id: liveValue

        onSpeedChanged: {
            speedometer.value = speed

            if (speed > 0 && speed <= 5) {
                if (NotificationsManager.numberOfEntries(notificationsList, speedometer.lowSpeedWarning) === 0) {
                    notificationsList.append({message: speedometer.lowSpeedWarning, status: "warning"})
                }
                NotificationsManager.removeNotification(notificationsList, speedometer.highSpeedWarning)
            } else if (speed > 10) {
                if (NotificationsManager.numberOfEntries(notificationsList, speedometer.highSpeedWarning) === 0) {
                    notificationsList.append({message: speedometer.highSpeedWarning, status: "warning"})
                }
                NotificationsManager.removeNotification(notificationsList, speedometer.lowSpeedWarning)
            } else {
                NotificationsManager.removeNotification(notificationsList, speedometer.lowSpeedWarning)
                NotificationsManager.removeNotification(notificationsList, speedometer.highSpeedWarning)
            }
        }

        onBoomHeightChanged: {
            boomHeightElement.val = boomHeight

            if (boomHeight > 75) {
                if (NotificationsManager.numberOfEntries(notificationsList, boomHeightElement.highHeightWarning) === 0) {
                    notificationsList.append({message: boomHeightElement.highHeightWarning, status: "warning"})
                }
                NotificationsManager.removeNotification(notificationsList, boomHeightElement.lowHeightWarning)
            } else if (boomHeight < 55) {
                if (NotificationsManager.numberOfEntries(notificationsList, boomHeightElement.lowHeightWarning) === 0) {
                    notificationsList.append({message: boomHeightElement.lowHeightWarning, status: "warning"})
                }
                NotificationsManager.removeNotification(notificationsList, boomHeightElement.highHeightWarning)
            } else {
                NotificationsManager.removeNotification(notificationsList, boomHeightElement.highHeightWarning)
                NotificationsManager.removeNotification(notificationsList, boomHeightElement.lowHeightWarning)
            }
        }

        onTankLevel1Changed: {
            tank1.level = tankLevel1
        }

        onApplicationRate1Changed: {
            rate1.value = applicationRate1
        }

        onTankLevel2Changed: {
            tank2.level = tankLevel2
        }

        onApplicationRate2Changed: {
            rate2.value = applicationRate2
        }

        onNozzle1StateChanged: {
            if (pumpState === true && nozzle1State === true && applicationRate1 < 15.0) {
                boomHeightElement.changeNozzle1State("blocked")
            } else if (pumpState == true && nozzle1State == true) {
                boomHeightElement.changeNozzle1State("on")
            } else {
                boomHeightElement.changeNozzle1State("off")
            }
        }
        onNozzle2StateChanged: {
            if (nozzle2State === true && applicationRate2 < 15.0) {
                boomHeightElement.changeNozzle2State("blocked")
            } else if (nozzle2State == true) {
                boomHeightElement.changeNozzle2State("on")
            } else {
                boomHeightElement.changeNozzle2State("off")
            }
        }
        onNozzle3StateChanged: {
            if (pumpState === true && nozzle3State === true && applicationRate1 < 15.0) {
                boomHeightElement.changeNozzle3State("blocked")
            } else if (pumpState == true && nozzle3State == true) {
                boomHeightElement.changeNozzle3State("on")
            } else {
                boomHeightElement.changeNozzle3State("off")
            }
        }
        onNozzle4StateChanged: {
            if (pumpState === true && nozzle4State === true && applicationRate1 < 15.0) {
                boomHeightElement.changeNozzle4State("blocked")
            } else if (pumpState == true && nozzle4State == true) {
                boomHeightElement.changeNozzle4State("on")
            } else {
                boomHeightElement.changeNozzle4State("off")
            }
        }
        onNozzle5StateChanged: {
            if (nozzle5State === true && applicationRate2 < 15.0) {
                boomHeightElement.changeNozzle5State("blocked")
            } else if (nozzle5State == true) {
                boomHeightElement.changeNozzle5State("on")
            } else {
                boomHeightElement.changeNozzle5State("off")
            }
        }
        onNozzle6StateChanged: {
            if (pumpState === true && nozzle6State === true && applicationRate1 < 15.0) {
                boomHeightElement.changeNozzle6State("blocked")
            } else if (pumpState == true && nozzle6State == true) {
                boomHeightElement.changeNozzle6State("on")
            } else {
                boomHeightElement.changeNozzle6State("off")
            }
        }
    }

    onClosing: {
        leftPlayer.stop()
        frontPlayer.stop()
        rightPlayer.stop()
        liveValue.stopUpdates()
    }
} // End of ApplicationWindow
