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
import Playlist 1.0
import MediaModel 1.0
//import QtMultimediaKit 1.1
import QtMediaHub.components.media 1.0

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginMore

    // TODO: move to rapid
    function togglePlayPause()  { qmhPlayer.togglePlayPause() }
    function stop()             { qmhPlayer.stop() }
    function playPrevious()     { qmhPlayer.playPrevious() }
    function playNext()         { qmhPlayer.playNext() }

    QMHPlayer {
        id: qmhPlayer

        mediaPlaylist.onCurrentIndexChanged: { musicListView.currentIndex = qmhPlayer.mediaPlaylist.currentIndex+1 }

        onPausedChanged:  { if(qmhPlayer.playing && !qmhPlayer.paused) rapid.takeOverAudio(root); }
        onPlayingChanged: { if(qmhPlayer.playing && !qmhPlayer.paused) rapid.takeOverAudio(root); }
    }

    MediaModel {
        id: musicModel
        mediaType: "music"
        structure: "artist|album|title"
    }

    ListView {
        id: musicListView
        model: musicModel

        width: parent.width*0.66
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 20
        anchors.leftMargin: 10
        anchors.bottomMargin: 70

        focus: true
        clip: true
        highlightRangeMode: ListView.NoHighlightRange
        highlightMoveDuration: 250
        keyNavigationWraps: false
        currentIndex: -1

        highlight: Rectangle {
            opacity: 0.4
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#88FF70" }
                GradientStop { position: 0.5; color: "#50BB50" }
                GradientStop { position: 0.51; color: "#20B810" }
                GradientStop { position: 1.0; color: "lightgreen" }
            }
        }


        ScrollBar {
            id:  listViewScollBar
            flickable: parent
        }

        delegate: Item {
            id: delegateItem
            clip: true

            property variant itemdata : model
            property alias iconItem : delegateIcon

            width: delegateItem.ListView.view.width - listViewScollBar.width
            height: sourceText.height + 8
            transformOrigin: Item.Left

            function activate() {
                if (model.isLeaf)
                    qmhPlayer.play(musicModel, index)
                else {
                    musicListView.currentIndex = 0
                    musicModel.enter(index)
                }
            }

            Image {
                id: delegateIcon
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                clip:  true
                source: {
                    var icon;
                    if (model.dotdot)
                        return "";
                    else if (model.previewUrl != "")
                        return model.previewUrl;
                    else
                        return ""
                }
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Item {
                id: spacer
                anchors.left: delegateIcon.right
                width: delegateIcon.source == "" ? 36 : 0 // Magic number ... no other solution possible ... change all that longterm
                height: 1
            }

            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: spacer.right
                anchors.leftMargin: 10
                text: model.dotdot ? " -- UP --" : (delegateItem.ListView.view.model.part == "artist" ? model.artist : (delegateItem.ListView.view.model.part == "album" ? model.album : model.title))
                font.pixelSize: 24
                color: "white"
            }

            ListView.onAdd:
                SequentialAnimation {
                NumberAnimation {
                    target: delegateItem
                    properties: "scale, opacity"
                    from: 0
                    to: 1
                    duration: 200+index*40
                }
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: delegateItem.activate()
            }


        }

    }

    MusicInfo {
        player: qmhPlayer
        position: qmhPlayer.position
        duration: qmhPlayer.duration

        anchors.left: musicListView.right
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: root.bottom
        anchors.top: root.top
        clip:  true
    }


    Rectangle {
        id: audiocontrol
        anchors.bottom: parent.bottom
        //        anchors.bottomMargin: 25
        anchors.horizontalCenter: musicListView.horizontalCenter
        width: 250
        height: 60
        color: "#80404040"
        radius: 12

        Image {
            id: acrewind
            source: "./images/OSDRewindFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: acpause.left
            anchors.rightMargin: 30

            MouseArea {
                id: rewindMouseArea
                anchors.fill: parent
                anchors.margins: -15
                onPressed:  smartSeek.startRewind()
                onReleased: smartSeek.stop()
            }
        }

        Image {
            id: acpause
            source: (qmhPlayer.playing && !qmhPlayer.paused) ? "./images/OSDPauseFO.png" : "./images/OSDPlayFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                anchors.margins: -15
                onClicked:  qmhPlayer.togglePlayPause()
            }
        }

        Image {
            id: acforward
            source: "./images/OSDForwardFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: acpause.right
            anchors.leftMargin: 30

            MouseArea {
                id: forwardMouseArea
                anchors.fill: parent
                anchors.margins: -10
                onPressed:  smartSeek.startForward()
                onReleased: smartSeek.stop()
            }
        }
    }

    Item {
        id: smartSeek
        property int timerCount: 0
        property bool rewind: false

        function startForward() { rewind = false; start() }
        function startRewind()  { rewind = true;  start() }
        function start() {
            timerCount = 0
            if(qmhPlayer.playing)
                seekTimer.start();
        }

        function stop() {
            seekTimer.stop();
            if (timerCount <= (700/seekTimer.interval) ) {
                if(rewind) qmhPlayer.playPrevious()
                else       qmhPlayer.playNext();
            }
            timerCount = 0
        }


        Timer { id: seekTimer; interval: 100; repeat: true;
            onTriggered: {
                if(smartSeek.rewind) qmhPlayer.seekBackward();
                else                 qmhPlayer.seekForward();
                smartSeek.timerCount++;
            }
        }
    }


    Keys.onEnterPressed: if(musicListView.currentIndex != -1) musicListView.currentItem.activate()

    Keys.onDownPressed:  if(qmhPlayer.hasMedia && musicListView.currentIndex < musicListView.count-1) musicListView.currentIndex++;
                         else musicListView.currentIndex=0;
    Keys.onUpPressed:    if(qmhPlayer.hasMedia && musicListView.currentIndex > 0) musicListView.currentIndex--;
                         else musicListView.currentIndex=musicListView.count-1;
    Keys.onLeftPressed:  if(qmhPlayer.playing) qmhPlayer.seekBackward();
    Keys.onRightPressed: if(qmhPlayer.playing) qmhPlayer.seekForward();

    Keys.onBackPressed: musicModel.back()

}


