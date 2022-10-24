import QtQuick 2.12

Item{
    id: valueSource;

    property real rpm : 0;
    property real speed : 0;
    property bool start : false; // starts the animation, if true
    property bool pause : false; // pauses the animation, if true
    property real boomHeight : 20;

    // application rate control
    property int appRate1 : 0;
    property int appRate2 : 0;

    // tank level control
    property real tankLevel2 : 5;
    property real tankLevel1 : 25;

    // nozzle state control
    property string nozzle1Status : "off";
    property string nozzle2Status : "off";
    property string nozzle3Status : "off";
    property string nozzle4Status : "off";
    property string nozzle5Status : "off";
    property string nozzle6Status : "off";

    property real timeInState : 120;

    state : "warmup";
    states : [
        State { name: "warmup";      PropertyChanges { target: valueSource;  timeInState:30; }},
        State { name: "tutorial";    PropertyChanges { target: valueSource;  timeInState:60; }},
        State { name: "experiments"; PropertyChanges { target: valueSource;  timeInState:300;}},
        State { name: "finished";    PropertyChanges { target: valueSource;  timeInState:9000;}}
    ]

    Timer {
        interval: timeInState * 1000;
        running: true;
        repeat: true;
        onTriggered : changeState()
    }

    function changeState() {

        console.debug(`[changeState] current state : $ { state }`);

        if (state == "warmup") state = "tutorial";
        else if (state == "tutorial") state = "experiments";
        else if (state == "experiments") state = "finished"
    }

    Component.onCompleted : {
        var endTime = 500;
        var warmupOffsetTime = 30;

        // Speed green zone: 3-6
        // wobble around 3.9

        // Rpm green zone: 0-6
        // wobble around 2.3

        // Broom green zone: 22-28
        // wobble around 25

        var allAlerts = [
            {"type" : "speed", "time" : 2, "duration" : 4, "value" : 2.5},
            {"type" : "speed", "time" : 17, "duration" : 6, "value" : 7},
            {"type" : "broom", "time" : 25, "duration" : 7, "value" : 29},
            {"type" : "broom", "time" : 47, "duration" : 5, "value" : 29},
            {"type" : "speed", "time" : 55, "duration" : 2, "value" : 6.2},
            {"type" : "nozzel1", "time" : 70, "duration" : 7, "value" : "blocked"},
            {"type" : "nozzel4", "time" : 84, "duration" : 9, "value" : "blocked"},
        ];

        var speedAlerts = [];
        var rpmAlerts = [];
        var broomAlerts = [];

        var nozzel1Alerts = [];
        var nozzel2Alerts = [];
        var nozzel3Alerts = [];
        var nozzel4Alerts = [];
        var nozzel5Alerts = [];
        var nozzel6Alerts = [];

        for (var i = 0; i < allAlerts.length; i++) {
            var item = allAlerts[i];
            item.time += warmupOffsetTime;

            if (item.type === "speed") speedAlerts.push(item);
            else if (item.type === "broom") broomAlerts.push(item);
            else if (item.type === "rpm") rpmAlerts.push(item);
            else if (item.type === "nozzel1") nozzel1Alerts.push(item);
            else if (item.type === "nozzel2") nozzel2Alerts.push(item);
            else if (item.type === "nozzel3") nozzel3Alerts.push(item);
            else if (item.type === "nozzel4") nozzel4Alerts.push(item);
            else if (item.type === "nozzel5") nozzel5Alerts.push(item);
            else if (item.type === "nozzel6") nozzel6Alerts.push(item);
        }

        setCompAnimation(speedAlerts, wobbleSpeed, "speed", speedAnim, endTime);
        setCompAnimation(rpmAlerts, wobbleRpm, "rpm", rpmAnim, endTime);
        setCompAnimation(broomAlerts, wobbleBroom, "boomHeight", broomAnim, endTime);

        nozzelAnim1.animations = makeNozzelAnimation(nozzel1Alerts, endTime, "nozzle1Status");
        nozzelAnim2.animations = makeNozzelAnimation(nozzel2Alerts, endTime, "nozzle2Status");
        nozzelAnim3.animations = makeNozzelAnimation(nozzel3Alerts, endTime, "nozzle3Status");
        nozzelAnim4.animations = makeNozzelAnimation(nozzel4Alerts, endTime, "nozzle4Status");
        nozzelAnim5.animations = makeNozzelAnimation(nozzel5Alerts, endTime, "nozzle5Status");
        nozzelAnim6.animations = makeNozzelAnimation(nozzel6Alerts, endTime, "nozzle6Status");

        // no apprate alert for now
        setCompAnimation([], wobbleAppRate1, "appRate1", appRate1Anim, endTime);
        setCompAnimation([], wobbleAppRate2, "appRate2", appRate2Anim, endTime);
    }

    QtObject{
        id : dynamicContainer
        // A dummy object to add new objects to
    }

    ParallelAnimation {
    id: parAnim;

    running: valueSource.start;
    paused: valueSource.pause;
    loops: Animation.Infinite;

    SequentialAnimation{ id : speedAnim }
    SequentialAnimation{ id : rpmAnim }
    SequentialAnimation{ id : broomAnim }
    SequentialAnimation{ id : appRate1Anim }
    SequentialAnimation{ id : appRate2Anim }
    SequentialAnimation{ id : nozzelAnim1 }
    SequentialAnimation{ id : nozzelAnim2 }
    SequentialAnimation{ id : nozzelAnim3 }
    SequentialAnimation{ id : nozzelAnim4 }
    SequentialAnimation{ id : nozzelAnim5 }
    SequentialAnimation{ id : nozzelAnim6 }

    onPausedChanged : {
        if (valueSource.pause == true) {
            appRate1 = 0;
            appRate2 = 0;
            speed = 0;
            rpm = 0;
            nozzle1Status = "off";
            nozzle2Status = "off";
            nozzle3Status = "off";
            nozzle4Status = "off";
            nozzle5Status = "off";
            nozzle6Status = "off";
        } else {
            nozzle1Status = "on";
            nozzle2Status = "on";
            nozzle3Status = "on";
            nozzle4Status = "on";
            nozzle5Status = "on";
            nozzle6Status = "on";
        }
    }
    }

    Component {
        id: compSmoothAnim;

        SmoothedAnimation {
            // target: onj
            // property: string
            // to: value
            // duration: int
            velocity: -1;
            alwaysRunToEnd: true;
        }
    }

    Component {
        id: comptPauseAnim;

        PauseAnimation {
            // duration: int
            alwaysRunToEnd: true;
        }
    }

    Component {
    id:
        comptPropAnim;
        PropertyAnimation {
            // target: valueSource
            // property: "nozzle1Status"
            // to: "on"
        }
    }

    function makeNozzelAnimation(alerts, endTime, nozzelName) {
        /**
         * Fill a list of animation values with "on" value until endTime,
         * with alerts at specified times with specidifed values/durations
         */

        // valueArrayFromAlert
        var filled_time = 0;
        var values = [];
        alerts.sort(function(a, b) { return a.time - b.time; });

        for (var i = 0; i < alerts.length; i++) {
            var alert = alerts[i];

            // set to "on" until alert time
            if (filled_time < alert.time) {
                values.push({value : "on", duration : 0, pause : false});
                values.push({value : "on", duration : alert.time - filled_time, pause : true});
                filled_time = alert.time;
            }

            // set to alert value for duration
            values.push({value : alert.value, duration : 0, pause : false});
            values.push({value : alert.value, duration : alert.duration, pause : true});
        }

        // fill until endTime with "on"
        if (filled_time < endTime) {
            values.push({value : "on", duration : 0, pause : false});
            values.push({value : "on", duration : endTime - filled_time, pause : true});
            filled_time = endTime;
        }

        // createListOfAnimation(values, valueSource, propName)
        var listAnim = [];
        for (i = 0; i < values.length; i++) {
            var item = values[i];
            var obj;
            if (item.pause === true) {
                obj = comptPauseAnim.createObject(dynamicContainer, {"duration" : item.duration * 1000});
            } else {
                obj = comptPropAnim.createObject(dynamicContainer, {
                    "target" : valueSource,
                    "property" : nozzelName,
                    "to" : item.value,
                });
            }
            // print(`${item.value} in ${item.duration * 1000} | ${item.pause} ${nozzelName}`)
            listAnim.push(obj)
        }

        return listAnim
    }

    function setCompAnimation(alerts, wobbleFunction, propName, animComponent, endTime) {
        var values = valueArrayFromAlert(alerts, endTime, wobbleFunction);

        var anims = createListOfAnimation(values, valueSource, propName);
        animComponent.animations = anims;
    }

    function createListOfAnimation(valueArray, targetObj, targetProp) {
        /**
         * Create a list of smooth and pause animation based on provided
         * valueArray for target Object and it's target Property
         */
        var listAnim = []

            for (var i = 0; i < valueArray.length; i++) {
            var item = valueArray[i];
            var obj;

            if (item.pause === true) {
                obj = comptPauseAnim.createObject(dynamicContainer, {"duration" : item.duration * 1000});
            } else {
                obj = compSmoothAnim.createObject(dynamicContainer, {
                      "target" : targetObj,
                      "property" : targetProp,
                      "to" : item.value,
                      "duration" : item.duration * 1000
                  });
            }

            listAnim.push(obj)
            // print(`${item.value} in ${item.duration * 1000} | ${item.pause}
            // ${targetProp}`)
        }

        return listAnim
    }

    function valueArrayFromAlert(listAlerts, endTime, wobbleFunction) {
        /**
         * Fill a list of animation values with wobbleFunction until endTime,
         * with alerts at specified times with specidifed values/durations
         */

        var trans_time = 1.2;
        var pasue_time = 0.5;

        var filled_time = 0;
        var result = [];
        var tmp

            listAlerts.sort(function(a, b) { return a.time - b.time; })

                for (var i = 0; i < listAlerts.length; i++) {
            var alert = listAlerts[i]

                // fill with wobble until alert time
                while (filled_time < alert.time) {
                filled_time += trans_time + pasue_time;
                tmp = wobbleFunction();
                result.push({value : tmp, duration : trans_time, pause : false});
                result.push({value : tmp, duration : pasue_time, pause : true});
            }

            // tranistion to alert and stay for duration
            filled_time += trans_time + alert.duration;
            result.push({value : alert.value, duration : trans_time, pause : false});
            result.push({value : alert.value, duration : alert.duration, pause : true});
        }

        // fill until endTime with wobble
        while (filled_time < endTime) {
            filled_time += trans_time + pasue_time;
            tmp = wobbleFunction();
            result.push({value : tmp, duration : trans_time, pause : false});
            result.push({value : tmp, duration : pasue_time, pause : true});
        }

        return result
    }

    function randomNum(min, max, div) {
        /**
         * returen a random number between min to max (inclusive) and return
         * after dividing by div
         */
        var offset = max - min + 1;
        var val = Math.floor(Math.random() * offset) + min;
        return val / div;
    }

    function wobbleSpeed(){
        // green zone: 3-6
        // wobble around 3.9
        return randomNum(32, 46, 10)
    }

    function wobbleRpm(){
        // green zone: 0-6
        // wobble around 2.3
        return randomNum(20, 26, 10)
    }

    function wobbleBroom(){
        // green zone: 22-8
        // wobble around 25
        return randomNum(24, 26, 1)
    }

    function wobbleAppRate1(){
        // wobble around 23
        return randomNum(20, 26, 1)
    }

    function wobbleAppRate2() {
        // wobble around 20
        return randomNum(17, 26, 1)
    }
}
