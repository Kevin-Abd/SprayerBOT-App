import QtQuick 2.10
import QtMultimedia 5.10
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.2
import LiveVehicleData 1.0
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.3
import "../UI"

Item {
    id: videos

    function play(){
        leftPlayer.play()
        frontPlayer.play()
        rightPlayer.play()
    }

    function pause(){
        leftPlayer.pause()
        frontPlayer.pause()
        rightPlayer.pause()
    }

    function stop(){
        leftPlayer.stop()
        frontPlayer.stop()
        rightPlayer.stop()
    }

    Layout.preferredWidth: parent.width /3
    Layout.preferredHeight: parent.height * 0.35

    RowLayout {
        spacing: 7
        anchors.fill: parent


        VideoPlayer {
            id: video1

            source: leftPlayer          // allows for the creation of multiple videos
            view: "Left Boom"           // video label

            MediaPlayer {
                id: leftPlayer

                source: "../media/left.mp4"
                loops: MediaPlayer.Infinite

                onPlaying: video1.state = "after"
                onStopped: video1.state = "before"
            }
        }

        VideoPlayer {
            id: video2

            source: frontPlayer
            view: "Front View"

            MediaPlayer {
                id: frontPlayer

                source: "../media/front.mp4"
                loops: MediaPlayer.Infinite

                onPlaying: video2.state = "after"
                onStopped: video2.state = "before"
            }
        }

        VideoPlayer {
            id: video3

            source: rightPlayer
            view: "Right Boom"

            MediaPlayer {
                id: rightPlayer

                source: "../media/right.mp4"
                loops: MediaPlayer.Infinite

                onPlaying: video3.state = "after"
                onStopped: video3.state = "before"
            }
        }
    }
}
