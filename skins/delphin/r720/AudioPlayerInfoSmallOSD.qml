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
import "util.js" as Util
import Playlist 1.0

Item {
    id: root

    width: parent.width-anchors.leftMargin*2
    height: childrenRect.height
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.bottomMargin: -childrenRect.height
    anchors.leftMargin: 20

    Row {
        spacing: 20
        width: parent.width

        BorderImage {
            id: thumbnailBorder
            source: themeResourcePath + "ThumbBorder.png"
            border.left: 10; border.top: 10
            border.right: 10; border.bottom: 10
            width: 128
            height: width

            Image {
                id: thumbnail
                source: avPlayer.thumbnail === "" ? themeResourcePath + "DefaultAudio.png" : avPlayer.thumbnail
                anchors.fill: parent
                anchors.margins: 6

                Image {
                    id: glassOverlay
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.width*0.7
                    height: parent.height*0.6
                    source: themeResourcePath + "GlassOverlay.png"
                }
            }
        }

        Column {
            spacing: 10
            anchors.bottom: parent.bottom
            width: parent.width-thumbnailBorder.width-20

            Row {
                spacing: 20

                Text {
                    text: avPlayer.playbackRate === 0 ? qsTr("Now Paused") : qsTr("Now Playing")
                    color: "steelblue"
                    font.bold: true
                    font.pixelSize: delphin.smallFontSize
                }

                Text {
                    text: avPlayer.title
                    color: "white"
                    font.bold: true
                    font.pixelSize: delphin.smallFontSize
                }
            }

            Row {
                spacing: 20

                Text {
                    text: avPlayer.artist
                    color: "white"
                    font.pixelSize: delphin.smallFontSize
                }

                Text {
                    text: avPlayer.album
                    color: "white"
                    font.pixelSize: delphin.smallFontSize
                }
            }

            ProgressBar {
                width: parent.width
                progress: avPlayer.duration != 0 ? avPlayer.position/avPlayer.duration : 1.0
            }

            Item {
                width: parent.width
                height: childrenRect.height

                Text {
                    text: Util.ms2string(avPlayer.position)
                    color: "white"
                    font.bold: true
                    font.pointSize: 16
                    anchors.left:  parent.left
                }

                Text {
                    text: Util.ms2string(avPlayer.duration)
                    color: "white"
                    font.bold: true
                    font.pointSize: 16
                    anchors.right: parent.right
                }
            }
        }

    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root.anchors
                bottomMargin: anchors.leftMargin
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "bottomMargin"; easing.type: Easing.OutQuad }
        }
    ]
}
