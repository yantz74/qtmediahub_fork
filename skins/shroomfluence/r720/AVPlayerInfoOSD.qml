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
import "util.js" as Util

// This OSD is displayed when video is paused or being forwarded
FocusScope {
    id: root

    width: 450
    height: 100
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: -content.height

    BorderImage {
        id: content
        source: themeResourcePath + "/media/InfoMessagePanel.png"
        anchors.fill: parent

        border { left: 30; top: 30; right: 30; bottom: 30 }

        MouseArea {
            id: infoOSDMouseArea
            anchors.fill: parent
            hoverEnabled: true
        }

        Row {
            width: childrenRect.width
            height: childrenRect.height
            anchors.centerIn: parent

            Column {
                anchors.verticalCenter: seekOSD.verticalCenter

                Text {
                    text: avPlayer.paused ? qsTr("Paused") : qsTr("Playing")
                    color: "steelblue"
                }
                Text {
                    text: Util.ms2string(avPlayer.position) + " - " + Util.ms2string(avPlayer.duration)
                    color: "white"
                }
                ProgressBar {
                    width: 200
                    progress: avPlayer.position/avPlayer.duration
                }
            }

            Item {
                id: seekOSD
                width: childrenRect.width
                height: childrenRect.height

                Image {
                    id: seekOSDRewind
                    source:  themeResourcePath + "/media/OSDSeekRewind.png"
                    anchors.left: parent.left
                    anchors.verticalCenter: seekOSDCentral.verticalCenter
                    opacity: avPlayer.playbackRate < 0 ? 1 : 0.2
                }

                Image {
                    id: seekOSDCentral
                    source:  themeResourcePath + "/media/OSDSeekFrame.png"
                    anchors.left: seekOSDRewind.right
                    anchors.leftMargin: -10
                    anchors.top: parent.top
                }

                Image {
                    id: seekOSDForward
                    source:  themeResourcePath + "/media/OSDSeekForward.png"
                    anchors.left: seekOSDCentral.right
                    anchors.leftMargin: -10
                    anchors.verticalCenter: seekOSDCentral.verticalCenter
                    opacity: avPlayer.playbackRate > 1 ? 1 : 0.2
                }

                Image {
                    id: statusIcon
                    anchors.centerIn: seekOSDCentral

                    states: [
                        State {
                            when: avPlayer.playing && media.playbackRate == 1
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSDPlay.png"
                            }
                        },
                        State {
                            when: avPlayer.paused
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSDPause.png"
                            }
                        },
                        State {
                            when: avPlayer.playing && Math.abs(avPlayer.playbackRate) == 2
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSD2x.png"
                            }
                        },
                        State {
                            when: avPlayer.playing && Math.abs(avPlayer.playbackRate) == 4
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSD4x.png"
                            }
                        },
                        State {
                            when: avPlayer.playing && Math.abs(avPlayer.playbackRate) == 8
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSD8x.png"
                            }
                        },
                        State {
                            when: avPlayer.playing && Math.abs(avPlayer.playbackRate) == 16
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSD16x.png"
                            }
                        },
                        State {
                            when: avPlayer.playing && Math.abs(avPlayer.playbackRate) == 32
                            PropertyChanges {
                                target: statusIcon
                                source: themeResourcePath + "/media/OSD32x.png"
                            }
                        }
                    ]
                }
            }
        }


    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root.anchors
                bottomMargin: -5
            }
        }
    ]

    transitions: [
        Transition {
            ConfluenceAnimation { property: "bottomMargin" }
        }
    ]
}
