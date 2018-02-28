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

Item {
    id: delegateItem
    property variant itemdata : model
    width: GridView.view.cellWidth
    height: GridView.view.cellHeight

    GridView.onAdd: if (confluence.shroomfluence) delegateItemAnim.restart()

    NumberAnimation {
        id: delegateItemAnim
        target: delegateItem
        properties: "scale, opacity"
        from: 0
        to: 1
        duration: 200+index*40
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: themeResourcePath + "/media/" + (delegateItem.activeFocus ? "folder-focus.png" : "button-nofocus.png")
    }

    Image {
        id: sourceImg
        width: 142
        height: 142
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        z: 1 // ensure it is above the background
        source: model.dotdot ? themeResourcePath + "/media/DefaultFolderBack.png"
                             : (model.previewUrl != "" ? model.previewUrl : themeResourcePath + "/media/Fanart_Fallback_Music_Small.jpg")
    }

    Text {
        anchors.bottom: sourceImg.bottom
        z: 2 // ensure it is above the background
        width:  sourceImg.width
        text: model.display ? model.display : ""
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
        font.weight: Font.Light
        color: "white"
    }

    function activate() {
        var mediaModel = GridView.view.model
        if (!model.isLeaf) {
            mediaModel.enter(index)
            delegateItem.GridView.view.currentIndex = -1 // QTBUG-21144
        } else {
            GridView.view.currentIndex = index;
            GridView.view.activated()
        }
    }

    MouseArea {
        anchors.fill: parent;
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onEntered: {
            delegateItem.GridView.view.currentIndex = index
            delegateItem.focus = true
        }
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                delegateItem.GridView.view.clicked()
                delegateItem.activate()
            } else {
                delegateItem.GridView.view.rightClicked(delegateItem.x + mouseX, delegateItem.y + mouseY)
            }
        }
    }

    Keys.onEnterPressed: delegateItem.activate()
}

