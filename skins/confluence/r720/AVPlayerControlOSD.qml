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

import QtQuick 1.1
import "components/"

// This OSD appears on the top when mouse is moved when media is playing
FocusScope {
    id: root

    signal showPlayList()
    signal showMusicMenu()
    signal showVideoMenu()
    signal activity()
    signal showTargets()

    width: parent.width
    height: content.height

    function close() {
        root.state = ""
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: root.activity()
        onClicked: root.activity()
    }

    BorderImage {
        id: content
        source: themeResourcePath + "/media/MediaInfoBackUpper.png"

        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: -content.height

        ButtonList {
            id: buttonList
            wrapping: true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            onActivity: root.activity()

            ConfluencePixmapButton { basePixmap: "OSDBookmarksNF"; focusedPixmap: "OSDBookmarksFO"; onClicked: root.showPlayList(); }
            ConfluencePixmapButton { basePixmap: "OSDAudioNF"; focusedPixmap: "OSDAudioFO"; onClicked: root.showMusicMenu(); }
            ConfluencePixmapButton { basePixmap: "OSDVideoNF"; focusedPixmap: "OSDVideoFO"; onClicked: root.showVideoMenu(); }
            Item { width: 100; height: 1; }
            ConfluencePixmapButton { basePixmap: "OSDPrevTrackNF"; focusedPixmap: "OSDPrevTrackFO"; onClicked: avPlayer.playPrevious(); }
            ConfluencePixmapButton { enabled: avPlayer.seekable; basePixmap: "OSDRewindNF"; focusedPixmap: "OSDRewindFO"; onClicked: avPlayer.seekBackward() }
            ConfluencePixmapButton { basePixmap: "OSDStopNF"; focusedPixmap: "OSDStopFO"; onClicked: avPlayer.stop();}
            ConfluencePixmapButton {
                id: playPauseButton
                basePixmap: avPlayer.paused ? "OSDPlayNF" : "OSDPauseNF"
                focusedPixmap: avPlayer.paused ? "OSDPlayFO" : "OSDPauseFO"
                onClicked: avPlayer.togglePlayPause()
            }
            ConfluencePixmapButton { enabled: avPlayer.seekable; basePixmap: "OSDForwardNF"; focusedPixmap: "OSDForwardFO"; onClicked: avPlayer.seekForward() }
            ConfluencePixmapButton { basePixmap: "OSDNextTrackNF"; focusedPixmap: "OSDNextTrackFO"; onClicked: avPlayer.playNext(); }
            Item { width: 100; height: 1; }
            Item { width: playPauseButton.width; height: 1; }
            ConfluencePixmapButton {
                basePixmap:    !avPlayer.shuffle ? "OSDRandomOffNF" : "OSDRandomOnNF"
                focusedPixmap: !avPlayer.shuffle ? "OSDRandomOffFO" : "OSDRandomOnFO"
                onClicked: avPlayer.shuffle = !avPlayer.shuffle
            }
            ConfluencePixmapButton {
                basePixmap:    avPlayer.mediaPlaylist.wrapAround ? "OSDRepeatAllNF" : "OSDRepeatOneNF"
                focusedPixmap: avPlayer.mediaPlaylist.wrapAround ? "OSDRepeatAllFO" : "OSDRepeatOneFO"
                onClicked: avPlayer.mediaPlaylist.wrapAround = !avPlayer.mediaPlaylist.wrapAround
            }
            ConfluencePixmapButton { enabled: runtime.remoteSessionsModel.count() > 0; basePixmap: "OSDRecordNF"; focusedPixmap: "OSDRecordFO"; onClicked: root.showTargets(); }
            Keys.onUpPressed: root.close()
            Keys.onDownPressed: root.close()
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: content.anchors
                topMargin: -content.height + buttonList.height + buttonList.anchors.bottomMargin
            }
            StateChangeScript {
                script: {
                    buttonList.resetFocus()
                }
            }
        }
    ]

    transitions: [
        Transition {
            ConfluenceAnimation { property: "topMargin" }
        }
    ]
}
