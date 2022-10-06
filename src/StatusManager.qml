import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.10
import FileIO 1.0

QtObject{
    id: statusManager

    property string lastMessage
    property string lastStatus
    property string alert
    property string state: stateGroup.state
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
            State { name: "tutorial_clear" },
            State { name: "tutorial_visual" },
            State { name: "tutorial_auditory" },
            State { name: "tutorial_tactile" },
            State { name: "experminets" }
        ]
    }

    property FileIO file: FileIO {
        id: fileio
    }

    function checkForNewStatus(){

        var status = ""
        var message = ""

        if (notifications.count === 0){
            status = "nominal"
            message = notifications.allClearMessage
        } else {
            var object = notifications.getUnprocessed()
            if (object === null){
                status = "nominal"
                message = notifications.allClearMessage
            } else {
                status = object.status
                message = object.message
                notifications.setProccessed(message)
            }
        }

        if (status !== lastStatus || message !== lastMessage)
            processNewStatus(status, message)
    }

    function processNewStatus(newStatus, newNotification){
        /**
         * Function to handle new status
         * It is responsible for trigggering warning displays and feedback
         */
        console.debug(`state: ${state})\t status: ${newStatus}, ${newNotification}`)

        if (state === "warmup") processForWarmup(newStatus, newNotification)
        else if (state === "tutorial_clear") processForTutorial(newStatus, newNotification, "clear")
        else if (state === "tutorial_visual") processForTutorial(newStatus, newNotification, "visual")
        else if (state === "tutorial_auditory") processForTutorial(newStatus, newNotification, "auditory")
        else if (state === "tutorial_tactile") processForTutorial(newStatus, newNotification, "tactile")
        else if (state === "experminets") processForExperiment(newStatus, newNotification)
        else console.warn("Got unexpected state: " + state)

        lastStatus = newStatus
        lastMessage = newNotification
    }

    function processForWarmup(newStatus, newNotification){
        /**
         * Function to handle state change while in warmup state
         * Only updates for "off" and "nominal states" and stops warning feedbacks
         */

        if (newStatus === "off" || newStatus === "nominal"){
            notificationsBar.setState(newNotification, newStatus)
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else
            console.debug("Got unexpected status in warmup: " + newStatus)
    }

    function processForTutorial(newStatus, newNotification, feedback){
        /**
         * Function to handle state change while in tutorial state
         * For warning state starts only one feedback based on input
         */

        if (newStatus === "off" || newStatus === "nominal"){
            notificationsBar.setState(newNotification, newStatus)
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else if (newStatus === "warning"){

            if (feedback === "visual") notificationsBar.setState(newNotification, newStatus)
            else if (feedback === "auditory") alertSoundEffect.play()
            else if (feedback === "tactile") phidgetFeedback.activate()
            // TODO do we need buttonAlertPerceived enabled ?
        }
        else
            console.debug("Got unexpected status in tutorial: " + newStatus)
    }

    function processForExperiment(newStatus, newNotification, feedback){
        /**
         * Function to handle state change while in experiment state
         * For warning state starts visual and one other feedback based on input
         * For nominal checks of last state was warning. then records user missed alert
         */

        if (newStatus === "off"){
            notificationsBar.setState(newNotification, newStatus)
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()
        }
        else if (newStatus === "nominal"){
            notificationsBar.setState(newNotification, newStatus)
            buttonAlertPerceived.enabled = false
            alertSoundEffect.stop()
            phidgetFeedback.deactivate()

            if (lastStatus === "warning"){
                // TODO log alert missed
            }
        }
        else if (newStatus === "warning"){
            notificationsBar.setState(newNotification, newStatus)  // Always update visual feedback
            if (feedback === "auditory") alertSoundEffect.play()
            else if (feedback === "tactile") phidgetFeedback.activate()
            buttonAlertPerceived.enabled = true
            // TODO log alert start time + type
        }
        else
            console.debug("Got unexpected status in experiment: " + newStatus)

    }


    function userOverride(){
        /**
         * Function called by buttonAlertPerceived when user aknowlegdes the alert
         */
        buttonAlertPerceived.checked = false
        buttonAlertPerceived.enabled = false

        alertSoundEffect.stop()
        phidgetFeedback.deactivate()
        notificationsBar.setState(notifications.allClearMessage, "nominal")
        // TODO log time
    }

}
