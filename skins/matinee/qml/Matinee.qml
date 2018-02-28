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

FocusScope {
    id: matinee
    width: 1280
    height: 720

    property int bigFont: matinee.width / 25
    property int mediumFont: matinee.width / 50
    property int smallFont: matinee.width / 70

    property variant activeView: mainView
    property variant mainMenuView: mainView
    property alias mediaPlayer: mediaPlayerContainer.mediaPlayer

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    function showView(view) {
        runtime.contextContent.invalidateContextContent()

        if (view == mainView) {
            matinee.activeView.state = ""
            matinee.activeView = view
            matinee.activeView.state = ""
        } else if (view === videoView) {
            matinee.activeView.state = "videoInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
            runtime.contextContent.newContextContent("matinee", "Video.qml", videoView.getModelIdList())
        } else if (view === pictureView) {
            matinee.activeView.state = "pictureInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
            runtime.contextContent.newContextContent("matinee", "Picture.qml", pictureView.getModelIdList())
        } else if (view === musicView) {
            matinee.activeView.state = "musicInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        } else if (view === settingsView) {
            matinee.activeView.state = "settingsInactive"
            matinee.activeView = view
            matinee.activeView.state = "active"
        }

        matinee.activeView.forceActiveFocus()
    }

    Connections {
        target: runtime.contextContent
        onItemSelectedById: matinee.activeView.selectById(id);
    }

    MediaPlayerContainer {
        id: mediaPlayerContainer
        anchors.fill: parent
    }

    PictureView {
        id: pictureView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
        onRowsInserted: runtime.contextContent.newContextContent("matinee", "Picture.qml", pictureView.getModelIdList())
    }

    VideoView {
        id: videoView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
        onRowsInserted: runtime.contextContent.newContextContent("matinee", "Video.qml", videoView.getModelIdList())
    }

    MainView {
        id: mainView
        anchors.fill: parent

        onActivateView: {
            if (type === "music") {
                matinee.showView(musicView);
            } else if (type === "picture") {
                matinee.showView(pictureView);
            } else if (type === "video") {
                matinee.showView(videoView);
            } else if (type === "settings") {
                matinee.showView(settingsView);
            }
        }
    }

    MusicView {
        id: musicView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }

    SettingsView {
        id: settingsView
        anchors.fill: parent
        onBack: matinee.showView(mainView)
    }

    VolumeOSD {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
    }

    Component.onCompleted: {
        //        runtime.mediaScanner.addSearchPath("music", "/home/jzellner/minimal_media/music/", "music");
        //        runtime.mediaScanner.addSearchPath("video", "/home/jzellner/minimal_media/video/", "video");
        //        runtime.mediaScanner.addSearchPath("picture", "/home/jzellner/minimal_media/picture/", "picture");
    }

    Keys.onVolumeUpPressed: mediaPlayer.increaseVolume();
    Keys.onVolumeDownPressed: mediaPlayer.decreaseVolume();

    Keys.onPressed: {
        event.accepted = true
        if (event.key == Qt.Key_MediaTogglePlayPause) {
            mediaPlayer.togglePlayPause()
        } else if (event.key == Qt.Key_MediaStop) {
            mediaPlayer.stop()
        } else if (event.key == Qt.Key_MediaPrevious) {
            mediaPlayer.playPrevious()
        } else if (event.key == Qt.Key_MediaNext) {
            mediaPlayer.playNext()
        } else {
            event.accepted = false
        }
    }
}

