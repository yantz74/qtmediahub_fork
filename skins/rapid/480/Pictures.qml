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

import QtQuick 1.1
import MediaModel 1.0

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginMore

    function itemActivated() {
        if(posterView.opacity != 0) {
            listView.currentIndex = posterView.currentIndex
            posterView.opacity = 0
            listView.opacity = 1
        }
        else {
            posterView.currentIndex = listView.currentIndex
            posterView.opacity = 1
            listView.opacity = 0

        }
    }

    MediaModel {
        id: pictureModel
        mediaType: "picture"
        structure: "title"
    }

    PosterView {
        id: posterView
        anchors.fill: parent
        posterModel: pictureModel

        onActivated: root.itemActivated()
    }

    ListView {
        id: listView
        opacity: 0
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveSpeed: opacity < 1 ? 99999999 : 1500
        keyNavigationWraps: true

        model: pictureModel
        delegate: Item {
            width: listView.width
            height: listView.height
            Image {
                id: image
                cache: false
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
                source: previewUrl ? previewUrl : themeResourcePath + "/media/Fanart_Fallback_Music_Small.jpg"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.itemActivated()
            }
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Right || event.key == Qt.Key_Down) {
            if(posterView.opacity)
                posterView.incrementCurrentIndex()
            else
                listView.incrementCurrentIndex()

            event.accepted = true
        } else if (event.key == Qt.Key_Left || event.key == Qt.Key_Up) {
            if(posterView.opacity)
                posterView.decrementCurrentIndex()
            else
                listView.decrementCurrentIndex()

            event.accepted = true
        } else if (event.key == Qt.Key_Enter) {
            root.itemActivated()
            event.accepted = true
        }
    }
}
