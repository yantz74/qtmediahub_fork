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
import MediaModel 1.0

Item {
    id: root

    width: 800
    height: 480

    transform: Rotation {
        angle: -30 + matinee.width/200
        axis { x: 0; y: 1; z: 0 }
        origin.x: root.width
        origin.y: -50
    }

    property alias mediaType: previewModel.mediaType

    MediaModel {
        id: previewModel
        mediaType: "music"
        structure: mediaType == "music" ? "artist" : "fileName"

        Behavior on mediaType {
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: shaderEffect1; property: "fadeMarginX"; from: 0; to: 3; duration: 1300; }
                    NumberAnimation { target: previewView; property: "contentX"; to: -previewView.width*2; duration: 700; easing.type: Easing.InQuad }
                }

                PropertyAction { target: previewModel; property: "mediaType"}
                PauseAnimation { duration: 100 }
                ParallelAnimation {
                    NumberAnimation { target: shaderEffect1; property: "fadeMarginX"; from: 3; to: 0; duration: 800; }
                    NumberAnimation { target: previewView; property: "contentX"; to: 0; duration: 700; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    ShaderEffectSource {
        id: theSource
        sourceItem: previewView
        smooth: true
        hideSource: runtime.skin.settings.fancy
    }

    ShaderEffect {
        id: shaderEffect1
        width: theSource.sourceItem.width
        height: theSource.sourceItem.height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visible: runtime.skin.settings.fancy

        transform: Scale {
            origin.x: parent.width
            origin.y: parent.height/2
            xScale: 2
            yScale: 1
        }

        property real fadeMargin: 0.2
        property real fadeMarginX: 0
        property variant src: theSource

        SequentialAnimation on fadeMargin {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.1; duration: 4000; easing.type: Easing.OutQuad }
            NumberAnimation { to: 0.2; duration: 4000; easing.type: Easing.OutQuad }
        }

        vertexShader: "
            uniform lowp mat4 qt_Matrix;
            attribute lowp vec4 qt_Vertex;
            attribute lowp vec2 qt_MultiTexCoord0;
            varying lowp vec2 coord;

            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }
        "

        fragmentShader: "
            varying lowp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform lowp float fadeMargin;
            uniform lowp float fadeMarginX;

            void main() {
                lowp vec4 tex = texture2D(src, coord);
                lowp vec4 color;

                tex.rgba = tex.rgba + (1. - abs(coord.x - fadeMarginX));

                if (coord.y < fadeMargin)
                    color = tex.rgba * qt_Opacity * coord.y*(1.0/fadeMargin);
                else
                    color = tex.rgba * qt_Opacity;

                gl_FragColor = color * coord.x;
            }
        "
    }

    ShaderEffectSource {
        id: theSource2
        sourceItem: shaderEffect1
        smooth: true
        hideSource: false
    }

    ShaderEffect {
        width: theSource2.sourceItem.width
        height: theSource2.sourceItem.height/2.0
        anchors.right: parent.right
        anchors.top: shaderEffect1.bottom
        visible: runtime.skin.settings.fancy

        transform: Scale {
            origin.x: parent.width
            origin.y: parent.height/2
            xScale: 2
            yScale: 1
        }

        property variant src: theSource2
        property real alpha: 0.3

        SequentialAnimation on alpha {
            loops: -1
            NumberAnimation { to: 0.8; duration: 5000 }
            NumberAnimation { to: 0.3; duration: 5000 }
        }

        fragmentShader:
            "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform highp float alpha;

            void main() {
                highp vec4 pix = texture2D(src, vec2(qt_TexCoord0.x, 1.0 - qt_TexCoord0.y));
                gl_FragColor = qt_Opacity * pix * alpha; //vec4(pix.r, pix.g, pix.b, pix.a);
            }
            "
    }

    ListView {
        id: previewView
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height/2
        model: previewModel
        orientation: ListView.Horizontal
        clip: true
        interactive: false

        NumberAnimation {
            id: scrollerAnimation
            running: false
            target: previewView
            property: "contentX"
            to: previewView.contentWidth
            duration: previewView.contentWidth > 0 ? previewView.contentWidth*10 : 0
        }

        delegate: Item {
            id: delegate
            width: ListView.view.height
            height: ListView.view.height

            Image {
                anchors.fill: parent
                source: model.previewUrl
                sourceSize.width: delegate.width
            }
        }
    }
}
