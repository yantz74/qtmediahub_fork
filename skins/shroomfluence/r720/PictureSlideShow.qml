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
import "components/"
import Playlist 1.0

FocusScope {
    id: root
    property variant playlist

    QtObject {
        id: d
        property bool running: root.visible && slide
        property bool slide: false
        property int interval: 3000
    }

    signal closed()

    function show() {
        state = "visible"
        forceActiveFocus();
    }

    function close() {
        root.state = ""
        root.closed();
        d.slide = false
    }

    function next() {
        playlist.next()
    }

    function previous() {
        playlist.previous()
    }

    anchors.top: parent.top
    anchors.left: parent.left
    height: parent.height
    width: parent.width
    opacity: 0
    anchors.topMargin: -height

    states:  [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
            }
            PropertyChanges {
                target: root.anchors
                topMargin: 0
            }
        }
    ]

    transitions: [
        Transition {
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "topMargin"
                    duration: confluence.standardAnimationDuration
                    easing.type: confluence.standardEasingCurve
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: confluence.standardAnimationDuration
                    easing.type: Easing.InOutSine
                }
            }
        }
    ]

    Keys.onContext1Pressed: d.slide = !d.slide
    Keys.onLeftPressed: root.previous()
    Keys.onRightPressed: root.next()
    Keys.onMenuPressed: root.close()
    Keys.onEnterPressed: root.close()

    Timer {
        id: timer
        running: d.running && Qt.application.active
        repeat: true
        interval: d.interval
        triggeredOnStart: true
        onTriggered: root.next()
    }

    Rectangle {
        id: blackout
        color: "black"
        anchors.fill: parent
    }

    ListView {
        id: listView
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 1000
        model: playlist
        currentIndex: playlist.currentIndex
        delegate: Item {
            width: listView.width
            height: listView.height
            Image {
                id: image
                cache: false
                fillMode: Image.PreserveAspectFit
                sourceSize.width: imageThumbnail.width > imageThumbnail.height ? parent.width : 0
                sourceSize.height: imageThumbnail.width <= imageThumbnail.height ? parent.height : 0
                anchors.fill: parent
                source: model.filepath
                asynchronous: true
            }
            Image {
                id: imageThumbnail
                cache: false
                anchors.fill: image
                fillMode: Image.PreserveAspectFit
                visible: image.status != Image.Ready
                source: model.previewUrl
            }
        }

        MouseArea {
            id: consumer
            anchors.fill: parent
            onClicked: {
                root.close()
                mouse.accepted = true;
            }
        }
    }
}

