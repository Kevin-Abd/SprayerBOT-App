import QtQuick 2.0
import LiveVehicleData 1.0

LiveData {
    id: valueSource

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
}
