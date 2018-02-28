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
    id: treatsApp
    width: 800
    height: 480
    color: "darkgrey"
    Component.onCompleted: treatsApp.state = "part1"
    signal animationFinished

    Item {
        width: 800
        height: 480
        anchors.centerIn: parent
        clip: true

        Logo {
            id: logo
            x: 165
            y: 35
            rotation: -15
            scale: 0.6
            opacity: 0
            onAnimationFinished: treatsApp.animationFinished();
        }

        Item {
            id: quickblur
            x: 800//325
            y: 344
            Image {
                id: blurText
                source: "quick-blur.png"
            }
            Image {
                id: quickregular
                x: -1
                y: 0
                opacity: 0
                source: "quick-regular.png"
            }
            Image {
                id: star
                x: -1
                y: 0
                opacity: 0
                source: "white-star.png"
                smooth: true
                NumberAnimation on rotation {
                    from: 0
                    to: 360
                    loops: NumberAnimation.Infinite
                    running: true
                    duration: 2000                
                }   
            }
        }
    }

    states: [
        State {
            name: "part1"
            PropertyChanges {
                target: logo
                scale: 0.8
                opacity: 1
                rotation: 0
            }
            PropertyChanges {
                target: treatsApp
                color: "black"
            }
            PropertyChanges {
                target: logo
                y: 10
            }
            PropertyChanges {
                target: quickblur
                x: logo.x + 145
            }
            PropertyChanges {
                target: blurText
                opacity: 0
            }
            PropertyChanges {
                target: quickregular
                opacity: 1
            }
            PropertyChanges {
                target: star
                x: -7
                y: -37
            }
        }
    ]

    transitions: [
        Transition {
            ParallelAnimation {
                NumberAnimation { target: logo; property: "opacity"; duration: 500 }
                NumberAnimation { target: logo; property: "scale"; duration: 4000; }
                NumberAnimation { target: logo; property: "rotation"; duration: 2000; easing.type: "OutBack"}
                ColorAnimation { duration: 3000}
                SequentialAnimation {
                    PauseAnimation { duration: 1000 }
                    ScriptAction { script: logo.logoState = "showBlueprint" }
                    PauseAnimation { duration: 800 }
                    ScriptAction { script: logo.logoState = "finale" }
                    PauseAnimation { duration: 800 }
                    ParallelAnimation {
                        NumberAnimation { target: quickblur; property: "x"; duration: 200;}
                        SequentialAnimation {
                            PauseAnimation { duration: 200}
                            ParallelAnimation {
                                NumberAnimation { target: blurText; property: "opacity"; duration: 300;}
                                NumberAnimation { target: quickregular; property: "opacity"; duration: 300;}
                            }
                            NumberAnimation { target: star; property: "opacity"; from: 0; to: 1; duration: 500 }
                            PauseAnimation { duration: 200 }
                            NumberAnimation { target: star; property: "opacity"; from: 1; to: 0; duration: 500 }
                        }
                        SequentialAnimation {
                            PauseAnimation { duration: 150}
                            NumberAnimation { target: logo; property: "y"; duration: 300; easing.type: "OutBounce" }
                        }
                    }
                }
            }
        }
    ]   

} // treatsApp
