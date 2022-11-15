import Weather 1.0
import QtQuick 2.10
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10

Popup {
    id: forecastPopup

    modal: false
    focus: true
    property AppModel model

    RowLayout {
        id: iconRow

        property real iconWidth: iconRow.width * 0.45
        property real iconHeight: iconRow.height

        spacing: 15
        anchors.fill: parent

        ForecastIcon {
            id: forecast1

            Layout.preferredWidth: iconRow.iconWidth
            Layout.preferredHeight: iconRow.iconHeight
            Layout.leftMargin: 8.5

            time:  (model.hasValidWeather ?
                      model.forecast[0].timeOfDay : "??")
            temperature:  (model.hasValidWeather ?
                         model.forecast[0].temperature : "??")
            weatherIcon: (model.hasValidWeather ?
                      model.forecast[0].weatherIcon : "01d")
            description: (model.hasValidWeather ?
                      model.forecast[0].weatherDescription : "No Weather Data")
            wind: (model.hasValidWeather ?
                       model.forecast[0].windSpeed : "??")
        }

        ForecastIcon {
            id: forecast2

            Layout.preferredWidth: iconRow.iconWidth
            Layout.preferredHeight: iconRow.iconHeight

            time:  (model.hasValidWeather ? model.forecast[1].timeOfDay : "??")
            temperature:  (model.hasValidWeather ? model.forecast[1].temperature : "??")
            weatherIcon: (model.hasValidWeather ? model.forecast[1].weatherIcon : "01d")
            description: (model.hasValidWeather ? model.forecast[1].weatherDescription : "No Weather Data")
            wind: (model.hasValidWeather ? model.forecast[1].windSpeed : "??")
        }
    }

    XButton {
        id: xButton

        onClicked: {
            forecastPopup.close()
        }
    }
}
