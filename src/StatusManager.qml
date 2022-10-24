import QtQuick 2.12
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10
import FileIO 1.0

QtObject{
    id: statusManager

    property var lastAlert: { "code": "", "status": "", "messsage":"" }

    property string alert
    property alias state: myStateGroup.state
    property real counter: 0

    property AlertSoundEffect alertSoundEffect
    property PhidgetFeedback phidgetFeedback
    property NotificationsBar notificationsBar
    property ButtonAlertPerceived buttonAlertPerceived

    property bool warningFeedback
    property bool logWarningTimes

    property StateGroup stateGroup : StateGroup {
        id: myStateGroup
        state: "warmup"
        states: [
            State { name: "warmup" },
            State { name: "tutorial_visual" },
            State { name: "tutorial_auditory" },
            State { name: "tutorial_tactile" },
            State { name: "tutorial_done" },
            State { name: "experiments" }
        ]
    }

    property FileIO file: FileIO {
        id: fileio

        property var locale: Qt.locale()
        property date currentDate: new Date()
        property string dateString: Qt.formatDateTime(currentDate ,"yyyy-MM-ddThh-mm")
        property string fileName: dateString + ".log"
    }

    Component.onCompleted: {
        print(fileio.fileName);
        var res = fileio.open(fileio.fileName)
        console.log("[Info]", "FileIO open: " + res)
    }

    Component.onDestruction: {
        fileio.close()
    }

    function updateState(simState){
        if (simState === "warmup")
            state = "warmup"
        else if (simState === "tutorial")
            state = "tutorial_visual"
        else if (simState === "experiments")
            state = "experiments"
        else
            console.log("[Warn]", "[updateState] Got unexpected state: " + state)
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
        console.log("[Deubg]", `${state}: (${newAlert.status}, ${newAlert.code}) at ${Date.now()}`)

        if (state === "warmup")
            processForWarmup(newAlert)

        else if (state === "tutorial_visual")
            processForTutorial(newAlert, "visual")

        else if (state === "tutorial_auditory")
            processForTutorial(newAlert, "auditory")

        else if (state === "tutorial_tactile")
            processForTutorial(newAlert, "tactile")

        else if (state === "tutorial_done")
            processForTutorial(newAlert, "clear")

        else if (state === "experiments")
            processForExperiment(newAlert)

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
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else
            console.log("[Debug]", "Got unexpected status in warmup: " + newAlert.status)
    }

    function processForTutorial(newAlert, feedback){
        /**
         * Function to handle state change while in tutorial state
         * For warning state starts only one feedback based on input
         */

        if (newAlert.status === "off" || newAlert.status === "nominal"){
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else if (newAlert.status === "warning"){

            if (feedback === "visual") {
                notificationsBar.setState(newAlert.message, newAlert.status)
                state = "tutorial_auditory"
            }
            else if (feedback === "auditory") {
                alertSoundEffect.play()
                state = "tutorial_tactile"
            }
            else if (feedback === "tactile") {
                phidgetFeedback.activate()
                state = "tutorial_done"
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
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else if (newAlert.status === "nominal"){
            notificationsBar.setState(newAlert.message, newAlert.status)
            buttonAlertPerceived.enabled = false
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
            buttonAlertPerceived.enabled = true

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
        buttonAlertPerceived.checked = false
        buttonAlertPerceived.enabled = false

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
