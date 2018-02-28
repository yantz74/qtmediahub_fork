/** This file is part of Qt Media Hub**

Copyright (c) 2012 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation qmh-development@qt-project.org

You may use this file under the terms of the BSD license
as follows:

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Nokia Corporation and its Subsidiary(-ies)
nor the names of its contributors may be used to endorse or promote
products derived from this software without specific prior
written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. **/

import QtQuick 1.0
import QtMultimediaKit 1.1
import Playlist 1.0
import MediaModel 1.0

Window {
    id: root

    property bool vplaying: false

    function playCurrentIndex() {
        video.stop();
        video.source = posterView.currentItem.itemdata.filepath
        video.play();
        video.opacity = 1.0
        posterView.opacity = 0.0
        root.vplaying = true
    }

    function togglePlayPause()  {
        if (video.paused || video.playing) {
            if (vplaying) video.pause(); else video.play();
            vplaying = !vplaying;
        }
    }
    function playPrevious()     {
        posterView.decrementCurrentIndex()
        playCurrentIndex()
    }
    function playNext()         {
        posterView.incrementCurrentIndex()
        playCurrentIndex()
    }

    function stop() {
        video.stop();
        video.opacity = 0.0;
        posterView.opacity = 1.0;
        root.vplaying = false
    }

    MediaModel {
        id: videoModel
        mediaType: "video"
        structure: "title"
    }

    PosterView {
        id: posterView

        anchors.fill: parent
        posterModel: videoModel

        onActivated: {
            root.playCurrentIndex()
        }
    }

    Video {
        id: video
        opacity: 0.0
        focus: true
        anchors.fill: parent
        volume: 1.0

        property variant currentIndex

        onStarted: { rapid.takeOverAudio(root) }
        onResumed: { rapid.takeOverAudio(root) }
        onStopped: { videocontrol.state = "" }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: {
                videocontrol.state = "visible"
            }
        }

        onStatusChanged: if (status == Video.EndOfMedia) root.playNext()
    }

    Timer {
        id: vcTimer
        interval: 3000
        running: videocontrol.state == "visible"

        repeat: false
        onTriggered: videocontrol.state = ""
    }

    Rectangle {
        property real scalefactor: 1.6
        property real angle: -15
        id: videocontrol
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
        width: 290
        height: 60
        color: "#80404040"
        radius: 12
        scale: scalefactor

        Rectangle {
            id: processBar
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "#80106010"
            width: (video.position / video.duration) * parent.width
            height: parent.height - (width >= radius*2 ? 0 : ((radius*2)-width))
            radius: 12

            Behavior on width { NumberAnimation { duration: 100 } }
        }

        transform: Rotation { origin.x: root.width; origin.y: root.height; axis { x: 0; y: 0; z: 1 } angle: videocontrol.angle }

        states: State {
            name: "visible"
            PropertyChanges { target: videocontrol; angle: 0 }
        }

        transitions: Transition {
            NumberAnimation { property: "angle"; duration: 600; easing.type: Easing.OutElastic }
        }

        Image {
            id: vcrewind
            source: "./images/OSDRewindFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(video.playbackRate > 0.125) video.playbackRate /= 2
                }
            }
        }

        Image {
            id: vcstop
            source: "./images/OSDStopFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: vcrewind.right
            anchors.leftMargin: 20

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.stop()
                }
            }
        }

        Image {
            id: vcpause
            source: vplaying ? "./images/OSDPauseFO.png" : "./images/OSDPlayFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: vcstop.right
            anchors.leftMargin: 20

            MouseArea {
                anchors.fill: parent
                onClicked: togglePlayPause()
            }
        }

        Image {
            id: vcforward
            source: "./images/OSDForwardFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: vcpause.right
            anchors.leftMargin: 20

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(video.playbackRate < 16)  video.playbackRate *= 2
                }
            }
        }
    }

    Text {
        id: playbackRateText
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: video.playbackRate != 1

        text: video.playbackRate > 1 ? video.playbackRate+"x" : "1/"+1/video.playbackRate

        font.pixelSize: parent.height / 5
        color: "green"
    }

    Keys.onPressed: {
        if (video.paused || video.playing) {
            if (event.key == Qt.Key_Right || event.key == Qt.Key_Down) {
                video.position += 5000
            } else if (event.key == Qt.Key_Left || event.key == Qt.Key_Up) {
                video.position -= 5000
            } else if (event.key == Qt.Key_Enter) {
                root.stop()
            } else if (event.key == Qt.Key_MediaTogglePlayPause) {
                if(video.paused)
                    video.play()
                else
                    video.pause()
            }
        }
        else {
            if (event.key == Qt.Key_Right || event.key == Qt.Key_Down) {
                posterView.incrementCurrentIndex()
            } else if (event.key == Qt.Key_Left || event.key == Qt.Key_Up) {
                posterView.decrementCurrentIndex()
            } else if (event.key == Qt.Key_Enter || event.key == Qt.Key_MediaTogglePlayPause) {
                posterView.currentItem.activate()
            }
        }
    }
}
