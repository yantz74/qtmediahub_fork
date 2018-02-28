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
import DirModel 1.0
import "components/"
import "util.js" as Util

Item {
    id: root
    property variant mediaModel
    property alias currentIndex: posterView.currentIndex
    property alias currentItem: posterView.currentItem

    anchors.fill: parent

    BorderImage {
        id: background
        source: themeResourcePath + "/media/ContentPanel2.png"
        anchors.fill: parent
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }

    function setPathStyle(style) {
        posterView.setPathStyle(style)
    }

    PosterView {
        id: posterView
        anchors.fill: parent
        focus: true
        model: root.mediaModel

        onCurrentItemChanged:
            mediaWindow.itemSelected(currentItem)
        onActivated: {
            mediaWindow.itemActivated(currentItem)
        }

        Keys.onPressed: {
            var itemType = posterView.currentItem ? posterView.currentItem.itemdata.type : ""
            if (itemType == "SearchPath") {
                if (event.key == Qt.Key_Delete) {
                    posterModel.removeSearchPath(currentIndex)
                    event.accepted = true
                }
            }
        }
    }

    ConfluenceText {
        id: currentItemName
        anchors.bottom:  currentItemSize.top
        anchors.bottomMargin: height/2.0
        anchors.horizontalCenter: parent.horizontalCenter
        text: posterView.currentItem && posterView.currentItem.itemdata ? posterView.currentItem.itemdata.display : ""
    }

    ConfluenceText {
        id: currentItemSize
        anchors.bottom:  posterView.bottom
        anchors.bottomMargin: height/2.0
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
        font.bold: false
        color: "steelblue"
        text: posterView.currentItem && posterView.currentItem.itemdata.type == "File" ? Util.toHumanReadableBytes(posterView.currentItem.itemdata.fileSize) : ""
    }
}

