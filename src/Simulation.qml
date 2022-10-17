import QtQuick 2.12

Item {
    id: valueSource

    property real rpm: 0
    property real speed: 0
    property bool start: false  // starts the animation, if true
    property bool pause: false  // pauses the animation, if true
    property real boomHeight: 20

    // application rate control
    property int appRate1: 0
    property int appRate2: 0

    // tank level control
    property real tankLevel2: 5
    property real tankLevel1: 25

    // nozzle state control
    property string nozzle1Status: "off"
    property string nozzle2Status: "off"
    property string nozzle3Status: "off"
    property string nozzle4Status: "off"
    property string nozzle5Status: "off"
    property string nozzle6Status: "off"

    property real timeInState: 120

    state: "warmup"
    states: [
        State {
            name: "warmup"
            PropertyChanges { target: valueSource; timeInState: 120 }
        },
        State {
            name: "tutorial"
            PropertyChanges { target: valueSource; timeInState: 60 }
        },

        // State {
        //     name: "tutorial_clear"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        // State {
        //     name: "tutorial_visual"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        // State {
        //     name: "tutorial_auditory"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        // State {
        //     name: "tutorial_tactile"
        //     PropertyChanges { target: valueSource; timeInState: 120 }
        // },
        State {
            name: "experminets"
            PropertyChanges { target: valueSource; timeInState: 300 }
        },
        State {
            name: "finished"
            PropertyChanges { target: valueSource; timeInState: 9000 }
        }
    ]

    Timer {
        interval: timeInState * 1000;
        running: true; repeat: true
        onTriggered: changeState()
    }

    function changeState() {
        if (state === "warmup")
            state = "tutorial"
        else if (state === "tutorial")
            state = "experminets"
        else if (state === "experminets")
            state = "finished"
    }

    Component.onCompleted: {
        var endTime = 120

        var speedAlerts = [
                    {"value": 1,   "duration": 2,  "time": 7},
                    {"value": 2.4, "duration": 1,  "time": 20},
                    {"value": 7,   "duration": 10, "time": 36},
                ]


        var rpmAlerts = [
                    {"value": 7,   "duration": 3,  "time": 12},
                    {"value": 10,  "duration": 6,  "time": 27},
                    {"value": 6.5, "duration": 3,  "time": 40},
                ]



        setCompAnimation(speedAlerts, wobbleSpeed, "speed", speedAnim, endTime)
        setCompAnimation(rpmAlerts, wobbleRpm, "rpm", rpmAnim, endTime)

        // setCompAnimation(boomAlerts, wobbleBroom, "boomHeight", broomAnim, endTime)
        // setCompAnimation(appRate1lerts, wobbleAppRate1, "appRate1", appRate1Anim, endTime)
        // setCompAnimation(appRate2Alerts, wobbleAppRate2, "appRate2", appRate2Anim, endTime)

        //TODO nozzel Animation

    }

    QtObject {
        id: dynamicContainer
        // A dummy object to add new objects to
    }

    ParallelAnimation {
        id: parAnim

        SequentialAnimation
        {
            id: speedAnim
        }

        SequentialAnimation
        {
            id: rpmAnim
        }

        SequentialAnimation
        {
            id: broomAnim
        }

        SequentialAnimation
        {
            id: appRate1Anim
        }

        SequentialAnimation
        {
            id: appRate2Anim
        }

        running: valueSource.start
        paused: valueSource.pause
        loops: Animation.Infinite

        onPausedChanged: {
            if (valueSource.pause == true) {
                appRate1 = 0
                appRate2 = 0
                speed = 0
                rpm = 0
                nozzle1Status = "off"
                nozzle2Status = "off"
                nozzle3Status = "off"
                nozzle4Status = "off"
                nozzle5Status = "off"
                nozzle6Status = "off"
            }
            else {
                nozzle1Status = "on"
                nozzle2Status = "on"
                nozzle3Status = "on"
                nozzle4Status = "on"
                nozzle5Status = "on"
                nozzle6Status = "on"
            }
        }
    }

    Component
    {
        id: compSmoothAnim

        SmoothedAnimation {
            //target: gauge
            //property: "value";
            //to: 0
            //duration: 0
            velocity: -1
            alwaysRunToEnd: true
        }
    }

    Component
    {
        id: comptPauseAnim
        PauseAnimation {
            //duration: 200
            alwaysRunToEnd: true
        }
    }

    function setCompAnimation(alerts, wobbleFunction, propName, animComponent, endTime){
        var values = valueArrayFromAlert(alerts, endTime, wobbleFunction)
        var anims= createListOfAnimation(values, valueSource, propName)
        animComponent.animations = anims
    }

    function createListOfAnimation(valueArray, targetObj, targetProp) {
        var listAnim = []

        for(var i = 0; i < valueArray.length; i++) {
            var item = valueArray[i]
            var obj

            if (item.pause === true){
                obj = comptPauseAnim.createObject(dynamicContainer, {
                                                      "duration": item.duration * 1000
                                                  })
            } else {
                obj = compSmoothAnim.createObject(dynamicContainer, {
                                                      "target": targetObj,
                                                      "property": targetProp,
                                                      "to": item.value,
                                                      "duration": item.duration * 1000
                                                  })
            }

            listAnim.push(obj)
            print(`${item.value} in ${item.duration * 1000} | ${item.pause} ${targetProp}`)
        }

        return listAnim
    }

    function valueArrayFromAlert(listAlerts, endTime, wobbleFunction) {
        var trans_time = 1.2
        var pasue_time = 0.5

        var filled_time = 0
        var result = [];
        var tmp

        listAlerts.sort(function(a, b) { return a.time - b.time; })

        for (var i = 0; i < listAlerts.length; i++) {
            var alert = listAlerts[i]

            // fill with wobble until alert time
            while (filled_time < alert.time){
                filled_time += trans_time + pasue_time
                tmp = wobbleFunction()
                result.push({ value: tmp, duration: trans_time, pause: false})
                result.push({ value: tmp, duration: pasue_time, pause: true })
            }

            // tranistion to alert and stay for duration
            filled_time += trans_time + alert.duration
            result.push({ value: alert.value, duration: trans_time, pause: false })
            result.push({ value: alert.value, duration: alert.duration, pause: true })
        }

        // fill until endTime with wobble
        while (filled_time < endTime){
            filled_time += trans_time + pasue_time
            tmp = wobbleFunction()
            result.push({ value: tmp, duration: trans_time, pause: false})
            result.push({ value: tmp, duration: pasue_time, pause: true })
        }

        return result
    }

    function randomNum(min, max, div){
        var offset = max - min + 1
        var val = Math.floor(Math.random() * offset) + min

        return val / div
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
        return randomNum(24, 26, 10)
    }

    function wobbleAppRate1(){
        // wobble around 23
        return randomNum(20, 26, 1)
    }

    function wobbleAppRate2(){
        // wobble around 20
        return randomNum(17, 26, 1)
    }
}
