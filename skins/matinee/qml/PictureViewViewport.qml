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
import Qt3D 1.0
import Qt3D.Shapes 1.0

Viewport {
    id: root
    width: parent.width
    height: parent.height
    navigation: false

    property int columns: 3
    property int spacing: 2
    property int xOffset: 2
    property int yOffset: -4

    property int currentIndex: -1

    states: [
        State{
            name: "selected"
            PropertyChanges { target: mainCamera; eye: Qt.vector3d(0, 0, -4) }
        }
    ]

    function showCurrentItem() {
        if (root.state === "")
            root.state = "selected"
        else
            root.state = ""
    }

    function incrementCurrentIndex() {
        root.currentIndex = (root.currentIndex+1 >= pictureModel.count) ? pictureModel.count-1 : root.currentIndex + 1;
    }

    function decrementCurrentIndex() {
        root.currentIndex = (root.currentIndex-1 < 0) ? 0 : root.currentIndex - 1;
    }

    light: Light {
        ambientColor: "white"
    }

    camera: Camera {
        id: mainCamera
        eye: Qt.vector3d(repeaterView.itemAt(root.currentIndex).x,repeaterView.itemAt(root.currentIndex).y,-5)
        center: Qt.vector3d(0, 0, 0)
        farPlane: 10000
        nearPlane: 1

        Behavior on eye {
            Vector3dAnimation {}
        }
    }

    ListModel {
        id: pictureModel
        ListElement { previewUrl: "../images/audio/hopeful_expectations.jpg"; artist: "Expectations" }
        ListElement { previewUrl: "../images/audio/calle_n.jpg"; artist: "Calle N" }
        ListElement { previewUrl: "../images/audio/soundasen.jpg"; artist: "Soundasen" }
        ListElement { previewUrl: "../images/audio/amphetamin.jpg"; artist: "Amphetamin" }
        ListElement { previewUrl: "../images/audio/enemy_leone.jpg"; artist: "Enemy Leone" }
        ListElement { previewUrl: "../images/audio/ensueno.jpg"; artist: "Ensueno" }
        ListElement { previewUrl: "../images/audio/hopeful_expectations.jpg"; artist: "Expectations" }
        ListElement { previewUrl: "../images/audio/calle_n.jpg"; artist: "Calle N" }
        ListElement { previewUrl: "../images/audio/soundasen.jpg"; artist: "Soundasen" }
    }

    Repeater {
        id: repeaterView
        model: pictureModel
        delegate: Cube {
            id: viewDelegate
            effect: Effect {
                texture: {
                    if (model.dotdot) return ""
                    else if (model.previewUrl == "" ) return "../images/default-media.png"
                    else return model.previewUrl
                }
//                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                blending: true
            }

            x: {
                if (root.state === "selected") {
                    if (root.currentIndex === index) return 3 + root.xOffset;
                    else return 30;
                } else return (index % root.columns) * root.spacing + root.xOffset;
            }
            y: (root.currentIndex === index && root.state === "selected" ? 2 : Math.floor(index / root.columns) * root.spacing) + root.yOffset;
            z: 5

            scale:  {
                if (root.currentIndex === index) {
                    if (root.state === "selected") return 5;
                    else return 3;
                } else return 1.5;
            }

            Behavior on scale {
                NumberAnimation {}
            }

            Behavior on x {
                 NumberAnimation {}
            }

            Behavior on y {
                 NumberAnimation {}
            }

            transform: Rotation3D {
                axis: Qt.vector3d(0,1,0)
                angle: 0

                NumberAnimation on angle {
                    running: root.currentIndex === index && root.state === "selected"
                    loops: Animation.Infinite
                    from: 0; to: 360; duration: 2000
                    alwaysRunToEnd: true
                }
            }
        }
    }

    Component.onCompleted: root.currentIndex = 0
}
