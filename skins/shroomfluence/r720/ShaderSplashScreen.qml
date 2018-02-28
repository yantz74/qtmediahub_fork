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

import Qt.labs.shaders.effects 2.0

Item {
    id: root

    opacity: 1

    function start() {}

    function play() {
        root.opacity = 0
    }

    signal finished

    anchors.fill: parent

    ShaderEffectSource {
        id: viewSource
        sourceItem: splash
        live: false
        hideSource: true
    }

    RadialWaveEffect {
        id: waveLayer
        visible: true
        anchors.fill: parent;
        source: viewSource

        wave: 0.0
        waveOriginX: 0.5
        waveOriginY: 0.5
        waveWidth: 0.01

        NumberAnimation on wave {
            id: waveAnim
            running: waveLayer.visible
            easing.type: "InQuad"
            from: 0.0000; to: 0.2000;
            duration: 1500
        }
    }

    Rectangle {
        id: splash
        width: root.width; height: root.height
        color: "black"

        Image {
            anchors.centerIn: parent
            source: "../3rdparty/skin.confluence/media/Confluence_Logo.png"
            asynchronous: false
        }
    }

    Component.onCompleted:
        splashDelay.start()

    Timer {
        id: splashDelay
        interval: 1500
        onTriggered:
            confluenceEntry.load()
    }

    Behavior on opacity {
        SequentialAnimation {
            ScriptAction { script: waveLayer.visible = false }
            PauseAnimation { duration: 500 }
            PropertyAnimation{ duration: 1000 }
        }
    }
    onOpacityChanged:
        if(root.opacity == 0)
            root.finished()
}
