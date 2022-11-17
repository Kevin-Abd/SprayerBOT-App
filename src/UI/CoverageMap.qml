import QtQuick 2.10
import QtLocation 5.10
import QtPositioning 5.10

Item {
    id: mapRoot

    property bool active: false
    readonly property var currentPosition: positionSource.position.coordinate

    state: "overview"

    PositionSource {
        id: positionSource

        active: mapRoot.active
        nmeaSource: '../nmea_log.txt'

        onPositionChanged: {
            travelledPath.addCoordinate(currentPosition)
        }
    }

    Map {
        id: map

        anchors.fill: parent
        color: 'transparent'
        center: currentPosition
        activeMapType: map.supportedMapTypes[3];// satellite map
        zoomLevel: 16.5
        maximumZoomLevel: 20
        minimumZoomLevel: 10
        gesture.enabled: true

        plugin: Plugin {
            name: "here"

            PluginParameter {
                name: 'here.app_id'
                value: '1t7Eq7EbmlNllBgPKR8z' //'WZPNF1Nhbt9KxW3dWNhY'       // HERE map API id
            }

            PluginParameter {
                name: 'here.token'
                value: 'mIvjGgxTgbunqRyjxocOVg' //'dmVZyuNWqSIj_C6eiHCFJQ'     // HERE map API token
            }

            PluginParameter {
                name: 'here.proxy'
                value: 'system'
            }

            PluginParameter {
                name: 'here.mapping.highdpi_tiles'  // Enables high dpi scaling
                value: 'true'
            }
        }
    }

    Map {
        id: mapOverlay

        property int w : mapOverlay.width
        property int h : mapOverlay.height

        anchors.fill: map
        plugin: Plugin { name: "itemsoverlay" }
        color: 'transparent'
        minimumFieldOfView: map.minimumFieldOfView
        maximumFieldOfView: map.maximumFieldOfView
        fieldOfView: map.fieldOfView
        minimumZoomLevel: map.minimumZoomLevel
        maximumZoomLevel: map.maximumZoomLevel
        zoomLevel: map.zoomLevel
        minimumTilt: map.minimumTilt
        maximumTilt: map.maximumTilt
        tilt: map.tilt;
        bearing: map.bearing
        center: map.center
        z: map.z + 1                        // places mapOverlay item directly above map item
        gesture.enabled: false

        // The code below enables SSAA
        layer.enabled: true
        layer.smooth: true
        layer.textureSize: Qt.size(w  * 2 * root.pr, h * 2 * root.pr)

        MapCircle {
            id: circle

            center: mapOverlay.center
            radius: 35 + (((map.zoomLevel - map.minimumZoomLevel) * (1.5 - 35)) /
                    (map.maximumZoomLevel - map.minimumZoomLevel)) // linear interpolation
            border.width: 0
            color: '#DCF3F4'

            MouseArea {
                anchors.fill: parent
                drag.target: parent             // makes the circle item draggable
            }
        }

        MapPolyline {
            id: travelledPath

            line.width: 3.5                     // TO-DO: make proportional to broom length
            line.color: 'orange'
            path: []
        }
    }

    states: [
        State {
            name: "overview"
            PropertyChanges {target: map; tilt: 0; bearing: -30; zoomLevel: 15;
                center: QtPositioning.coordinate(49.8072, -97.1341)
            }
        },

        State {
            name: "navigating"
            PropertyChanges {target: map; tilt: 45; zoomLevel: 17;
                center: positionSource.position.coordinate
            }
        }
    ]

    transitions: [
        Transition {
            from: "fromState"
            to: "*"
            RotationAnimation{target: map;
                property: "bearing"; duration: 300; direction: RotationAnimation.Shortest
            }
        }
    ]
}
