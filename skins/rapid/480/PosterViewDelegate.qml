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
import ActionMapper 1.0

Item {
    id: delegateItem
    property variant itemdata : model
    width: delegateItem.PathView.view.delegateWidth
    height: delegateItem.PathView.view.delegateHeight
    clip: true
    scale: delegateItem.PathView.scale ? delegateItem.PathView.scale : 1.0
    opacity : delegateItem.PathView.opacity ? delegateItem.PathView.opacity : 1.0
    z: delegateItem.PathView.z ? delegateItem.PathView.z : 1

    transform: Rotation {
        axis { x: 0; y: 1; z: 0 }
        origin { x: width/2 }
        angle: delegateItem.PathView.rotation ? delegateItem.PathView.rotation : 0
    }

    PathView.onIsCurrentItemChanged: { // QTBUG-16347
        if (delegateItem.PathView.isCurrentItem)
            delegateItem.PathView.view.currentItem = delegateItem
    }

    property int frameMargin: 6

    Image {
        id: backgroundImage
        source: model.previewUrl ? model.previewUrl : themeResourcePath + "/media/Fanart_Fallback_Music_Small.jpg"

        anchors.centerIn: parent
        width: (sourceSize.width > sourceSize.height ? delegateItem.width : (sourceSize.width / sourceSize.height) * delegateItem.width) - frameMargin*2
        height: (sourceSize.width <= sourceSize.height ? delegateItem.height : (sourceSize.height / sourceSize.width) * delegateItem.height) - frameMargin*2
    }

    function activate()
    {
        var visualDataModel = delegateItem.PathView.view.model
        if (model.hasModelChildren) {
            visualDataModel.rootIndex = visualDataModel.modelIndex(index)
            delegateItem.PathView.view.currentIndex = 0 // Not sure what this line does
            delegateItem.PathView.view.rootIndexChanged() // Fire signals of aliases manually, QTBUG-14089
            visualDataModel.model.layoutChanged() // Workaround for QTBUG-16366
        } else {
            delegateItem.PathView.view.currentIndex = index;
            delegateItem.PathView.view.activated()
        }
    }

    MouseArea {
        anchors.fill: backgroundImage;

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked:
            if (mouse.button == Qt.LeftButton) {
                delegateItem.PathView.view.clicked()
                delegateItem.activate()
            } else {
                PathView.view.rightClicked(delegateItem.x + mouseX, delegateItem.y + mouseY)
            }
    }

    Keys.onEnterPressed: { delegateItem.activate(); event.accepted = true }
}

