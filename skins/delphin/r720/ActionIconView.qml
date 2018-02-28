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

ListView {
    id: root

    signal activated()

    property int delegateSize : 200

    width: model ? delegateSize * model.length : 0
    height: delegateSize
    orientation: ListView.Horizontal
    clip: true
    interactive: true
    opacity: 0
    z: delphin.layerDialogs

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
                anchors.verticalCenterOffset: 0
            }
        }
    ]

    transitions: [
        Transition {
            to: "visible"
            NumberAnimation { properties: "verticalCenterOffset,opacity"; duration: 700; easing.type: Easing.OutBounce}
        },
        Transition {
            NumberAnimation { properties: "verticalCenterOffset,opacity"; duration: 500; easing.type: Easing.InQuad}
        }
    ]

    delegate: Item {
        id: delegateItem
        opacity: delegateItem.ListView.isCurrentItem ? 1 : 0.4
        width: root.delegateSize
        height: width
        smooth: true

        Behavior on opacity {
            NumberAnimation {}
        }

        Image {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height - delegateText.height
            width: height
            source: model.modelData.icon ? delphin.themeResourcePath + model.modelData.icon : ""
        }

        Text {
            id: delegateText
            text: model.modelData.text
            font.pointSize: 16
            font.weight: Font.Light
            color: "white"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: delegateItem.ListView.isCurrentItem ? 1 : 0

            Behavior on opacity {
                NumberAnimation {}
            }
        }

        function activate() {
            root.activated()
            model.modelData.trigger()
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
