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
import Playlist 1.0
import MediaModel 1.0

MediaWindow {
    id: root

    mediaType: "radio"

    MediaModel {
        id: radioModel
        mediaType: root.mediaType
        structure: "title"
        dotDotPosition: MediaModel.End
    }

    ListView {
        id: mediaListView
        model: radioModel

        width: parent.width*0.66
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 50

        focus: true
        clip: true
        highlightRangeMode: ListView.NoHighlightRange
        highlightMoveDuration: 250
        keyNavigationWraps: false
        highlight: ListViewHighlighter {}

        ScrollBar {
            flickable: parent
        }

        delegate: Item {
            id: delegateItem

            property variant itemData : model
            property alias iconItem : delegateIcon

            width: delegateItem.ListView.view.width
            height: sourceText.height + 8
            transformOrigin: Item.Left

            function activate() {
                if (model.isLeaf)
                    avPlayer.playForeground(radioModel, index)
                else
                    musicModel.enter(index)
            }

            Image {
                id: delegateIcon
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                clip:  true
                source: {
                    var icon;
                    if (model.previewUrl != "")
                        return model.previewUrl;
                    else
                        icon = "DefaultAudio.png";
                    return themeResourcePath + "/" + icon;
                }
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: delegateIcon.right
                anchors.leftMargin: 10
                text: model.title
                font.pointSize: 16
                font.weight: Font.Light
                color: "white"
            }

            ListView.onAdd:
                SequentialAnimation {
                NumberAnimation {
                    target: delegateItem
                    properties: "scale, opacity"
                    from: 0
                    to: 1
                    duration: 200+index*40
                }
            }

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton
                onEntered: {
                    delegateItem.ListView.view.currentIndex = index
                    if (delegateItem.ListView.view.currentItem)
                        delegateItem.ListView.view.currentItem.focus = true
                }
                onClicked: delegateItem.activate()
            }

            Keys.onEnterPressed: delegateItem.activate()
        }

        Keys.onLeftPressed: {
            var pageItemCount = height/currentItem.height;
            if (mediaListView.currentIndex - pageItemCount < 0)
                mediaListView.currentIndex = 0;
            else
                mediaListView.currentIndex -= pageItemCount;
        }
        Keys.onRightPressed: {
            var pageItemCount = height/currentItem.height;
            if (mediaListView.currentIndex + pageItemCount > mediaListView.count-1)
                mediaListView.currentIndex = mediaListView.count-1;
            else
                mediaListView.currentIndex += pageItemCount;
        }
    }

    Image {
        id: coverArt
        anchors.left: mediaListView.right
        anchors.leftMargin: 65
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: mediaListView.bottom
        anchors.top: mediaListView.top
        clip:  true
        source: mediaListView.currentItem ? mediaListView.currentItem.iconItem.source : ""
        fillMode: Image.PreserveAspectFit
    }
}

