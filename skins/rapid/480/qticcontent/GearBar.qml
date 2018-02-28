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

Item {
    id: root

    property int gear: -1
    width: (g6.x+g6.width) - r.x
    height: 30

    property int fontPixelSize: 19

    Text { id: r;  text: "R"; anchors.left:root.left; anchors.leftMargin: 0; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: p;  text: "P"; anchors.left:  r.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: n;  text: "N"; anchors.left:  p.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g1; text: "1"; anchors.left:  n.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g2; text: "2"; anchors.left: g1.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g3; text: "3"; anchors.left: g2.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g4; text: "4"; anchors.left: g3.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g5; text: "5"; anchors.left: g4.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g6; text: "6"; anchors.left: g5.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }

    Rectangle {
        id: gearRect
        smooth: true
        radius: 3
        color: "transparent"
        border.color: "white"
        border.width: 3

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: p.horizontalCenter

        height: 23
        width: 20
    }

    states: [
        State { when: gear == -2; name: "R"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: r.horizontalCenter }
        },
        State { when: gear == -1; name: "P"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: p.horizontalCenter }
        },
        State { when: gear == 0; name: "N"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: n.horizontalCenter }
        },
        State { when: gear == 1; name: "1"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g1.horizontalCenter }
        },
        State { when: gear == 2; name: "2"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g2.horizontalCenter }
        },
        State { when: gear == 3; name: "3"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g3.horizontalCenter }
        },
        State { when: gear == 4; name: "4"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g4.horizontalCenter }
        },
        State { when: gear == 5; name: "5"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g5.horizontalCenter }
        },
        State { when: gear == 6; name: "6"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g6.horizontalCenter }
        }
    ]

    transitions: Transition { AnchorAnimation { duration: 500 } }
}
