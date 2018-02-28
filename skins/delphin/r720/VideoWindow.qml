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
import Playlist 1.0
import "util.js" as Util
import MediaModel 1.0

MediaWindow {
    id: root

    mediaType: "video"

    MediaModel {
        id: videoModel
        mediaType: root.mediaType
        structure: "show|season|title"
    }

    BorderImage {
        id: background
        source: themeResourcePath + "ContentPanel2.png"
        anchors.fill: parent
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }

    GridView {
        id: mediaView
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 90
            leftMargin: 90
            rightMargin: 90
        }
        height: 400
        focus: true
        model: videoModel
        flow: GridView.TopToBottom
        cellHeight: 200
        cellWidth: 200
        delegate: VideoWindowDelegate {}

        Keys.onBackPressed: videoModel.back()
    }

    Item {
        id: currentTextContainer
        anchors.top: mediaView.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right

        Text {
            id: currentText
            text: mediaView.currentItem ? mediaView.currentItem.itemData.display : ""
            color: "white"
            font.pixelSize: delphin.bigFontSize
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Behavior on text {
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: currentText; property: "opacity"; to: 0.1; duration: 100 }
                        NumberAnimation { target: currentText.anchors; property: "horizontalCenterOffset"; to: -currentTextContainer.width/2 - currentText.width }
                    }
                    PropertyAction {  }
                    NumberAnimation { target: currentText.anchors; property: "horizontalCenterOffset"; to: currentTextContainer.width; duration: 0 }
                    ParallelAnimation {
                        NumberAnimation { target: currentText; property: "opacity"; to: 1; duration: 100 }
                        NumberAnimation { target: currentText.anchors; property: "horizontalCenterOffset"; to: 0; duration: 250 }
                    }
                }
            }
        }
    }
}

