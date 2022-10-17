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

    //    SequentialAnimation {
    //        running: valueSource.start
    //        paused: valueSource.pause
    //        loops: Animation.Infinite

    //        onPausedChanged: {
    //            if (valueSource.pause == true) {
    //                appRate1 = 0
    //                appRate2 = 0
    //                speed = 0
    //                rpm = 0
    //                nozzle1Status = "off"
    //                nozzle2Status = "off"
    //                nozzle3Status = "off"
    //                nozzle4Status = "off"
    //                nozzle5Status = "off"
    //                nozzle6Status = "off"
    //            }
    //            else {
    //                nozzle1Status = "on"
    //                nozzle2Status = "on"
    //                nozzle3Status = "on"
    //                nozzle4Status = "on"
    //                nozzle5Status = "on"
    //                nozzle6Status = "on"
    //            }
    //        }

    //        SequentialAnimation {
    //            // set all elements to their initial position
    //            ParallelAnimation {
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "rpm"
    //                    from: 0
    //                    to: 1.2
    //                    velocity: -1
    //                    duration: 500
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "boomHeight"
    //                    to: 30
    //                    velocity: -1
    //                    duration: 4000
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "tankLevel1"
    //                    to: 23
    //                    velocity: -1
    //                    duration: 4000
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "tankLevel2"
    //                    to: 4.5
    //                    velocity: -1
    //                    duration: 4000
    //                }
    //            }

    //            // Wait for the machine to start moving
    //            PauseAnimation {
    //                duration: 7000
    //            }

    //            //! [1] first pass
    //            ParallelAnimation {
    //                // wobble speed
    //                SequentialAnimation {
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.2
    //                        velocity: -1
    //                        duration: 3000
    //                    }

    //                    PauseAnimation {
    //                        duration: 2000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.3
    //                        velocity: -1
    //                        duration: 2000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.4
    //                        velocity: -1
    //                        duration: 2000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.5
    //                        velocity: -1
    //                        duration: 5000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.4
    //                        velocity: -1
    //                        duration: 10000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.3
    //                        velocity: -1
    //                        duration: 10000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.2
    //                        velocity: -1
    //                        duration: 20000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.3
    //                        velocity: -1
    //                        duration: 10000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.2
    //                        velocity: -1
    //                        duration: 15000
    //                    }
    //                } // End wobble speed

    //                // wobble rpm
    //                SequentialAnimation {
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.1
    //                        velocity: -1
    //                        duration: 1500
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.3
    //                        velocity: -1
    //                        duration: 6000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.5
    //                        velocity: -1
    //                        duration: 2000
    //                    }

    //                    PauseAnimation {
    //                        duration: 2000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.6
    //                        velocity: -1
    //                        duration: 1000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.2
    //                        velocity: -1
    //                        duration: 20000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.3
    //                        velocity: -1
    //                        duration: 20000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.1
    //                        velocity: -1
    //                        duration: 5000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.3
    //                        velocity: -1
    //                        duration: 15000
    //                    }
    //                } // end wobble rpm

    //                // wobble boom height
    //                SequentialAnimation {
    //                    // boom down
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 25
    //                        velocity: -1
    //                        duration: 5000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom up
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 26
    //                        velocity: -1
    //                        duration: 25000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom down
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 25
    //                        velocity: -1
    //                        duration: 20000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom up
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 24.5
    //                        velocity: -1
    //                        duration: 20000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom down
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 26
    //                        velocity: -1
    //                        duration: 23000
    //                        alwaysRunToEnd: true
    //                    }
    //                } // end wobble boom height

    //                // turn on sprayer and wobble application rate
    //                SequentialAnimation {
    //                    PauseAnimation {
    //                        duration: 5000
    //                    }

    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "tankLevel1"
    //                            to: 14
    //                            velocity: -1
    //                            duration: 90000
    //                            alwaysRunToEnd: true
    //                        }
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "tankLevel2"
    //                            to: 3.2
    //                            velocity: -1
    //                            duration: 90000
    //                            alwaysRunToEnd: true
    //                        }

    //                        // wobble application rate
    //                        SequentialAnimation {
    //                            ParallelAnimation {
    //                                SmoothedAnimation {
    //                                    target: valueSource
    //                                    property: "appRate1"
    //                                    to: 25
    //                                    velocity: -1
    //                                    duration: 20
    //                                }
    //                                SmoothedAnimation {
    //                                    target: valueSource
    //                                    property: "appRate2"
    //                                    to: 20
    //                                    velocity: -1
    //                                    duration: 20
    //                                }
    //                            }

    //                            ParallelAnimation {
    //                                SmoothedAnimation {
    //                                    target: valueSource
    //                                    property: "appRate1"
    //                                    to: 21
    //                                    velocity: -1
    //                                    duration: 30000
    //                                }
    //                                SmoothedAnimation {
    //                                    target: valueSource
    //                                    property: "appRate2"
    //                                    to: 17
    //                                    velocity: -1
    //                                    duration: 30000
    //                                }
    //                            }

    //                            ParallelAnimation {
    //                                SmoothedAnimation {
    //                                    target: valueSource
    //                                    property: "appRate1"
    //                                    to: 26
    //                                    velocity: -1
    //                                    duration: 30000
    //                                }
    //                                SmoothedAnimation {
    //                                    target: valueSource
    //                                    property: "appRate2"
    //                                    to: 21
    //                                    velocity: -1
    //                                    duration: 30000
    //                                }
    //                            }
    //                        } // end wobble application rate

    //                        PropertyAnimation {
    //                            target: valueSource
    //                            property: "nozzle1Status"
    //                            to: "on"
    //                        }
    //                        PropertyAnimation {
    //                            target: valueSource
    //                            property: "nozzle2Status"
    //                            to: "on"
    //                        }
    //                        PropertyAnimation {
    //                            target: valueSource
    //                            property: "nozzle3Status"
    //                            to: "on"
    //                        }
    //                        PropertyAnimation {
    //                            target: valueSource
    //                            property: "nozzle4Status"
    //                            to: "on"
    //                        }
    //                        PropertyAnimation {
    //                            target: valueSource
    //                            property: "nozzle5Status"
    //                            to: "on"
    //                        }
    //                        PropertyAnimation {
    //                            target: valueSource
    //                            property: "nozzle6Status"
    //                            to: "on"
    //                        }
    //                    }
    //                }
    //            }
    //            //! [1]

    //            //! [2] at the turn
    //            ParallelAnimation {
    //                SequentialAnimation {
    //                    // slow down
    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "speed"
    //                            to: 2.7
    //                            velocity: -1
    //                            duration: 4000
    //                        }

    //                        SequentialAnimation {
    //                            SmoothedAnimation {
    //                                target: valueSource
    //                                property: "rpm"
    //                                to: 1.8
    //                                velocity: -1
    //                                duration: 1000
    //                            }

    //                            SmoothedAnimation {
    //                                target: valueSource
    //                                property: "rpm"
    //                                to: 2.0
    //                                velocity: -1
    //                                duration: 500
    //                            }

    //                            SmoothedAnimation {
    //                                target: valueSource
    //                                property: "rpm"
    //                                to: 1.8
    //                                velocity: -1
    //                                duration: 500
    //                            }
    //                        }
    //                    }

    //                    PauseAnimation {
    //                        duration: 1000
    //                    }

    //                    // speed up
    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "speed"
    //                            to: 3.7
    //                            velocity: -1
    //                            duration: 4000
    //                        }
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "rpm"
    //                            to: 2.5
    //                            velocity: -1
    //                            duration: 1000
    //                        }
    //                    }

    //                    PauseAnimation {
    //                        duration: 2000
    //                    }

    //                    // slow down
    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "speed"
    //                            to: 3.3
    //                            velocity: -1
    //                            duration: 4000
    //                        }
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "rpm"
    //                            to: 2
    //                            velocity: -1
    //                            duration: 1500
    //                        }
    //                    }
    //                }

    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "tankLevel1"
    //                    to: 13
    //                    velocity: -1
    //                    duration: 5000
    //                    alwaysRunToEnd: true
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "tankLevel2"
    //                    to: 2.6
    //                    velocity: -1
    //                    duration: 5000
    //                    alwaysRunToEnd: true
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "appRate1"
    //                    to: 22
    //                    velocity: -1
    //                    duration: 5000
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "appRate2"
    //                    to: 23
    //                    velocity: -1
    //                    duration: 5000
    //                }
    //            }
    //            //! [2]

    //            //! [3] Return - 91 seconds
    //            ParallelAnimation {
    //                SequentialAnimation {
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.1
    //                        velocity: -1
    //                        duration: 5000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.3
    //                        velocity: -1
    //                        duration: 20000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.1
    //                        velocity: -1
    //                        duration: 20000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.3
    //                        velocity: -1
    //                        duration: 10000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 3.1
    //                        velocity: -1
    //                        duration: 15000
    //                    }
    //                } // End wobble speed

    //                SequentialAnimation {
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.1
    //                        velocity: -1
    //                        duration: 2000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.3
    //                        velocity: -1
    //                        duration: 2000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2
    //                        velocity: -1
    //                        duration: 5000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.2
    //                        velocity: -1
    //                        duration: 20000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.3
    //                        velocity: -1
    //                        duration: 20000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.1
    //                        velocity: -1
    //                        duration: 5000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 2.3
    //                        velocity: -1
    //                        duration: 15000
    //                    }
    //                } // end wobble rpm

    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "tankLevel1"
    //                    to: 5.3
    //                    velocity: -1
    //                    duration: 90000
    //                    alwaysRunToEnd: true
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "tankLevel2"
    //                    to: 0.5
    //                    velocity: -1
    //                    duration: 90000
    //                    alwaysRunToEnd: true
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "appRate1"
    //                    to: 25
    //                    velocity: -1
    //                    duration: 10000
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "appRate2"
    //                    to: 20
    //                    velocity: -1
    //                    duration: 10000
    //                }

    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle1Status"
    //                    to: "on"
    //                }

    //                SequentialAnimation {
    //                    // boom down
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 25
    //                        velocity: -1
    //                        duration: 5000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom up
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 26
    //                        velocity: -1
    //                        duration: 25000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom down
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 25
    //                        velocity: -1
    //                        duration: 20000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom up
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 24
    //                        velocity: -1
    //                        duration: 20000
    //                        alwaysRunToEnd: true
    //                    }
    //                    // boom down
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "boomHeight"
    //                        to: 26
    //                        velocity: -1
    //                        duration: 20000
    //                        alwaysRunToEnd: true
    //                    }// end wobble boom height
    //                }

    //                // wobble application rate
    //                SequentialAnimation {
    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "appRate1"
    //                            to: 20
    //                            velocity: -1
    //                            duration: 20
    //                        }
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "appRate2"
    //                            to: 22
    //                            velocity: -1
    //                            duration: 20
    //                        }
    //                    }
    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "appRate1"
    //                            to: 24
    //                            velocity: -1
    //                            duration: 30000
    //                        }
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "appRate2"
    //                            to: 20
    //                            velocity: -1
    //                            duration: 30000
    //                        }
    //                    }
    //                    ParallelAnimation {
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "appRate1"
    //                            to: 21
    //                            velocity: -1
    //                            duration: 30000
    //                        }
    //                        SmoothedAnimation {
    //                            target: valueSource
    //                            property: "appRate2"
    //                            to: 24
    //                            velocity: -1
    //                            duration: 30000
    //                        }
    //                    }
    //                } // end wobble application rate
    //            }

    //            //! [3]
    //            //! [4] Stop
    //            ParallelAnimation {
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "appRate1"
    //                    to: 0
    //                    velocity: -1
    //                    duration: 20
    //                }
    //                SmoothedAnimation {
    //                    target: valueSource
    //                    property: "appRate2"
    //                    to: 0
    //                    velocity: -1
    //                    duration: 20
    //                }
    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle1Status"
    //                    to: "off"
    //                }
    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle2Status"
    //                    to: "off"
    //                }
    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle3Status"
    //                    to: "off"
    //                }
    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle4Status"
    //                    to: "off"
    //                }
    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle5Status"
    //                    to: "off"
    //                }
    //                PropertyAnimation {
    //                    target: valueSource
    //                    property: "nozzle6Status"
    //                    to: "off"
    //                }
    //            }

    //            PauseAnimation {
    //                duration: 1000
    //            }

    //            ParallelAnimation {
    //                SequentialAnimation {
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 1.2
    //                        velocity: -1
    //                        duration: 4000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 1.4
    //                        velocity: -1
    //                        duration: 8000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 0.8
    //                        velocity: -1
    //                        duration: 6000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 1
    //                        velocity: -1
    //                        duration: 3000
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 0.6
    //                        velocity: -1
    //                        duration: 4000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "speed"
    //                        to: 0
    //                        velocity: -1
    //                        duration: 2000
    //                    }
    //                }
    //                SequentialAnimation {
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.3
    //                        velocity: -1
    //                        duration: 1000
    //                    }


    //                    PauseAnimation {
    //                        duration: 3000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.9
    //                        velocity: -1
    //                        duration: 500
    //                    }
    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.7
    //                        velocity: -1
    //                        duration: 500
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.5
    //                        velocity: -1
    //                        duration: 4000
    //                    }

    //                    PauseAnimation {
    //                        duration: 4000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.2
    //                        velocity: -1
    //                        duration: 3000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.4
    //                        velocity: -1
    //                        duration: 1000
    //                    }


    //                    PauseAnimation {
    //                        duration: 7000
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.7
    //                        velocity: -1
    //                        duration: 500
    //                    }

    //                    SmoothedAnimation {
    //                        target: valueSource
    //                        property: "rpm"
    //                        to: 1.2
    //                        velocity: -1
    //                        duration: 500
    //                    }
    //                }// end wobble rpm
    //            }


    //            PauseAnimation {
    //                duration: 1000
    //            }
    //            //! [4]
    //        }
    //    }
}
