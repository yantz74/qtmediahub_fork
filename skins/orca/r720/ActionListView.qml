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

ListView {
    id: root

    signal activated()

    width: 400
    height: 200
    orientation: ListView.Vertical
    clip: true
    interactive: true
    highlight: ListViewHighlighter {}

    delegate: Item {
        id: delegateItem
        opacity: delegateItem.ListView.isCurrentItem ? 1 : 0.4
        width: parent.width
        height: delegateText.height
        smooth: true

        Behavior on opacity {
            NumberAnimation {}
        }

        Text {
            id: delegateText
            text: model.modelData.text
            font.pointSize: 16
            font.weight: Font.Light
            color: "white"
            anchors.left: parent.left
            opacity: delegateItem.ListView.isCurrentItem ? 1 : 0.5

            Behavior on opacity {
                NumberAnimation {}
            }
        }

        Text {
            id: delegateOptionText
            text: model.modelData.options[model.modelData.currentOptionIndex]
            font.pointSize: 16
            font.weight: Font.Light
            color: "white"
            anchors.right: parent.right
            opacity: delegateItem.ListView.isCurrentItem ? 1 : 0.5

            Behavior on opacity {
                NumberAnimation {}
            }
        }

        function activate() {
            root.activated()
            model.modelData.trigger()
            if (model.modelData.options.length > 0) {
                model.modelData.currentOptionIndex = (model.modelData.currentOptionIndex + 1) % model.modelData.options.length
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            enabled: model.modelData.enabled

            onEntered: root.currentIndex = index

            onClicked: {
                root.currentIndex = index
                delegateItem.activate()
            }
        }

        Keys.onEnterPressed: model.modelData.enabled ? delegateItem.activate() : undefined
    }
}
