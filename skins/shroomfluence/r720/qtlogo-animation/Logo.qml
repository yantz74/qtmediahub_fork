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

Rectangle {
    id: myApp
    width: 411
    height: 411
    color: "transparent"
    property alias logoState : myApp.state
    signal animationFinished

    Item {
        id: sketchBlueHolder
        width: sketchLogo.width
        height: sketchLogo.height
        Image {
            id: image1
            x: -44
            y: -45
            smooth: true
            source: "shadow.png"
        }
        Item {
            clip: true
            width: sketchLogo.width
            height: sketchLogo.height
            Image {
                id: sketchLogo
                smooth: true
                source: "qt-sketch.jpg"
            }
            Image {
                id: blueLogo
                y: -420
                smooth: true
                source: "qt-blue.jpg"
            }
        }
    }

    states: [
        State {
            name: "showBlueprint"
            PropertyChanges {
                target: blueLogo
                y: 0
            }
            PropertyChanges {
                target: sketchLogo
                opacity: 0
            }
        },
        State {
            extend: "showBlueprint"
            name: "finale"
            PropertyChanges {
                target: fullLogo
                opacity: 1
            }
            PropertyChanges {
                target: backLogo
                opacity: 1
                scale: 1
            }
            PropertyChanges {
                target: frontLogo
                opacity: 1
                scale: 1
            }
            PropertyChanges {
                target: qtText
                opacity: 1
                scale: 1
            }
            PropertyChanges {
                target: sketchBlueHolder
                opacity: 0
                scale: 1.4
            }
        }
    ]

    transitions: [
        Transition {
            to: "showBlueprint"
            SequentialAnimation {
                NumberAnimation { property: "y"; duration: 600; easing.type: "OutBounce" }
                PropertyAction { target: sketchLogo; property: "opacity" }
            }
        },
        Transition {
            to: "finale"
            PropertyAction { target: fullLogo; property: "opacity" }
            SequentialAnimation {
                NumberAnimation { target: backLogo; properties: "scale, opacity"; duration: 300 }
                NumberAnimation { target: frontLogo; properties: "scale, opacity"; duration: 300 }
                ParallelAnimation {
                    NumberAnimation { target: qtText; properties: "opacity, scale"; duration: 400; easing.type: "OutQuad" }
                    NumberAnimation { target: sketchBlueHolder; property: "opacity"; duration: 300; easing.type: "OutQuad" }
                    NumberAnimation { target: sketchBlueHolder; property: "scale"; duration: 320; easing.type: "OutQuad" }
                }
                PauseAnimation { duration: 1000 }
                ScriptAction { script: myApp.animationFinished() }
            }
        }
    ]

    Item {
        id: fullLogo
        opacity: 0
        Image {
            id: backLogo
            x: -16
            y: -41
            opacity: 0
            scale: 0.7
            smooth: true
            source: "qt-back.png"
        }
        Image {
            id: frontLogo
            x: -17
            y: -41
            opacity: 0
            scale: 1.2
            smooth: true
            source: "qt-front.png"
        }
        Image {
            id: qtText
            x: -10
            y: -41
            opacity: 0
            scale: 1.2
            smooth: true
            source: "qt-text.png"
        }
    }
}
