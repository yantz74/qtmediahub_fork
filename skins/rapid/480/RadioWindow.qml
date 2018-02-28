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
import QtMediaHub.components.media 1.0


Window {
    id: root

    // TODO: move to rapid
    function togglePlayPause()  { qmhPlayer.togglePlayPause() }
    function stop()             { qmhPlayer.stop() }
    function playPrevious()     { qmhPlayer.playPrevious() }
    function playNext()         { qmhPlayer.playNext() }

    QMHPlayer {
        id: qmhPlayer

        onPausedChanged:  { if(qmhPlayer.playing && !qmhPlayer.paused) rapid.takeOverAudio(root); }
        onPlayingChanged: { if(qmhPlayer.playing && !qmhPlayer.paused) rapid.takeOverAudio(root); }
    }

    MediaModel {
        id: radioModel
        mediaType: "radio"
        structure: "title"
        dotDotPosition: MediaModel.End
    }

    ListView {
        id: mediaListView
        model: radioModel
        currentIndex: 1 // unsets the hightlight .. not sure why, but does the job ;)

        anchors.left:   parent.left
        anchors.leftMargin: 80
        anchors.right:  parent.right
        anchors.rightMargin: 10
        anchors.top:    parent.top
        anchors.bottom: parent.bottom

        focus: true
        clip: true

        ScrollBar {
            id:  listViewScollBar
            flickable: parent
        }
        Rectangle {
            id: topShadow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height/7

            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
        Rectangle {
            id: buttomShadow
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height/7

            gradient: Gradient {
                GradientStop { position: 1.0; color: "black" }
                GradientStop { position: 0.0; color: "transparent" }
            }
        }

        highlightRangeMode: ListView.NoHighlightRange
        highlightMoveDuration: 250
        highlight: Rectangle {          //TODO: check if ok..
            opacity: 0.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#88FF70" }
                GradientStop { position: 0.5; color: "#50BB50" }
                GradientStop { position: 0.51; color: "#40B830" }
                GradientStop { position: 1.0; color: "lightgreen" }
            }
        }

        spacing: 1
        delegate: Item {
            id: delegateItem

            property variant itemData : model

            width: delegateItem.ListView.view.width - listViewScollBar.width
            height: sourceText.height + 18
            clip: true
            transformOrigin: Item.Left

            function activate() {
                if (model.isLeaf)
                    qmhPlayer.play(radioModel, index)
                else
                    musicModel.enter(index)
                mediaListView.currentIndex = index;
            }

            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: model.title != "" ? model.title : model.uri
                font.pointSize: 24
                color: "white"
            }

            Rectangle {
                id: separator
                height: 1
                color: "darkgray"
                width: parent.width
                anchors.top: sourceText.bottom
                anchors.topMargin: 8
            }

            ListView.onAdd:
                SequentialAnimation {
                NumberAnimation {
                    target: delegateItem
                    properties: "scale, opacity"
                    from: 0
                    to: 1
                    duration: 200+index*80
                }
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: { delegateItem.activate(); }
            }

        }

        Keys.onEnterPressed: if(mediaListView.currentIndex != -1) mediaListView.currentItem.activate()

        Keys.onDownPressed:  if(mediaListView.currentIndex < mediaListView.count-1) mediaListView.currentIndex++;
                             else mediaListView.currentIndex=0;
        Keys.onRightPressed: if(mediaListView.currentIndex < mediaListView.count-1) mediaListView.currentIndex++;
                             else mediaListView.currentIndex=0;

        Keys.onUpPressed:    if(mediaListView.currentIndex > 0) mediaListView.currentIndex--;
                             else mediaListView.currentIndex=mediaListView.count-1;
        Keys.onLeftPressed:  if(mediaListView.currentIndex > 0) mediaListView.currentIndex--;
                             else mediaListView.currentIndex=mediaListView.count-1;
    }

//    Image {
//        id: coverArt
//        anchors.left: mediaListView.right
//        anchors.leftMargin: 65
//        anchors.right: parent.right
//        anchors.rightMargin: 30
//        anchors.bottom: mediaListView.bottom
//        anchors.top: mediaListView.top
//        clip:  true
//        source: mediaListView.currentItem ? mediaListView.currentItem.iconItem.source : ""
//        fillMode: Image.PreserveAspectFit
//    }
}

