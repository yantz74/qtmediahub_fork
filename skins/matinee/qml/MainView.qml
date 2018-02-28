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
import QtQuick.Particles 2.0
import IpAddressFinder 1.0

FocusScope {
    id: root
    anchors.fill: parent
    clip: true
    state: ""
    scale: 1
    opacity: 1

    signal activateView(var type)

    transform: [
        Rotation {
            id: rootRot
            axis { x: 0; y: 1; z: 0 }
            origin { x: root.width; y: root.height/2 }
            angle: 0
        },
        Rotation {
            id: rootRot2
            axis { x: 1; y: 0; z: 0 }
            origin { x: root.width/2; y: root.height }
            angle: 0
        }
    ]

    states: [
        State {
            name: "musicInactive"
            PropertyChanges {
                target: rootRot
                angle: 0
            }
            PropertyChanges {
                target: rootRot2
                angle: 0
            }
            PropertyChanges {
                target: shaderEffect1
                factor: 1
            }
            PropertyChanges {
                target: root
                opacity: 0
            }
        },
        State {
            name: "pictureInactive"
            PropertyChanges {
                target: rootRot
                angle: -45
            }
            PropertyChanges {
                target: root
                scale: 0.8
            }
            PropertyChanges {
                target: rootRot2
                angle: 0
            }
        },
        State {
            name: "videoInactive"
            PropertyChanges {
                target: rootRot2
                angle: 60
            }
            PropertyChanges {
                target: root
                scale: 0.8
                opacity: 0.3
            }
            PropertyChanges {
                target: rootRot
                angle: 0
            }
            PropertyChanges {
                target: mainViewBackground
                opacity: 0
            }
        },
        State {
            name: "avplayerInactive"
            PropertyChanges {
                target: root
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "factor"; duration: 1000; easing.type: Easing.OutQuad }
            NumberAnimation { property: "scale"; duration: 1200; easing.type: Easing.OutQuad }
            NumberAnimation { property: "angle"; duration: 600; easing.type: Easing.OutQuad }
            NumberAnimation { property: "opacity"; duration: 800; easing.type: Easing.OutQuad }
        }
    ]

    Item {
        id: container
        anchors.fill: parent

        Image {
            id: mainViewBackground
            anchors.fill: parent
            source: "../images/air.jpg"
            smooth: true
            cache: false
            sourceSize.width: parent.width
            opacity: matinee.mediaPlayer.playing ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }

        PreviewList {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height/1.5
            width: parent.width
            mediaType: mainMenu.mediaType
            visible: !matinee.mediaPlayer.active
        }

        Emitter {
            system: particleSystem

            ParticleSystem {
                id: particleSystem

                ImageParticle {
                    system: particleSystem
                    alpha: 0
                    source: "../images/particle_circle_2.png"
                }
            }

            emitRate: 0.3
            lifeSpan: 30000

            y: parent.height
            x: 0
            width: parent.width

            speed: PointDirection {x: 0; y: -20; xVariation: 10; yVariation: 2;}
            speedFromMovement: 8
            size: 40
            sizeVariation: 20
        }

        Emitter {
            system: particleSystem2

            ParticleSystem {
                id: particleSystem2

                ImageParticle {
                    system: particleSystem2
                    alpha: 0
                    source: "../images/particle_circle_3.png"
                }
            }

            emitRate: 0.3
            lifeSpan: 30000

            y: parent.height
            x: 0
            width: parent.width

            speed: PointDirection {x: 0; y: -20; xVariation: 10; yVariation: 2;}
            speedFromMovement: 8
            size: 40
            sizeVariation: 20
        }

        Clock {
            id: clockItem
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 20
        }

        MainMenu {
            id: mainMenu

            height: 300
            width: parent.width
            anchors.bottom: parent.bottom
            focus: true

            onActivateView: root.activateView(type)
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: ipAddressFinder.ipAddresses.length > 0 ? ipAddressFinder.ipAddresses[0] : ""

            IpAddressFinder {
                id: ipAddressFinder
            }
        }
    }

    ShaderEffect {
        id: shaderEffect1
        anchors.fill: parent
        visible: runtime.skin.settings.fancy

        mesh: GridMesh {
            resolution: Qt.size(20, 20)
        }
        property real factor: 0
        property variant source: ShaderEffectSource {
            id: shaderEffectSource1
            sourceItem: container
            smooth: true
            hideSource: runtime.skin.settings.fancy
        }

        // bogus on raspberry pi
        property real newWidth: width

        vertexShader: "
            uniform lowp mat4 qt_Matrix;
            attribute lowp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying lowp vec2 qt_TexCoord0;
            uniform highp float newWidth;
            uniform lowp float factor;

            void main() {
                highp vec4 pos = qt_Vertex;
                lowp float d = factor * smoothstep(0., 1., qt_MultiTexCoord0.y);
                pos.x = newWidth * mix(d, 1.0 - d, qt_MultiTexCoord0.x);

                gl_Position = qt_Matrix * pos;
                qt_TexCoord0 = qt_MultiTexCoord0;
            }"
    }

    Component.onCompleted: {
        mainMenu.forceActiveFocus()
    }
}
