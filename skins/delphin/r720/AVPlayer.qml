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
import QtMediaHub.components.media 1.0
import AbstractMediaPlayer 1.0

//This serves to isolate import failures if QtMultimedia is not present
QMHPlayer {
    id: root

    property bool showAudioOSD : true

    function playForeground(mediaModel, row) {
        root.play(mediaModel, row)
        delphin.show(this)
    }

    function playBackground(mediaModel, row) {
        root.play(mediaModel, row);
        root.state = "background";
    }

    anchors.fill: parent

    states: [
        State {
            name: "background"
            PropertyChanges {
                target: root
                opacity: 1
                z: hasMedia && playing ? delphin.layerAVPlayer : delphin.layerBackground-1
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: root
                opacity: 0
                z: delphin.layerBackground-1
            }
        },
        State {
            name: "maximized"
            PropertyChanges {
                target: root
                opacity: 1
                z: delphin.layerAVPlayer
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "opacity"; duration: 350; easing.type: Easing.InQuad }
            NumberAnimation { properties: "x,y,width,height"; duration: 350; easing.type: Easing.InQuad }
            PropertyAnimation { target: infoOSD; property: "state"; to: "" }
        }
    ]

    Keys.onUpPressed: playPrevious();
    Keys.onDownPressed: playNext();
    Keys.onRightPressed: seekForward();
    Keys.onLeftPressed: seekBackward();
    Keys.onEnterPressed: togglePlayPause();
    Keys.onSpacePressed: togglePlayPause();

    Rectangle {
        id: backgroundFiller
        anchors.fill: parent
        color: "black"
        z: -1
        visible: !runtime.settings.overlayMode
    }

    onPositionChanged: {
        audioVisualisationPlaceholder.metronomTick()
    }

    onStatusChanged: {
        if (status == AbstractMediaPlayer.EndOfMedia)
            playNext();
    }

    ParticleVisualization {
        id: audioVisualisationPlaceholder
        anchors.fill: parent
        visible: !avPlayer.hasVideo
        running: visible && !avPlayer.paused && avPlayer.playing
    }

    AVPlayerInfoOSD {
        id: infoOSD
        state: avPlayer.hasVideo && (avPlayer.paused || avPlayer.playbackRate != 1) && root.state == "maximized" ? "visible" : ""
    }

    AudioPlayerInfoSmallOSD {
        id: audioInfoSmallOSD
        state: root.showAudioOSD && !avPlayer.hasVideo && avPlayer.playing && root.state != "maximized" ? "visible" : ""
    }

    AudioPlayerInfoBigOSD {
        id: audioInfoBigOSD
        state: !avPlayer.hasVideo && avPlayer.playing && root.state == "maximized" ? "visible" : ""
    }

    Text {
        id: statusOSD
        color : "white"
        font.pixelSize: 42
        text: {
            var text = "";
            if (avPlayer.status == AbstractMediaPlayer.Buffering)
                text = qsTr("Buffering") + " ... " + avPlayer.bufferProgress
            else if (avPlayer.status == AbstractMediaPlayer.Loading)
                text = qsTr("Loading") + " ... ";
            else if (avPlayer.status == AbstractMediaPlayer.InvalidMedia)
                text = qsTr("Invalid Media");
            return text;
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.margins: 10

        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: statusOSD; property: "opacity"; to: 0 }
                PropertyAction {}
                NumberAnimation { target: statusOSD; property: "opacity"; to: 1 }
            }
        }
    }
}
