import Weather 1.0
import QtQuick 2.10
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Popup {
    id: current

    readonly property string notification: "Wind speed is " +
                                           model.weather.windSpeed +
                                           "! Please consider suspending spraying operations."

    modal: false
    focus: true             // brings the Popup in active focus

    AppModel {
        id: model

        onWeatherChanged: {
            /* Warn user when wind speed is greater than 12 mph
                Reference: https://sprayers101.com/five-tips-for-spraying-in-the-wind/ */
            if (parseInt(model.weather.windSpeed, 10) > 12) {
                notificationsList.addWarning(notification)
            } else {
                notificationsList.removeWarning(notification)
            }
        }
    }

    Item {
        id: windData

        height: parent.height
        width: parent.width * 0.40

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 25
            leftMargin: 5
        }

        ColumnLayout {
            spacing: 0
            anchors.fill: parent

            Item {
                id: windSpeedData

               Layout.preferredHeight: parent.height * 0.40
               Layout.preferredWidth: parent.width
               Layout.topMargin: -35

                RowLayout {
                    spacing: 7.5
                    anchors.fill: parent

                    Image {
                        id: icon1

                        source: "../media/icons8-wind-64.png"
                        Layout.preferredHeight: parent.height * 0.3125
                        Layout.preferredWidth: parent.width * 0.125
                        asynchronous: true
                    }

                    Text {
                        id: windSpeedText

                        text: (model.hasValidWeather
                               ? model.weather.windSpeed
                               : "??")
                        font.weight: Font.DemiBold
                        font.pixelSize: Math.max(11, parent.width * 0.115)
                    }
                }
            }

            Item {
                id: windDirection

                Layout.preferredHeight: parent.height * 0.40
                Layout.preferredWidth: parent.width
                Layout.topMargin: -25

                RowLayout {
                    spacing: 7.5
                    anchors.fill: parent

                    Image {
                        id: icon2

                        source: "../media/icons8-arrow-16.png"
                        Layout.preferredHeight: parent.height * 0.3125
                        Layout.preferredWidth: parent.width * 0.125
                        asynchronous: true
                        transform: Rotation { origin.x: 5; origin.y: 5; angle:
                                (parseFloat(windText.text) - 90)} // rotates the image based on value
                    }

                    Text {
                        id: windText

                        text: (model.hasValidWeather
                               ? model.weather.windDirection
                               : "??")
                        font.weight: Font.DemiBold
                        font.pixelSize: Math.max(11, parent.width * 0.115)
                    }
                }
            }
        }
    }

    Item {
        id: weather

        height: parent.height
        width: parent.width * 0.4

        anchors {
            left: windData.right
            top: parent.top
            topMargin: 10
            leftMargin: -10
        }

        BigForecastIcon {
            id: currentWeather

            width: parent.width
            height: parent.height

            weatherIcon: (model.hasValidWeather
                      ? model.weather.weatherIcon
                      : "01d")
            temperature: (model.hasValidWeather
                      ? model.weather.temperature
                      : "??")
            weatherDescription: (model.hasValidWeather
                         ? model.weather.weatherDescription
                         : "No weather data")

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    model.refreshWeather()
                }
            }
        }
    }

    XButton {
        id: xButton

        onClicked: {
            current.close()
        }
    }
}
