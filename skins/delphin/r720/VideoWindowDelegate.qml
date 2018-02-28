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

Item {
    id: delegateItem

    property variant itemData : model
    property int frameMargin: 6

    width: GridView.view.cellWidth
    height: GridView.view.cellHeight
    scale: delegateItem.GridView.isCurrentItem ? 1.5 : 1
    z: delegateItem.GridView.isCurrentItem ? 2 : 0
    opacity : 1.0
    smooth: true

    Behavior on scale {
        NumberAnimation { easing.type: Easing.OutBack; duration: 300 }
    }

    transform: Rotation {
        axis { x: 0; y: 1; z: 0 }
        origin { x: width/2 }
        angle: 0
    }

    BorderImage {
        id: border
        anchors.fill: parent
        source: themeResourcePath + "ThumbBorder.png"
        border.left: 10; border.top: 10
        border.right: 10; border.bottom: 10
    }

    Image {
        id: backgroundImage
        source: {
            var icon;
            if (model.dotdot)
                icon = "go-up.png";
            else if (model.previewUrl != "")
                return model.previewUrl;
            else if (delegateItem.GridView.view.model.part == "show" || delegateItem.GridView.view.model.part == "season")
                icon = "DefaultFolder.png";
            else
                icon = "video-file.png";
            return themeResourcePath + "/" + icon;
        }
        anchors.centerIn: parent
        width: delegateItem.width - frameMargin*2
        height: delegateItem.height - frameMargin*2
        asynchronous:true
        fillMode: Image.PreserveAspectCrop
        clip: true
    }

    Image {
        id: glassOverlay
        anchors.left: backgroundImage.left
        anchors.top: backgroundImage.top
        width: backgroundImage.width * 0.8
        height: backgroundImage.height * 0.6
        source: themeResourcePath + "GlassOverlay.png"
    }

    function activate()
    {
        if (model.isLeaf)
            avPlayer.playForeground(GridView.view.model, index)
        else {
            delegateItem.GridView.view.model.enter(index)
            delegateItem.GridView.view.currentIndex = 0
        }
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: delegateItem.activate()
        hoverEnabled: true
        onEntered: delegateItem.GridView.view.currentIndex = index
    }

    Keys.onEnterPressed: delegateItem.activate()
}

