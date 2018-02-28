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
import Qt3D 1.0
import Qt3D.Shapes 1.0

Viewport {
    id: view;

    property Item mouseAreaHijackItem;
    property int sideLength: Math.min(parent.width,parent.height) / 5

    width: sideLength; height: sideLength
    scale: 1

    Cube {
        scale: 2

        NumberAnimation { target: rotateX; running: true; loops: Animation.Infinite; property: "angle"; to : 360.0; duration: 3000; }
        NumberAnimation { target: rotateY; running: true; loops: Animation.Infinite; property: "angle"; to : 360.0; duration: 4000; }
        NumberAnimation { target: rotateZ; running: true; loops: Animation.Infinite; property: "angle"; to : 360.0; duration: 5000; }

        transform: [
            Rotation3D { id: rotateX; axis: Qt.vector3d(1, 0, 0) },
            Rotation3D { id: rotateY; axis: Qt.vector3d(0, 1, 0) },
            Rotation3D { id: rotateZ; axis: Qt.vector3d(0, 0, 1) }
        ]

        effect: Effect {
            blending: true
            color: "#8880C342"
            texture: "images/qtlogo.png"
            decal: true
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (mouseAreaHijackItem === null || mouseAreaHijackItem === undefined)
                bounceAnimi.start()
            else
                mouseAreaHijackItem.hijackedMouseClicked();
        }
    }

    SequentialAnimation {id: bounceAnimi;
        NumberAnimation { target: view.anchors; properties: "rightMargin"; to: Math.abs(parent.width-parent.height)/2;
                        duration: 1000; easing.type: Easing.OutBounce; easing.amplitude: 0.5 }
        NumberAnimation { target: view; properties: "width, height"; to: Math.min(parent.width,parent.height);
                        duration: 3000; easing.type: Easing.OutBounce }
        NumberAnimation { target: view; properties: "width, height"; to: sideLength;
                        duration: 3000; easing.type: Easing.OutBounce }
        NumberAnimation { target: view.anchors; properties: "rightMargin"; to: 0;
                        duration: 1000; easing.type: Easing.OutBounce; easing.amplitude: 0.5 }
    }
}
