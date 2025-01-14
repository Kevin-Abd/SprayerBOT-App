import QtQuick 2.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3
import "../UI"

Item {
    id: graphicalElements

    property alias speed : speedometer.value
    property alias rpm : tachometer.value
    property alias broomHeight : broomHeightElement.val
    property alias tankLevel1 : tank1.level
    property alias tankLevel2 : tank2.level
    property alias appRate1 : rate1.value
    property alias appRate2 : rate2.value

    property BroomHeight broomHeightElement: broomHeightElement
    property CoverageMap coverageMap: coverageMap


    Layout.preferredWidth: parent.width
    Layout.preferredHeight: parent.height * 0.55

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
                                id: columnLayout
                                anchors.fill: parent

                                Item {
                                    id: tank1Container

                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: parent.height / 2.5
                                    Layout.topMargin: 20

                                    RowLayout {
                                        spacing: 0
                                        anchors.fill: parent

                                        TankLevel {
                                            id: tank1

                                            name: "Tank 1"

                                            maxValue: 25
                                            tickInterval: 5
                                            minorTickInterval: 0

                                            Layout.leftMargin: 0
                                            Layout.preferredHeight: parent.height * 0.8
                                            Layout.preferredWidth: 90
                                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                                        }

                                        ApplicationRate {
                                            Layout.leftMargin: 15
                                            id: rate1    
                                        }
                                    }
                                }

                                Item {
                                    id: tank2Container

                                    Layout.preferredWidth: parent.width
                                    Layout.preferredHeight: parent.height / 2.5

                                    RowLayout {
                                        spacing: 0
                                        anchors.fill: parent

                                        TankLevel {
                                            id: tank2

                                            name: "Tank 2"
                                            maxValue: 5
                                            tickInterval: 1
                                            minorTickInterval: 0

                                            Layout.leftMargin: 0
                                            Layout.preferredHeight: parent.height * 0.8
                                            Layout.preferredWidth: 90
                                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                        }

                                        ApplicationRate {
                                            id: rate2
                                            Layout.leftMargin: 8
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
                    id: broomContainer

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
                                    verticalCenterOffset: 12.5
                                    horizontalCenterOffset: 7
                                }

                                Text {
                                    id: valueText

                                    text: broomHeightElement.broomHeightValue.toFixed(0)

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

                                    text: " in"

                                    color: "Black"
                                    font.weight: Font.DemiBold
                                    font.pixelSize: Math.max(12, parent.width * 0.2)
                                    anchors.left: valueText.right
                                    anchors.bottom: valueText.bottom

                                }

                                Text {
                                    id: label

                                    text: "Boom Height"

                                    color: "black"
                                    bottomPadding: 3.5
                                    font.letterSpacing: 1.15
                                    font.pixelSize: Math.max(8, parent.width * 0.125)

                                    anchors {
                                        topMargin: 3.5
                                        bottom: parent.bottom
                                        top: valueText.bottom
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        } // End of labelContainer

                        BroomHeight {
                            id: broomHeightElement

                            Layout.topMargin: -25
                        }
                    }
                } // End of broomContainer
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
                    id: gauges

                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height * 0.45

                    RowLayout {
                        spacing: 5
                        anchors.fill: parent

                        Item {
                            id: travelSpeed

                            Layout.preferredWidth: parent.width * 0.45
                            Layout.preferredHeight: parent.height

                            CircularGauge {
                                id: speedometer

                                height: parent.height * 0.90
                                width: parent.width

                                stepSize: 0.1
                                maximumValue: 9            // maximum speed
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width * 0.02
                                anchors.verticalCenter: parent.verticalCenter

                                style: SpeedGaugeStyle {}
                            }
                        }

                        Item {
                            id: engineSpeed

                            Layout.preferredWidth: parent.width * 0.45
                            Layout.preferredHeight: parent.height

                            CircularGauge {
                                id: tachometer

                                height: parent.height * 0.90
                                width: parent.width

                                stepSize: 0.1
                                maximumValue: 8            // maximum rev per min
                                anchors.left: parent.left
                                anchors.leftMargin: parent.width * 0.015
                                anchors.verticalCenter: parent.verticalCenter

                                style: TachometerStyle {}
                            }
                        }
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
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
