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
import Playlist 1.0
import MediaModel 1.0

MediaWindow {
    id: root

    mediaType: "picture"

    Playlist {
        id: imagePlayList
        playMode: Playlist.Normal
    }

    MediaModel {
        id: pictureModel
        mediaType: root.mediaType
        structure: "year|month|filepath"
    }

    function showGrid() {
        listView.opacity = 0;
        mediaView.focus = true;
    }

    function showSlideshow(index) {
        listView.highlightMoveDuration = 0
        listView.currentIndex = index;
        listView.highlightMoveDuration = 500
        listView.opacity = 1;
        listView.focus = true;
    }

    GridView {
        id: mediaView

        anchors.fill: parent
        anchors.margins: 50
        highlightMoveDuration: 250
        keyNavigationWraps: false
        snapMode: GridView.SnapToRow
        model : pictureModel
        clip: false
        focus: true
        cellWidth: width/6.0
        cellHeight: cellWidth

        delegate: Item {
            id: delegateItem
            width: delegateItem.GridView.view.cellWidth
            height: delegateItem.GridView.view.cellHeight
            z: delegateItem.GridView.isCurrentItem ? 2 : 1

            Image {
                id: sourceImg
                anchors.fill: parent
                anchors.margins: 10
                fillMode: Image.PreserveAspectFit
                source: model.dotdot ? themeResourcePath + "go-up.png" : (model.previewUrl ? model.previewUrl : themeResourcePath + "image.png" )
                scale: delegateItem.GridView.isCurrentItem ? 1.3 : 1
                clip: scale == 1 ? true : false

                Behavior on scale { NumberAnimation { duration: 300 } }

                Image {
                    id: folderImg
                    anchors.top: parent.top
                    anchors.left: parent.left
                    sourceSize.width: 64
                    sourceSize.height: 64
                    visible: !model.isLeaf && !model.dotdot
                    source: themeResourcePath + "DefaultFolder.png"
                }
            }

            function activate() {
                if (model.isLeaf) {
                    imagePlayList.clear()
                    imagePlayList.addCurrentLevel(pictureModel)
                    root.showSlideshow(index-1); // remove 1 which is ".." entry
                } else {
                    delegateItem.GridView.view.model.enter(index)
                    mediaView.currentIndex = 0
                }
            }

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                onEntered: {
                    delegateItem.GridView.view.currentIndex = index
                    if (delegateItem.GridView.view.currentItem)
                        delegateItem.GridView.view.currentItem.focus = true
                }
                onClicked: delegateItem.activate()
            }

            Keys.onEnterPressed: delegateItem.activate()
            Keys.onBackPressed: pictureModel.back()

            GridView.onAdd:
                NumberAnimation {
                target: delegateItem
                properties: "scale, opacity"
                from: 0
                to: 1
                duration: 200+index*40
            }
        }

        ScrollBar {
            id: verticalScrollbar
            flickable: mediaView
        }
    }

    // SlideShow
    Rectangle {
        id: blackout
        anchors.fill:  parent
        color: "black"
        opacity: listView.opacity
    }

    ListView {
        id: listView
        opacity: 0
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 500
        highlightMoveSpeed: -1
        highlightFollowsCurrentItem: true
        model: imagePlayList

        function rotateCurrentItem(angle) {
            // ensure to always be 90degree aligned
            listView.currentItem.rotation = Math.round((listView.currentItem.rotation + angle) / 90) * 90
        }

        delegate: Item {
            width: listView.width
            height: listView.height
            Image {
                id: image
                fillMode: Image.PreserveAspectFit
                sourceSize.width: imageThumbnail.width > imageThumbnail.height ? parent.width : 0
                sourceSize.height: imageThumbnail.width <= imageThumbnail.height ? parent.height : 0
                anchors.fill: parent
                source: model.filepath
                asynchronous: true
            }
            Image {
                id: imageThumbnail
                anchors.fill: image
                fillMode: Image.PreserveAspectFit
                visible: image.status != Image.Ready
                source: model.previewUrl
            }

            Behavior on rotation { NumberAnimation {} }
        }

        Behavior on opacity {
            NumberAnimation {}
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.showGrid();
        }

        Keys.onRightPressed: listView.decrementCurrentIndex()
        Keys.onLeftPressed: listView.incrementCurrentIndex()
        Keys.onDownPressed: listView.rotateCurrentItem(90)
        Keys.onUpPressed: listView.rotateCurrentItem(-90)
        Keys.onBackPressed: root.showGrid();
        Keys.onEnterPressed: root.showGrid();
    }

    Keys.onEnterPressed: mediaView.currentItem.activate()
}
