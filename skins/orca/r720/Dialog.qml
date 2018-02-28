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

FocusScope {
    id: root

    property Item focalWidget: root

    width: contentItem.childrenRect.width + contentItem.anchors.leftMargin + contentItem.anchors.rightMargin
    height: contentItem.childrenRect.height + contentItem.anchors.topMargin + contentItem.anchors.bottomMargin

    anchors.centerIn: parent

    property string title /*: titleBarText.text*/
    default property alias content : contentItem.data
    signal accepted
    signal rejected
    signal opened
    signal closed

    opacity: 0
    scale: 0
    state: ""
    visible: false
    z: delphin.layerDialogs

    function accept() {
        close()
        root.accepted()
    }

    function reject() {
        close()
        root.rejected()
    }

    function close() {
        state = ""
        root.closed()
        delphin.blackout.hide()
    }

    function open() {
        state = "visible"
        delphin.blackout.show()
        root.opened()
    }

    onClose: root.parent.forceActiveFocus()

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                visible: true
                opacity: 1
                scale: 1
            }
            PropertyChanges {
                target: delphin.blackout
                opacity: 0.6
            }
        }
    ]

    transitions: [
        Transition {
            to: ""
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; duration: 250; easing.type: Easing.InQuad }
                    NumberAnimation { property: "scale"; duration: 500; easing.type: Easing.InQuad }
                }
                PropertyAction { target: root; property: "visible"; value: false }
            }
        },
        Transition {
            from: ""
            to: "visible"
            SequentialAnimation {
                PropertyAction { target: root; property: "anchors.horizontalCenterOffset"; value: 0 }
                PropertyAction { target: root; property: "visible"; value: true }
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; duration: 500; easing.type: Easing.OutQuad }
                    NumberAnimation { property: "scale"; duration: 500; easing.type: Easing.OutBack }
                }
            }
        }
    ]

    Rectangle {
        id: panel
        color: "black"
        anchors.fill: parent
    }

    Rectangle {
        id: topRect
        color: "steelblue"
        width: parent.width
        height: 1
        anchors.top: parent.top
    }

    Rectangle {
        id: bottomRect
        color: "steelblue"
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
    }

    Item {
        id: contentItem
        anchors.top: panel.top
        anchors.bottom: panel.bottom
        anchors.left: panel.left
        anchors.right: panel.right
        anchors.margins: 10
    }

    Keys.onMenuPressed: root.reject()
}

