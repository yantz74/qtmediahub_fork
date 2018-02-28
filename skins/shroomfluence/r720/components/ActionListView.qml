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
import "fontmetrics.js" as FontMetrics

ListView {
    id: root
    signal clicked()
    signal activated()
    property bool hideItemBackground: false

    property int itemHeight
    property int itemWidth

    property int maxWidth: -1
    property int maxHeight: -1

    onModelChanged: {
        // synchronize calculation with ConfluenceText
        var pixelSize = confluence.width/60
        var w = 0, h = 0, ow = 0
        for (var i = 0; i < model.length; i++) {
            if (model[i].options) {
                for (var j = 0; j < model[i].options.length; j++) {
                    ow = Math.max(ow, FontMetrics.calcTextWidth(model[i].options[j], pixelSize, root))
                }
                itemWidth = Math.max(itemWidth, FontMetrics.calcTextWidth(model[i].text, pixelSize, root) + 15 + (ow ? ow + 20 : 0))
            } else {
                itemWidth = Math.max(itemWidth, FontMetrics.calcTextWidth(model[i].text, pixelSize, root) + 15)
            }
            h = Math.max(h, FontMetrics.calcTextHeight(model[i].text, pixelSize, root))
        }

        itemHeight = h + 20
        if (itemWidth <= 200)
            itemWidth = 250

        // check if max width/height is set if, yes check if we exceed it
        if (root.maxWidth < 0)
            root.width = root.itemWidth
        else
            root.width = root.itemWidth > root.maxWidth ? root.maxWidth : root.itemWidth

        if (root.maxHeight < 0)
            root.height = root.itemHeight * root.model.length
        else
            root.height = (root.itemHeight * root.model.length) > root.maxHeight ? root.maxHeight : (root.itemHeight * root.model.length)
    }

    delegate: Item {
        id: delegateItem
        property variant modeldata: model
        width: root.width
        height: itemHeight
        clip: true

        function activate() {
            // ## Order is important for ContextMenu
            root.activated()
            model.modelData.activateNextOption()
        }

        BorderImage {
            id: delegateBackground
            source: themeResourcePath + "/media/button-nofocus.png"
            anchors.fill: parent
            visible: !root.hideItemBackground
            border { left: 10; top: 10; right: 10; bottom: 10 }
        }

        BorderImage {
            id: delegateImage
            source: themeResourcePath + "/media/button-focus.png"
            anchors.centerIn: parent
            width: parent.width-4
            height: parent.height
            opacity: delegateItem.focus && root.focus ? 1 : 0
            border { left: 10; top: 10; right: 10; bottom: 10 }
        }

        ConfluenceText {
            id: delegateText
            color: model.modelData.enabled ? "white" : "gray"
            text: model.modelData.text
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: delegateImage.left
            anchors.leftMargin: 10
            width: delegateImage.width - delegateValue.width - anchors.leftMargin - delegateValue.anchors.rightMargin
            elide: Text.ElideLeft
        }

        ConfluenceText {
            id: delegateValue
            color: model.modelData.enabled ? "white" : "gray"
            text: model.modelData.currentOption
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: delegateImage.right
            anchors.rightMargin: 10
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: model.modelData.enabled

            onEntered: root.currentIndex = index

            onClicked: { 
                root.currentIndex = index
                root.clicked()
                delegateItem.activate() 
            }
        }

        Keys.onEnterPressed: model.modelData.enabled ? delegateItem.activate() : undefined
    }
}

