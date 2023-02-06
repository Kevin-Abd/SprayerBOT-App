import QtQuick 2.12

Item{
    id: valueSource;

    property real rpm : 0;
    property real speed : 0;
    property real broomHeight : 20;

    // application rate control
    property int appRate1 : 0;
    property int appRate2 : 0;

    // tank level control
    property real tankLevel1 : 25;
    property real tankLevel2 : 5;

    // nozzle state control
    property string nozzle1Status : "off";
    property string nozzle2Status : "off";
    property string nozzle3Status : "off";
    property string nozzle4Status : "off";
    property string nozzle5Status : "off";
    property string nozzle6Status : "off";

    // special alert for tutorial
    property string tutorialAlert : "NA";

    property real timeInState;

    readonly property real warmupTime: 120;
    readonly property real tutorialTime: 60;
    readonly property real experimentPhase1Time: 115;
    readonly property real experimentPhase2Time: 115;

    state : "warmup";
    states : [
        State { name: "warmup";        PropertyChanges { target: valueSource;  timeInState: warmupTime; }},
        State { name: "tutorial";      PropertyChanges { target: valueSource;  timeInState: tutorialTime; }},
        State { name: "experiments_1"; PropertyChanges { target: valueSource;  timeInState: experimentPhase1Time; }},
        State { name: "experiments_2"; PropertyChanges { target: valueSource;  timeInState: experimentPhase2Time; }},
        State { name: "finished";      PropertyChanges { target: valueSource;  timeInState: 9000; }}
    ]

    Timer {
        id: stateTimer

        interval: timeInState * 1000;
        running: false;
        repeat: false;
        triggeredOnStart: false;
        onTriggered : changeState()
    }

    function start() {
        stateTimer.start()
        parAnim.start()
    }

    function pause() {
        stateTimer.pause()
        parAnim.pause()
    }

    function stop() {
        stateTimer.stop()
        parAnim.stop()
    }


    function changeState() {
        if (state == "warmup") state = "tutorial";
        else if (state == "tutorial") state = "experiments_1";
        else if (state == "experiments_1") state = "experiments_2"
        else if (state == "experiments_2") state = "finished"
        stateTimer.start()
    }

    Component.onCompleted : {
        var endTime = warmupTime + tutorialTime + experimentPhase1Time + experimentPhase2Time;

        var tutorialAlerts = [
                    {"time" : 5,  "duration" : 5, "value" : "visual"},
                    {"time" : 15, "duration" : 5, "value" : "auditory"},
                    {"time" : 25, "duration" : 5, "value" : "tactile"},
                    {"time" : 35, "duration" : 5, "value" : "visual_auditory"},
                    {"time" : 45, "duration" : 5, "value" : "visual_tactile"},
                ];

        // Speed green zone: 3-6 (Wobble 3.9)
        // Rpm green zone: 0-6 (Wobble 2.3)
        // Broom green zone: 22-28 (Wobble 25)

        // Tank 1 alert zone: 0-6.25 (6.25-11.25 yellow)
        // Tank 2 alert zone: 0-1.25 (1.25-2.25 yellow)

        // Value overrides in the begginings to sync values with the video
        var syncTime = - (warmupTime + tutorialTime + 1)
        var syncAlerts = [
                    {"type" : "speed",   "time" : syncTime, "duration" : 10, "value" : 0},
                    {"type" : "rpm",     "time" : syncTime, "duration" : 10, "value" : 0},
                    {"type" : "broom",   "time" : syncTime, "duration" : 15, "value" : 20},
                    {"type" : "app1",    "time" : syncTime, "duration" : 15, "value" : 0},
                    {"type" : "app2",    "time" : syncTime, "duration" : 15, "value" : 0},
                    {"type" : "tank1",   "time" : syncTime + 1.1, "duration" : warmupTime + tutorialTime, "value" : 25},
                    {"type" : "tank2",   "time" : syncTime + 1.1, "duration" : warmupTime + tutorialTime, "value" : 5},
                    {"type" : "nozzel1", "time" : syncTime, "duration" : 15, "value" : "off"},
                    {"type" : "nozzel2", "time" : syncTime, "duration" : 15, "value" : "off"},
                    {"type" : "nozzel3", "time" : syncTime, "duration" : 15, "value" : "off"},
                    {"type" : "nozzel4", "time" : syncTime, "duration" : 15, "value" : "off"},
                    {"type" : "nozzel5", "time" : syncTime, "duration" : 15, "value" : "off"},
                    {"type" : "nozzel6", "time" : syncTime, "duration" : 15, "value" : "off"},
                ]

        // Values to cause alerts in the experiment phase
        // type: which value to change
        //          speed, rpm, broom, app1, app2, tank1, tank2, nozzel1 - nozzel6
        // time: the time for the value to take effect in the experiment phase (in seconds)
        // duration: the duration time when the value stays the same
        // value: the new value
        var experimentPhase1Alerts = [
                    {"type" : "speed",   "time" : 20,  "duration" : 4, "value" : 2.5},
                    {"type" : "speed",   "time" : 40,  "duration" : 5, "value" : 7},
                    {"type" : "broom",   "time" : 65,  "duration" : 3, "value" : 29},
                    {"type" : "broom",   "time" : 83,  "duration" : 5, "value" : 21},
                    {"type" : "speed",   "time" : 102, "duration" : 2, "value" : 6.2},
                ]

        var experimentPhase2Alerts = [
                    {"type" : "tank2",   "time" : 15, "duration" : 5, "value" : 1},
                    {"type" : "nozzel1", "time" : 34, "duration" : 7, "value" : "blocked"},
                    {"type" : "nozzel4", "time" : 49, "duration" : 9, "value" : "blocked"},
                    {"type" : "rpm",     "time" : 72, "duration" : 5, "value" : 7},
                    {"type" : "tank1",   "time" : 91, "duration" : 5, "value" : 6},
                ];



        // offset the start time Phase2 to after Phase 1
        for (var i = 0; i < experimentPhase2Alerts.length; i++)
            experimentPhase2Alerts[i].time += experimentPhase1Time;

        var experimentAlerts = [...syncAlerts, ...experimentPhase1Alerts, ...experimentPhase2Alerts]
        setTutorialAlerts(tutorialAlerts, endTime)
        setExperimentAlerts(experimentAlerts, endTime)
    }

    function setTutorialAlerts(tutorialAlerts, endTime) {

        var filled_time = 0;
        var listAnim = [];
        var obj1;
        var obj2;

        tutorialAlerts.sort(function(a, b) { return a.time - b.time; });

        for (var i = 0; i < tutorialAlerts.length; i++) {
            var alert = tutorialAlerts[i];
            // offset the start time to after start of tutorial
            alert.time += warmupTime

            // set to "NA" until alert time
            if (filled_time < alert.time) {

                obj1 = createPropAnimation(valueSource, "tutorialAlert", "NA");
                obj2 = createPauseAnimation(alert.time - filled_time);

                listAnim.push(obj1)
                listAnim.push(obj2)

                filled_time = alert.time;
            }

            // set to alert value for duration
            obj1 = createPropAnimation(valueSource, "tutorialAlert", alert.value);
            obj2 = createPauseAnimation(alert.duration);

            listAnim.push(obj1)
            listAnim.push(obj2)

            filled_time += alert.duration;
        }

        // fill until endTime with "NA"
        if (filled_time < endTime) {
            obj1 = createPropAnimation(valueSource, "tutorialAlert", "NA");
            obj2 = createPauseAnimation(endTime - filled_time);

            listAnim.push(obj1)
            listAnim.push(obj2)
            filled_time = endTime;
        }
        tutorialAnim.animations = listAnim
    }

    function setExperimentAlerts(experimentAlerts, endTime) {
        var speedAlerts = [];
        var rpmAlerts = [];
        var broomAlerts = [];
        var apprate1Alerts = [];
        var apprate2Alerts = [];
        var tank1Alerts = [];
        var tank2Alerts = [];

        var nozzel1Alerts = [];
        var nozzel2Alerts = [];
        var nozzel3Alerts = [];
        var nozzel4Alerts = [];
        var nozzel5Alerts = [];
        var nozzel6Alerts = [];

        for (var i = 0; i < experimentAlerts.length; i++) {
            var item = experimentAlerts[i];
            // offset the start time to after start of experiment
            item.time += warmupTime + tutorialTime

            if (item.type === "speed") speedAlerts.push(item);
            else if (item.type === "broom") broomAlerts.push(item);
            else if (item.type === "app1") apprate1Alerts.push(item);
            else if (item.type === "app2") apprate2Alerts.push(item);
            else if (item.type === "rpm") rpmAlerts.push(item);
            else if (item.type === "tank1") tank1Alerts.push(item);
            else if (item.type === "tank2") tank2Alerts.push(item);
            else if (item.type === "nozzel1") nozzel1Alerts.push(item);
            else if (item.type === "nozzel2") nozzel2Alerts.push(item);
            else if (item.type === "nozzel3") nozzel3Alerts.push(item);
            else if (item.type === "nozzel4") nozzel4Alerts.push(item);
            else if (item.type === "nozzel5") nozzel5Alerts.push(item);
            else if (item.type === "nozzel6") nozzel6Alerts.push(item);
        }

        speedAnim.animations = makeNumberAnimation(speedAlerts, wobbleSpeed, "speed", endTime);
        rpmAnim.animations = makeNumberAnimation(rpmAlerts, wobbleRpm, "rpm", endTime);
        broomAnim.animations = makeNumberAnimation(broomAlerts, wobbleBroom, "broomHeight", endTime);

        tank1Anim.animations = makeTankAnimation(tank1Alerts, endTime, 25, "tankLevel1")
        tank2Anim.animations = makeTankAnimation(tank2Alerts, endTime, 5, "tankLevel2")

        nozzelAnim1.animations = makeNozzelAnimation(nozzel1Alerts, endTime, "nozzle1Status");
        nozzelAnim2.animations = makeNozzelAnimation(nozzel2Alerts, endTime, "nozzle2Status");
        nozzelAnim3.animations = makeNozzelAnimation(nozzel3Alerts, endTime, "nozzle3Status");
        nozzelAnim4.animations = makeNozzelAnimation(nozzel4Alerts, endTime, "nozzle4Status");
        nozzelAnim5.animations = makeNozzelAnimation(nozzel5Alerts, endTime, "nozzle5Status");
        nozzelAnim6.animations = makeNozzelAnimation(nozzel6Alerts, endTime, "nozzle6Status");

        appRate1Anim.animations = makeNumberAnimation(apprate1Alerts, wobbleAppRate1, "appRate1", endTime);
        appRate2Anim.animations = makeNumberAnimation(apprate2Alerts, wobbleAppRate2, "appRate2", endTime);
    }

    function makeTankAnimation(alerts, endTime, fillValue, tankName) {
        /**
         * Fill a list of animation values for tank level,
         */

        // Step 1: Value Array From Alerts
        var tank_refill_time = 3;
        var filled_time = 0;
        var values = [];
        alerts.sort(function(a, b) { return a.time - b.time; });

        for (var i = 0; i < alerts.length; i++) {
            var alert = alerts[i];
            // add decreasing animatoin to reach alert value at alert.time
            // then pause for duration, then fill tank
            values.push({value : alert.value, duration : alert.time - filled_time, pause : false});
            values.push({value : alert.value, duration : alert.duration, pause : true});
            values.push({value : fillValue,   duration : tank_refill_time, pause : false});
            filled_time = alert.time + alert.duration + tank_refill_time;
        }

        // refill and pause animation for the remaining time
        if (filled_time < endTime) {
            values.push({value : fillValue, duration : tank_refill_time, pause : false});
            values.push({value : fillValue, duration : endTime-filled_time, pause : true});
            filled_time = endTime;
        }

        // Step 2: Create Animation List
        var listAnim = [];
        for (i = 0; i < values.length; i++) {
            var item = values[i];
            var obj;
            if (item.pause === true) {
                obj = createPauseAnimation(item.duration);
            } else {
                console.assert(item.duration >= 0, `!! ${tankName}: ${item.value}, ${item.duration}`);
                obj = createNumberAnimation(valueSource, tankName, item.value, item.duration);
            }
            listAnim.push(obj)
        }
        return listAnim
    }

    function makeNozzelAnimation(alerts, endTime, nozzelName) {
        /**
         * Fill a list of animation values with "on" value until endTime,
         * with alerts at specified times with specidifed values/durations
         */

        // Step 1: Value Array From Alerts
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

            filled_time += alert.duration;
        }

        // fill until endTime with "on"
        if (filled_time < endTime) {
            values.push({value : "on", duration : 0, pause : false});
            values.push({value : "on", duration : endTime - filled_time, pause : true});
            filled_time = endTime;
        }

        // Step 2: Create Animation List
        var listAnim = [];
        for (i = 0; i < values.length; i++) {
            var item = values[i];
            var obj;
            if (item.pause === true) {
                obj = createPauseAnimation(item.duration);
            } else {
                obj = createPropAnimation(valueSource, nozzelName, item.value)
            }
            listAnim.push(obj)
        }
        return listAnim
    }

    function makeNumberAnimation(listAlerts, wobbleFunction, targetProp, endTime) {
        /**
         * Create a list of number and pause animations based on provided
         * alerts and wobbleFunction until endTime.
         * Alerts happen at specified times with specidifed values/durations
         * alerts must have "time", "value" and "duration" properties
         */

        // Step 1: Value Array From Alerts
        var trans_time = 2.2;
        var pause_time = 0.8;
        var last_value = -1;

        var filled_time = 0;
        var valueArray = [];
        var tmp;
        var targetObj = valueSource

        listAlerts.sort(function(a, b) { return a.time - b.time; })

        for (var i = 0; i < listAlerts.length; i++) {
            var alert = listAlerts[i]

            // fill with wobble until alert time
            while (filled_time < alert.time) {
                tmp = wobbleFunction();
                if (tmp === last_value) {
                    valueArray.push({value : tmp, duration : trans_time + pause_time, pause : true});
                } else {
                    valueArray.push({value : tmp, duration : trans_time, pause : false});
                    valueArray.push({value : tmp, duration : pause_time, pause : true});
                }
                last_value = tmp
                filled_time += trans_time + pause_time;
            }
            // transition to alert and stay for duration
            filled_time += trans_time + alert.duration;
            valueArray.push({value : alert.value, duration : trans_time, pause : false});
            valueArray.push({value : alert.value, duration : alert.duration, pause : true});
            last_value = alert.value
        }

        // fill until endTime with wobble
        while (filled_time < endTime) {
            tmp = wobbleFunction()
            if (tmp === last_value) {
                valueArray.push({value : tmp, duration : trans_time + pause_time, pause : true});
            } else {
                valueArray.push({value : tmp, duration : trans_time, pause : false});
                valueArray.push({value : tmp, duration : pause_time, pause : true});
            }
            last_value = tmp
            filled_time += trans_time + pause_time;
        }
        //console.log(targetProp, SON.stringify(valueArray), "\n\n")

        // Step 2: Create Animation List
        var listAnim = []

        for (i = 0; i < valueArray.length; i++) {
            var item = valueArray[i];
            var obj;

            if (item.pause === true) {
                obj = createPauseAnimation(item.duration);
            } else {
                console.assert(item.duration >= 0, `!! ${targetProp}: ${item.value}`);
                obj = createNumberAnimation(targetObj, targetProp, item.value, item.duration);
            }
            listAnim.push(obj)
        }
        return listAnim

    }


    function createPropAnimation(target, propName, to) {
        return comptPropAnim.createObject(
                    dynamicContainer,
                    {
                        "target" : target,
                        "property" : propName,
                        "to" : to,
                    });
    }

    function createPauseAnimation(durationSec) {
        return comptPauseAnim.createObject(
                    dynamicContainer,
                    {
                        "duration" : durationSec * 1000
                    });
    }

    function createNumberAnimation(target, propName, to, durationSec) {
        return compNumberAnim.createObject(
                    dynamicContainer,
                    {
                        "target" : target,
                        "property" : propName,
                        "to" : to,
                        "duration" : durationSec * 1000
                    });
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

    QtObject{
        id : dynamicContainer
        // A dummy object to add new objects to
    }

    ParallelAnimation {
        id: parAnim;

        loops: 1;

        SequentialAnimation{ id : speedAnim }
        SequentialAnimation{ id : rpmAnim }
        SequentialAnimation{ id : broomAnim }
        SequentialAnimation{ id : tank1Anim }
        SequentialAnimation{ id : tank2Anim }
        SequentialAnimation{ id : appRate1Anim }
        SequentialAnimation{ id : appRate2Anim }
        SequentialAnimation{ id : nozzelAnim1 }
        SequentialAnimation{ id : nozzelAnim2 }
        SequentialAnimation{ id : nozzelAnim3 }
        SequentialAnimation{ id : nozzelAnim4 }
        SequentialAnimation{ id : nozzelAnim5 }
        SequentialAnimation{ id : nozzelAnim6 }
        SequentialAnimation{ id : tutorialAnim }


        onRunningChanged: {
            if (running == false) {
                appRate1 = 0;
                appRate2 = 0;
                speed = 0;
                rpm = 0;
                broomHeight = 0;
                tankLevel1 = 0;
                tankLevel2 = 0;
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
        id: compNumberAnim;

        NumberAnimation {
            // target: onj
            // property: string
            // to: value
            // duration: int
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
}
