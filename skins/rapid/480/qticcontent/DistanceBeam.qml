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
    property int distance: 7

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: closest
        color: "darkred"
        height: 30
        anchors.left: parent.left
    }

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: closer
        color: "red"
        height: 33
        anchors.left: closest.right
    }

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: close
        color: "orangered"
        height: 36
        anchors.left: closer.right
    }

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: mid
        color: "orange"
        height: 39
        anchors.left: close.right
    }

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: far
        color: "yellow"
        height: 42
        anchors.left: mid.right
    }

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: further
        color: "yellowgreen"
        height: 45
        anchors.left: far.right
    }

    Rectangle {width: 10; anchors.verticalCenter: parent.verticalCenter; radius: 5; anchors.leftMargin: 3; smooth: true
        id: furthest
        color: "green"
        height: 48
        anchors.left: further.right
    }

    states: [
        State { name: "closerState"; when: distance==1
            PropertyChanges { target: closest; color: "#202020"}},

        State { name: "closeState"; when: distance==2;
            PropertyChanges { target: closest; color: "#202020"}
            PropertyChanges { target: closer; color: "#202020"}},

        State { name: "midState"; when: distance==3;
            PropertyChanges { target: closest; color: "#202020"}
            PropertyChanges { target: closer; color: "#202020"}
            PropertyChanges { target: close; color: "#202020"}},

        State { name: "farState"; when: distance==4;
            PropertyChanges { target: closest; color: "#202020"}
            PropertyChanges { target: closer; color: "#202020"}
            PropertyChanges { target: close; color: "#202020"}
            PropertyChanges { target: mid; color: "#202020"}},

        State { name: "furtherState"; when: distance==5;
            PropertyChanges { target: closest; color: "#202020"}
            PropertyChanges { target: closer; color: "#202020"}
            PropertyChanges { target: close; color: "#202020"}
            PropertyChanges { target: mid; color: "#202020"}
            PropertyChanges { target: far; color: "#202020"}},

        State { name: "furthestState"; when: distance==6;
            PropertyChanges { target: closest; color: "#202020"}
            PropertyChanges { target: closer; color: "#202020"}
            PropertyChanges { target: close; color: "#202020"}
            PropertyChanges { target: mid; color: "#202020"}
            PropertyChanges { target: far; color: "#202020"}
            PropertyChanges { target: further; color: "#202020"}},

        State { name: "infiniteState"; when: distance==7;
            PropertyChanges { target: closest; color: "#202020"}
            PropertyChanges { target: closer; color: "#202020"}
            PropertyChanges { target: close; color: "#202020"}
            PropertyChanges { target: mid; color: "#202020"}
            PropertyChanges { target: far; color: "#202020"}
            PropertyChanges { target: further; color: "#202020"}
            PropertyChanges { target: furthest; color: "#202020"}}
    ]

    transitions: [
        Transition {
            from: "*"; to: "*"
            ColorAnimation { easing.type: Easing.Linear; duration: 500 }
        }
    ]
}
