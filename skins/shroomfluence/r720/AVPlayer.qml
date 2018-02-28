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

import QtQuick 2.0
import QtMediaHub.components.media 2.0
import "components/"
import RpcConnection 1.0
import "./components/uiconstants.js" as UIConstants
import MediaModel 1.0
import Playlist 1.0
import AbstractMediaPlayer 1.0

//This serves to isolate import failures if QtMultimedia is not present
QMHPlayer {
    id: root

    function showOSD() {
        if (root.state == "maximized") {
            controlOSD.state = "visible"
        }
    }

    function playForeground(mediaModel, row) {
        d.queuedShow = true
        root.play(mediaModel, row)
    }

    function playBackground(mediaModel, row) {
        root.state = "background"
        root.play(mediaModel, row)
    }

    function showDialog(item) {
        var onClosedHandler = function() {
            root.forceActiveFocus()
            item.closed.disconnect(onClosedHandler)
        }
        item.closed.connect(onClosedHandler)
        item.open()
        item.forceActiveFocus()
    }

    function handlePendingShow() {
        d.queuedShow = false
        confluence.show(root)
    }

    onStatusChanged: {
        if (d.queuedShow && root.status == AbstractMediaPlayer.Buffered) {
            handlePendingShow()
        } else if (status == AbstractMediaPlayer.EndOfMedia) {
            playNext();
        }
    }

    onPlayingChanged: {
        if (root.playing && d.queuedShow)
            handlePendingShow()
    }

    states: [
        State {
            name: "background"
            PropertyChanges {
                target: root
                opacity: 1
                z: hasMedia && playing ? UIConstants.screenZValues.background : UIConstants.screenZValues.hidden
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: root
                opacity: 0
                z: UIConstants.screenZValues.hidden
            }
        },
        State {
            name: "maximized"
            PropertyChanges {
                target: root
                opacity: 1
                z: UIConstants.screenZValues.window
            }
        },
        State {
            name: "targets"
            PropertyChanges {
                target: root
                opacity: 1
                z: 5000
            }
        }
    ]

    transitions: [
        Transition {
            ConfluenceAnimation { properties: "opacity,x,y,width,height"; }
            PropertyAnimation { target: controlOSD; property: "state"; to: "" }
            PropertyAnimation { target: infoOSD; property: "state"; to: "" }
        }
    ]

    Keys.onMenuPressed:
        root.state == "targets" ? root.state = "maximized" : confluence.state = ""
    Keys.onEnterPressed: togglePlayPause()
    Keys.onContext1Pressed: showOSD()
    Keys.onUpPressed: playPrevious()
    Keys.onDownPressed: playNext()
    Keys.onLeftPressed: seekBackward()
    Keys.onRightPressed: seekForward()

    QtObject {
        id: d
        property bool queuedShow: false
        property bool seeking: false
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        property int lastX : 0

        onPositionChanged: {
            if (root.state == "maximized" && pressed && lastX - mouseX  > 100)
                root.state = "targets"
            else if (root.state == "targets" && pressed && mouseX - lastX > 100)
                root.state = "maximized"
            else
                showOSD();
        }
        onClicked: root.state == "maximized" && controlOSD.state != "visible" ? showOSD() : undefined;
        onPressed: lastX = mouseX
    }

    Timer {
        id: osdTimer
        interval: runtime.skin.settings.osdTimeout
        running: controlOSD.state == "visible"

        repeat: false
        onTriggered: controlOSD.close()
    }

    Timer {
        id: osdInfoTimer
        interval: runtime.skin.settings.osdTimeout

        repeat: false
        onTriggered: d.seeking = false
    }

    // fill the viewport with 'black' for small resolution movies (so that the background 
    // doesn't appear)
    Rectangle {
        id: backgroundFiller
        anchors.fill: parent
        color: "black"
        visible: !runtime.settings.overlayMode && avPlayer.hasVideo
        z: -1
    }

    AVPlayerControlOSD {
        id: controlOSD
        onActivity: osdTimer.restart();

        onShowPlayList: showDialog(playListDialog);
        onShowVideoMenu: showDialog(videoListDialog);
        onShowMusicMenu: showDialog(musicListDialog);
        onShowTargets: showDialog(targetsListDialog);
    }

    AVPlayerInfoOSD {
        id: infoOSD
        state: root.hasVideo && (root.paused || d.seeking) && root.state == "maximized" ? "visible" : ""
    }

    AudioPlayerInfoSmallOSD {
        id: audioInfoSmallOSD
        state: !root.hasVideo && root.playing && root.state != "maximized" ? "visible" : ""
    }

    AudioPlayerInfoBigOSD {
        id: audioInfoBigOSD
        state: !root.hasVideo && root.playing && root.state == "maximized" ? "visible" : ""
    }

    Image {
        id: backToHomeButton

        width: homeBackdrop.width; height: homeBackdrop.height

        anchors { bottom: parent.bottom; left: parent.left; margins: -backToHomeButton.width }
        state: root.state == "maximized" || root.state == "targets" ? "visible" : ""

        states: [
            State {
                name: "visible"
                PropertyChanges {
                    target: backToHomeButton.anchors
                    margins: 0
                }
            }
        ]

        transitions: [
            Transition {
                ConfluenceAnimation { property: "margins" }
            }
        ]

        Image {
            id: homeBackdrop
            opacity: 0.1
            anchors.centerIn: parent
            source:  themeResourcePath + "/media/radialgradient60.png"
        }
        Image {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -1
            source:  themeResourcePath + "/media/" + (mr.containsMouse ? "HomeIcon-Focus" : "HomeIcon") + ".png"
        }

        MouseArea {
            id: mr
            hoverEnabled: true
            anchors.fill: parent

            onClicked: root.state == "targets" ? root.state = "maximized" : confluence.show(mainBlade)
        }
    }


    Dialog {
        id: videoListDialog
        width: parent.width/1.5
        height: parent.height/1.5
        title: qsTr("Videos")

        MediaModel {
            id: videoModel
            mediaType: "video"
            structure: "show|season|title"
        }

        ConfluenceListView {
            id: videoListPanel
            anchors.fill: parent
            model: videoModel
            focus: true

            onActivated: {
                root.play(videoModel, videoListPanel.currentIndex)
                videoListDialog.close()
            }
        }
    }

    Dialog {
        id: musicListDialog
        width: parent.width/1.5
        height: parent.height/1.5
        title: qsTr("Music")

        MediaModel {
            id: musicModel
            mediaType: "music"
            structure: "artist|album|title"
        }

        ConfluenceListView {
            id: musicListPanel
            anchors.fill: parent
            model: musicModel
            focus: true

            onActivated: {
                root.play(musicModel, musicListPanel.currentIndex)
                musicListDialog.close()
            }
        }
    }

    Dialog {
        id: playListDialog
        width: parent.width/1.5
        height: parent.height/1.5
        title: qsTr("Playlist")

        ConfluenceListView {
            id: playListPanel
            anchors.fill: parent
            model: root.mediaPlaylist
            focus: true

            onActivated: {
                root.playIndex(currentIndex)
                playListDialog.close()
            }
        }
    }

    Dialog {
        id: targetsListDialog
        width: parent.width/1.5
        height: parent.height/1.5
        title: qsTr("Send current Movie to Device")

        ConfluenceListView {
            id: targetsList
            anchors.fill: parent
            model: runtime.remoteSessionsModel

            delegate: Item {
                id: delegateItem
                width: ListView.view.width
                height: sourceText.height + 8

                function action() {
                    if (root.hasVideo)
                        rpcClient.send(model.address, model.port, "http://" + runtime.httpServer.address + ":" + runtime.httpServer.port + "/video/" + avPlayer.mediaId, root.position)
                    else
                        rpcClient.send(model.address, model.port, "http://" + runtime.httpServer.address + ":" + runtime.httpServer.port + "/music/" + avPlayer.mediaId, root.position)
                }

                Image {
                    id: backgroundImage
                    anchors.fill: parent;
                    source: themeResourcePath + "/media/" + (delegateItem.ListView.isCurrentItem ? "MenuItemFO.png" : "MenuItemNF.png");
                }

                ConfluenceText {
                    id: sourceText
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.display ? model.display : ""
                }

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true
                    onEntered: delegateItem.ListView.view.currentIndex = index
                    onClicked: delegateItem.action()
                }

                Keys.onEnterPressed: delegateItem.action()
            }
        }

        RpcConnection {
            id: rpcClient
            property string source
            property int position

            onClientConnected: {
                rpcClient.call("qmhmediaplayer.playRemoteSource", source, position)
                disconnectFromHost();
            }

            function send(ip, port, src, pos) {
                source = src
                position = pos
                connectToHost(ip, port);
            }
        }
    }
}

