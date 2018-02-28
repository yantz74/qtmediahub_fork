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

FocusScope {
    id: root
    width: 800
    height: 480
    opacity: 0

    property alias mediaModel: videoModel

    signal back()
    signal rowsInserted()

    function enter() {
        if (gridView.currentItem.isLeaf)
            matinee.mediaPlayer.playForeground(videoModel, gridView.currentIndex+1)
        else {
            videoModel.enter(gridView.currentIndex)
            gridView.currentIndex = 0
        }
    }

    function selectById(id) {
        gridView.currentIndex = videoModel.indexById(id)
        enter();
    }

    function getModelIdList() {
        return videoModel.getIdList()
    }


    states: State {
        name: "active"
        PropertyChanges { target: root; opacity: 1; }
    }

    transitions: [
        Transition {
            NumberAnimation { property: "opacity"; duration: 800 }
        }
    ]

    MediaModel {
        id: videoModel
        mediaType: "video"
        structure: "show|season|title"
        onRowsInserted: root.rowsInserted()
    }

    ShaderEffectSource {
        id: theSource
        sourceItem: videoWall
        smooth: true
        hideSource: runtime.skin.settings.fancy
    }

    ShaderEffect {
        id: shaderEffect1
        width: theSource.sourceItem.width
        height: theSource.sourceItem.height
        anchors.centerIn: parent
        visible: runtime.skin.settings.fancy

        mesh: GridMesh { resolution: Qt.size(50, 10) }

        property variant src: theSource

        property real parabelY: 0.5
        property real parabelYScale: 1.4
        property real parabelCurveDamping: 0.4

        vertexShader: "
            uniform lowp mat4 qt_Matrix;
            attribute lowp vec4 qt_Vertex;
            attribute lowp vec2 qt_MultiTexCoord0;
            varying lowp vec2 coord;
            uniform lowp float parabelY;
            uniform lowp float parabelYScale;
            uniform lowp float parabelCurveDamping;
            uniform lowp float height;

            void main() {
                vec4 pos = qt_Vertex;
                coord = qt_MultiTexCoord0;
                float x = coord.x;

                x = ((x * 2.) - 1.);            // move between -1 and 1
                x = x * parabelCurveDamping;    // curve damping
                pos.y = pos.y * parabelYScale * (parabelY + x*x);

                gl_Position = qt_Matrix * pos;
            }
        "

        SequentialAnimation on parabelCurveDamping {
            running: false
            loops: -1
            NumberAnimation { to: 0; duration: 2000 }
            NumberAnimation { to: 1; duration: 2000 }
        }

        fragmentShader: "
            varying lowp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;

            void main() {
                lowp vec4 tex = texture2D(src, vec2(coord.x, coord.y)).rgba;
                gl_FragColor = qt_Opacity * tex;
            }
        "
    }


    Item {
        id: videoWall
        anchors.fill: parent

        Image {
            source: "../images/simple_blue_widescreen.png"
            anchors.fill: parent
            cache: false
            opacity: matinee.mediaPlayer.active ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }

        GridView {
            id: gridView
            width: parent.width
            height: runtime.skin.settings.fancy ? parent.height : parent.height/1.5
            flow: GridView.TopToBottom
            model: videoModel
            cellHeight: count < 6 ? height/2.0 : 256
            cellWidth: cellHeight
            currentIndex: 0
            highlightRangeMode: GridView.StrictlyEnforceRange
            preferredHighlightBegin: height/2
            preferredHighlightEnd: height/2
            highlightMoveDuration: 1000
            delegate: Image {
                id: delegate

                property bool isLeaf: model.isLeaf

                width: GridView.view.cellWidth-20
                height: GridView.view.cellHeight-20
                sourceSize.width: GridView.view.cellWidth
                source: model.dotdot ? "../images/folder-video.png" : model.previewUrl ? model.previewUrl : "../images/default-media.png"
                scale: GridView.isCurrentItem ? 1.2 : 1.0
                z: GridView.isCurrentItem ? 2 : 1
                smooth: true
                transformOrigin: {
                    if (GridView.view.count < 6) {
                        return index%2 === 0 ? Item.Top : Item.Bottom;
                    } else {
                        return index%3 === 0 ? Item.Top : index%3 === 2 ? Item.Bottom : Item.Center
                    }
                }

                property variant filepath: model.filepath

                Behavior on scale {
                    NumberAnimation {}
                }

                property bool isActive: GridView.isCurrentItem

                onIsActiveChanged: {
                    if (videoLivePreview.status !== Loader.Ready)
                        return;

                    if (isActive)
                        videoLivePreview.item.play()
                    else
                        videoLivePreview.item.pause()
                }

                Loader {
                    id: videoLivePreview
                    anchors.fill: parent
                    source: runtime.skin.settings.videoLivePreview ? "VideoViewLivePreview.qml" : ""
                    onLoaded: item.sourceUri = delegate.filepath
                }

                Image {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    width: 64
                    height: 64
                    smooth: true
                    source: "../images/folder-video.png"
                    visible: !model.isLeaf && !model.isDotDot
                }

                GridView.onAdd: NumberAnimation {
                    target: delegate
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 500
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.85; color: "transparent" }
                GradientStop { position: 1.0; color: "#aa00B1F2" }
            }
            opacity: matinee.mediaPlayer.active ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }
    }

    Keys.onMenuPressed: root.back()
    Keys.onLeftPressed: gridView.moveCurrentIndexLeft()
    Keys.onRightPressed: gridView.moveCurrentIndexRight()
    Keys.onUpPressed: gridView.moveCurrentIndexUp()
    Keys.onDownPressed: gridView.moveCurrentIndexDown()
    Keys.onEnterPressed: enter()
}
