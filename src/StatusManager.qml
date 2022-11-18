import QtQuick 2.12
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10
import FileIO 1.0
import "UI"

QtObject{
    id: statusManager

    property var lastAlert: { "code": "", "status": "", "messsage":"" }
    property string alert
    property alias state: myStateGroup.state
    property real counter: 0

    property AlertSoundEffect alertSoundEffect
    property PhidgetFeedback phidgetFeedback
    property NotificationsBar notificationsBar
    property ButtonAlertPerceived buttonAlertPerceived1
    property ButtonAlertPerceived buttonAlertPerceived2

    property bool warningFeedback
    property bool logWarningTimes

    property StateGroup stateGroup : StateGroup {
        id: myStateGroup
        state: "warmup"
        states: [
            State { name: "warmup" },
            State { name: "tutorial" },
            State { name: "experiments" },
            State { name: "finished" }
        ]
    }

    property FileIO file: FileIO {
        id: fileio

        property var locale: Qt.locale()
        property date currentDate: new Date()
        property string dateString: Qt.formatDateTime(currentDate ,"yyyy-MM-ddThh-mm")
        property string fileName: dateString + ".log"
        property string logDir: "C:\\_TMP\\spray-bot\\logs"

        Component.onCompleted: {
            var res = fileio.open(logDir, fileName)
            console.log("[Info]", `Logfile '${fileName}' open: ${res} in ${logDir}`)
        }
    }

    Component.onDestruction: {
        fileio.close()
    }

    function updateState(simState){
        if (simState === "warmup")
            state = "warmup"
        else if (simState === "tutorial")
            state = "tutorial"
        else if (simState === "experiments")
            state = "experiments"
        else if (simState === "finished")
            state = "finished"
        else
            console.log("[Warn]", "[updateState] Got unexpected state: " + simState)
    }

    function checkForNewStatus(){

        var alert

        if (notifications.count === 0){
            alert = notifications.list_instruction["normal"]
            alert.status = "nominal"
        } else {
            var object = notifications.getUnprocessed()
            if (object === null){
                alert = notifications.list_instruction["normal"]
                alert.status = "nominal"
            } else {
                alert = object
                alert.status = object.status
                notifications.setProccessed(alert.code)
            }
        }

        if (alert.code !== lastAlert.code)
            processNewStatus(alert)

    }

    function processNewStatus(newAlert){
        /**
         * Function to handle new status
         * It is responsible for trigggering warning displays and feedback
         */
        console.log("[Info]", `${state}: (${newAlert.status}, ${newAlert.code}) at ${Date.now()}`)

        if (state === "warmup")
            processForWarmup(newAlert)

        else if (state === "tutorial")
            processForTutorial(newAlert)

        else if (state === "experiments")
            processForExperiment(newAlert)

        else if (state === "finished"){
            buttonAlertPerceived1.checked = false
            buttonAlertPerceived1.enabled = false
            buttonAlertPerceived2.checked = false
            buttonAlertPerceived2.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
            newAlert = notifications.list_instruction["end"]
            newAlert.status = "off"
            notificationsBar.setState(newAlert.message, newAlert.status)
            return
        }


        else
            console.log("[Warn]", "Got unexpected state: " + state)

        lastAlert.code = newAlert.code
        lastAlert.message = newAlert.message
        lastAlert.status = newAlert.status
    }

    function processForWarmup(newAlert){
        /**
         * Function to handle state change while in warmup state
         * Only updates for "off" and "nominal states" and stops warning feedbacks
         */

        if (newAlert.status === "off" || newAlert.status === "nominal"){
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived1.enabled = false
            buttonAlertPerceived2.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else
            console.log("[Debug]", `Unexpected alert in warmup: (Code: ${newAlert.code}, Status: ${newAlert.status}) `)
    }

    function processForTutorial(newAlert){
        /**
         * Function to handle state change while in tutorial state
         * Type of feedback is decided from alert code
         */

        if (newAlert.status === "off" || newAlert.status === "nominal"){
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived1.enabled = false
            buttonAlertPerceived2.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else if (newAlert.status === "warning" || newAlert.status === "blank"){

            notificationsBar.setState(newAlert.message, newAlert.status)

            if (newAlert.code === "022" || newAlert.code === "024") {
                // Auditory or Visual_Auditory
                alertSoundEffect.play()
            }
            if (newAlert.code === "023" || newAlert.code === "025") {
                // Tactile or Visual_Tactile
                phidgetFeedback.activate()
            }
        }
        else
            console.log("[Debug]", "Got unexpected status in tutorial: " + newAlert.status)
    }

    function processForExperiment(newAlert){
        /**
         * Function to handle state change while in experiment state
         * For warning state starts visual and one other feedback
         * Feedback is randomly chosen as auditory or tactile
         * For nominal checks of last state was warning. then records user missed alert
         */

        if (newAlert.status === "off"){
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived1.enabled = false
            buttonAlertPerceived2.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else if (newAlert.status === "nominal"){
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived1.enabled = false
            buttonAlertPerceived2.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()

            if (lastAlert.status === "warning"){
                // log alert missed
                fileio.write(`${lastAlert.code}, Missed\n`)
            }
        }
        else if (newAlert.status === "warning"){
            // choose feedback
            var rand = Math.floor(Math.random() * 2)
            var feedback = "NAN"

            if (rand === 0){
                feedback = "auditory"
                alertSoundEffect.play()
            } else if (rand === 1) {
                feedback = "tactile"
                phidgetFeedback.activate()
            }

            // Always update visual feedback
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived1.enabled = true
            buttonAlertPerceived2.enabled = true

            // log alert start time + type
            fileio.write(`\nNewAlert, ${newAlert.code}, ${Date.now()}, ${feedback}, `)
        }
        else
            console.log("[Debug]", "Got unexpected status in experiments: " + newAlert.status)

    }


    function userOverride(){
        /**
         * Function called by buttonAlertPerceived when user aknowlegdes the alert
         */
        // log override time and the last alert code
        fileio.write(`${lastAlert.code}, ${Date.now()}\n`)

        // disable alert percived button
        buttonAlertPerceived1.checked = false
        buttonAlertPerceived1.enabled = false
        buttonAlertPerceived2.checked = false
        buttonAlertPerceived2.enabled = false

        // clear alert feedback
        alertSoundEffect.stop()
        phidgetFeedback.deactivate()
        notificationsBar.setState(notifications.list_instruction["normal"].message, "nominal")

        var newAlert = notifications.list_instruction["normal"]

        lastAlert.code = newAlert.code
        lastAlert.message = newAlert.message
        lastAlert.status = "nominal"

    }

}
