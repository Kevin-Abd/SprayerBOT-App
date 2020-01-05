/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.10

Item {
    id: top

    property string time: "??"              // time of day for forecast
    property string weatherIcon: "01d"
    property string temperature: "22*"
    property string description: ""
    property string wind: ""                // wind speed information

    Text {
        id: timeText

        text: top.time
        font.weight: Font.DemiBold
        font.pixelSize: Math.max(9, parent.width * 0.1)
        width: top.width
        horizontalAlignment: Text.AlignHCenter

        anchors {
            top: parent.top
            topMargin: top.height / 8 - timeText.paintedHeight
            horizontalCenter: parent.horizontalCenter
        }
    }

    WeatherIcon {
        id: icon

        property real side: {
            var h = 3 * top.height / 8.5
            if (top.width < h)
                top.width;
            else
                h;
        }

        width: icon.side
        height: icon.side

        anchors {
            top: timeText.bottom
            topMargin: 10
            horizontalCenter: timeText.horizontalCenter
            horizontalCenterOffset: -25
        }

        weatherIcon: top.weatherIcon
    }

    Text {
        id: weatherDescription

        text: top.description
        font.pixelSize: Math.max(8, parent.width * 0.085)
        font.weight: Font.DemiBold
        font.letterSpacing: 0.75
        width: parent.width - 15
        wrapMode: Text.WordWrap

        anchors {
            top: icon.bottom
            left: icon.left
            topMargin: -2.5
            leftMargin: 2.5
        }
    }

    Text {
        id: tempText

        text: top.temperature
        font.bold: true
        font.pixelSize: Math.max(12, parent.width * 0.125)

        anchors {
            verticalCenter: icon.verticalCenter
            left: icon.right
            leftMargin: 5
        }
    }

    Item {
        id: windInfo

        width: parent.width
        height: parent.height * 0.25

        anchors {
            top: weatherDescription.bottom
            topMargin: 7.5
            left: weatherDescription.left
        }


        RowLayout {
            anchors.fill: parent

            Image {
                id: windSpeedIcon

                source: "../media/icons8-wind-64.png"
                Layout.preferredHeight: parent.height * 0.5
                Layout.preferredWidth: parent.width * 0.1
                asynchronous: true
            }

            Text {
                id: windSpeedText

                text: top.wind
                font.weight: Font.DemiBold
                font.pixelSize: Math.max(8, parent.width * 0.085)
            }
        }
    }
}
