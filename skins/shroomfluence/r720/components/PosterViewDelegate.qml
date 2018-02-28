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

Item {
    id: delegateItem
    property variant itemdata : model
    property int frameMargin: 6
    width: PathView.view.delegateWidth
    height: PathView.view.delegateHeight
    clip: true
    scale: PathView.scale ? PathView.scale : 1.0
    opacity : PathView.opacity ? PathView.opacity : 1.0
    z: PathView.z ? PathView.z : 1

    transform: Rotation {
        axis { x: 0; y: 1; z: 0 }
        origin { x: width/2 }
        angle: delegateItem.PathView.rotation ? delegateItem.PathView.rotation : 0
    }

    PathView.onIsCurrentItemChanged: { // QTBUG-16347
        if (PathView.isCurrentItem)
            PathView.view.currentItem = delegateItem
    }

    QtObject {
        id: d
        property string fallbackImagePath: themeResourcePath + "/media/DefaultMusicAlbums.png"
    }

    BorderImage {
        id: border
        anchors.centerIn: parent
        width: backgroundImage.width + frameMargin*2
        height: backgroundImage.height + frameMargin*2
        source: themeResourcePath + "/media/" + "ThumbBorder.png"
        border.left: 10; border.top: 10
        border.right: 10; border.bottom: 10
    }

    Image {
        id: backgroundImage
        source: model.dotdot ? themeResourcePath + "/media/DefaultFolderBack.png" : 
                             (model.previewUrl != "" ? model.previewUrl : d.fallbackImagePath)
        anchors.centerIn: parent
        width: (sourceSize.width > sourceSize.height ? delegateItem.width : (sourceSize.width / sourceSize.height) * delegateItem.width) - frameMargin*2
        height: (sourceSize.width <= sourceSize.height ? delegateItem.height : (sourceSize.height / sourceSize.width) * delegateItem.height) - frameMargin*2
        onStatusChanged:
            if ((status == Image.Error) && (source != d.fallbackImagePath))
                source = d.fallbackImagePath
    }

    Image {
        id: glassOverlay
        anchors.left: backgroundImage.left
        anchors.top: backgroundImage.top
        width: backgroundImage.width * 0.8
        height: backgroundImage.height * 0.6
        source: themeResourcePath + "/media/" + "GlassOverlay.png"
    }

    function activate()
    {
        var mediaModel = PathView.view.model
        if (!model.isLeaf) {
            mediaModel.enter(index)
            PathView.view.currentIndex = -1 // QTBUG-21144
        } else {
            PathView.view.currentIndex = index
            PathView.view.activated()
        }
    }

    MouseArea {
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked:
            if (mouse.button == Qt.LeftButton) {
                delegateItem.PathView.view.clicked()
                delegateItem.activate()
            } else {
                delegateItem.PathView.view.rightClicked(delegateItem.x + mouseX, delegateItem.y + mouseY)
            }
    }

    Keys.onEnterPressed: delegateItem.activate()
}

