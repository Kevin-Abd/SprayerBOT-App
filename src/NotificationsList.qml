import QtQuick 2.0


QtObject{
    property var list_instruction: {
        "start":   { code: "001",  message : "To begin, press and hold the START button."},
        "restart": { code: "002",  message : "Press and hold the START button to start the machine"},
        "normal":  { code: "003",  message : "All systems are normal"},
        "end":     { code: "004",  message : "The simulation has finished"},

    }

    function setSpecial(mode){
        if (mode === "start")
            list.setSingle(list_instruction["start"].code ,list_instruction["start"].message, "off");
        else if (mode === "stopped")
            list.setSingle(list_instruction["restart"].code, list_instruction["restart"].message, "off");
        else if (mode === "clear")
            list.clear();
        else if (mode === "end") {
            list.setSingle(list_instruction["end"].code, list_instruction["end"].message, "off");
        }

        statusManager.checkForNewStatus()
    }

    function setTutorial(type, alert){
        // set status message with visual blanked out
        if(type === "tactile" || type === "auditory")
            list.setSingle(alert.code, alert.message, "blank");
        else
            list.setSingle(alert.code, alert.message, "warning");

        statusManager.checkForNewStatus()
    }

    function addWarning(alert) {
        if (list.index(alert.code) === -1) {
            list.add(alert.code, alert.message, "warning");
            statusManager.checkForNewStatus();
        }
    }

    function removeWarning(alert) {
        var res = list.removeIfpresent(alert.code);
        if (res === true)
            statusManager.checkForNewStatus();
    }

    function getUnprocessed(){
        return list.getUnprocessed();
    }

    function setProccessed(code){
        return list.process(code);
    }


    property ListModel list : ListModel {

        //    id: notificationsList

        ListElement {
            message: "To begin, press and hold the START button.";
            code: "001";
            status: "off";
            processed: false;
        }

        function setSingle(code, message, status) {
            clear();
            set(0, {code : code, message : message, status : status, processed : false});
        }

        function add(code, message, status) {
            append({code : code, message : message, status : status, processed : false});
        }

        function removeIfpresent(code) {
            for (var i = 0; i < count; i++)
                if (get(i).code === code) {
                    remove(i);
                    return true;
                }
            return false;
        }

        function index(code) {
            for (var i = 0; i < count; i++)
                if (get(i).code === code)
                    return i;
            return -1;
        }

        function getUnprocessed() {
            for (var i = 0; i < count; i++)
                if (get(i).processed === false)
                    return get(i);
            return null;
        }

        function process(code) {
            var idx = index(code);
            if (idx === -1) {
                console.log("[Warn]", `Attempted process non existant alert(code : ${code})`);
                return;
            }
            set(idx, {processed : true});
        }
    }
}
