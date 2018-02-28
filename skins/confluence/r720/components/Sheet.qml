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

FocusScope {
    id: root

    property alias title : titleBarText.text
    default property alias content : content.children

    signal opened()
    signal closed()

    x: confluence.width
    y: 0
    width: 600 // arbitrary default
    height: confluence.height
    z: 10

    function open() {
        x = confluence.width - width
        root.opened()
    }

    function close() {
        x = confluence.width
        root.closed()
    }

    Behavior on x {
        NumberAnimation { }
    }

    BorderImage {
        id: panel
        source: themeResourcePath + "/media/DialogBack.png"
        border { top: 5; left: 5; bottom: 5; right: 5; }
        anchors.fill: parent
    }

    Text {
        id: titleBarText
        anchors.top: panel.top
        anchors.right: panel.right
        anchors.left: panel.left
        anchors.topMargin: panel.border.top + 40
        anchors.rightMargin: 20
        color: "white"
        text: "Default dialog title"
        font.bold: true
        font.pointSize: 20
        horizontalAlignment: Text.AlignRight
    }

    Item {
        id: content
        clip: true
        anchors.top: titleBarText.bottom
        anchors.bottom: panel.bottom
        anchors.left: panel.left;
        anchors.right: panel.right
        anchors.topMargin: panel.border.top + 20
        anchors.leftMargin : panel.border.left
        anchors.bottomMargin : panel.border.bottom + 15
        anchors.rightMargin : panel.border.right
    }

    MouseArea {
        parent: confluence
        anchors.fill: parent
    }

    Image {
        id: closeButton
        source: themeResourcePath + "/media/" + (closeButtonMouseArea.pressed ? "DialogCloseButton-focus.png" : "DialogCloseButton.png")
        anchors.top: panel.top
        anchors.left: panel.left
        anchors.leftMargin: panel.border.left + 15 
        anchors.topMargin: panel.border.top + 5
        MouseArea {
            id: closeButtonMouseArea
            anchors.fill: parent;

            onClicked: root.close();
        }
    }

    Keys.onPressed: {
        root.close()
        event.accepted = true
    }
}

