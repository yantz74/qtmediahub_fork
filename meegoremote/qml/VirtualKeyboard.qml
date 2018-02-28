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
import com.nokia.meego 1.0

Item {
    id: root
    anchors.fill: parent

    property bool shift: shiftButton.checked

    signal keyEvent(string event);
    signal returnEvent();
    signal backspaceEvent();

    function createQmlObjectFromFile(file, properties, parent) {
        var qmlComponent = Qt.createComponent(file)
        if (qmlComponent.status == Component.Ready) {
            return qmlComponent.createObject(parent ? parent : this, properties ? properties : {})
        }
        console.log(qmlComponent.errorString())
        return null
    }

    function createKeys(characters, alternatives, parent) {
        for (var i = 0; i < characters.length; ++i) {
            var object = createQmlObjectFromFile("Key.qml", {keyboard: root, character: characters[i], alternative: alternatives[i]}, parent);
        }
    }

    function buildKeyboard() {
        createKeys(['0','1','2','3','4','5','6','7','8','9'], [], row0)
        createKeys(['q','w','e','r','t','y','u','i','o','p'], ['Q','W','E','R','T','Y','U','I','O','P'], row1)
        createKeys(['a','s','d','f','g','h','j','k','l'], ['A','S','D','F','G','H','J','K','L'], row2)
        createKeys(['z','x','c','v','b','n','m'], ['Z','X','C','V','B','N','M'], row3)
    }

    Column {
        id: layout
        spacing: 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        width: parent.width

        Row {
            id: row0
            anchors.horizontalCenter: parent.horizontalCenter
            height: 60
        }
        Row {
            id: row1
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Row {
            id: row2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item {
            width: parent.width
            height: childrenRect.height
            Key {
                iconSource: "image://theme/icon-m-toolbar-backspace"
                onClicked: root.backspaceEvent()
                width: 100
                anchors.right: parent.right
            }
            Row {
                id: row3
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Item {
            width: parent.width
            height: childrenRect.height

            Key {
                id: shiftButton
                iconSource: "image://theme/icon-m-toolbar-up"
                checked: false
                checkable: true
                width: 120
                anchors.left: parent.left
            }
            Key {
                character: ":"
                alternative: "_"
                keyboard: root
                anchors.right: comma.left
            }
            Key {
                id: comma
                character: ","
                alternative: "-"
                keyboard: root
                anchors.right: space.left
            }
            Key {
                id: space
                character: " "
                keyboard: root
                width: 250
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Key {
                id: dot
                character: "."
                alternative: ":"
                keyboard: root
                anchors.left: space.right
            }
            Key {
                id: mail
                character: "@"
                alternative: "/"
                keyboard: root
                anchors.left: dot.right
            }
            Key {
                id: enter
                iconSource: "image://theme/icon-m-toolbar-done"
                onClicked: root.returnEvent()
                width: 120
                anchors.right: parent.right
            }
        }
    }

    Component.onCompleted: {
        root.buildKeyboard();
    }
}
