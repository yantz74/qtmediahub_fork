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

// Displays a text input field. Text can be
// entered from physical keyboard, or by activating
// a onscreen keyboard
Item {
    id: container

    property string text
    property string label
    property int pixelSize: 18
    property string color: "white"
    property alias backgroundColor: bg.color

    // Confirms changes made to the text
    function confirm(confirmValue) {
        if (confirmValue)
            container.text = confirmValue;
        else
            container.text = textEdit.text;
        textEdit.focus = false;
    }

    // Cancels any editing, and restores
    // old value to the text field
    function cancel() {
        textEdit.text = container.text;
        textEdit.focus = false;
    }

    height: textEdit.height

    // Handles events received from the
    // onscreen keyboard

    // TODO digia
//    Connections {
//        target: document.properties.keyboard
//        onTextEntered: {
//            // Handle the event in this handler
//            // if the input field is currently focused
//            if (textEdit.activeFocus) {
//                confirm(kbdText);
//                document.properties.keyboard.show = false;
//            }
//        }
//    }

    // Draw a background rectangle
    Rectangle {
        id : bg

        width: container.width-2
        height: container.height+10
        anchors.verticalCenter: parent.verticalCenter
        radius: 8
        color: "#323232"
        border.color: "#d5d5d5"
        border.width: 1
    }

    // Confirm button that accepts changes made in the input field
    Image {
        id: confirmIcon
        width: 22
        height: 22
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/icons/icon_ok.png"
        opacity: 0

        MouseArea {
            anchors.fill: parent
            onClicked: confirm()
        }
    }

    // Cancel button that discards editing
    Image {
        id: cancelIcon

        width: 22
        height: 22
        anchors.right: keyboardIcon.left
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/icons/icon_cancel.png"
        opacity: 0

        MouseArea {
            anchors.fill: parent
            onClicked: cancel()
        }
    }

    // Button that opens onscreen keyboard
    Image {
        id: keyboardIcon

        width: 22
        height: 15
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/icons/icon_keyboard.png"
        opacity: 0

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // When clicking, set default value for
                // the onscreen keyboard and display it
                document.properties.keyboard.label = container.label;
                document.properties.keyboard.initText = textEdit.text;
                document.properties.keyboard.show = true;
            }
        }
    }

    // Standard single line text input
    TextInput {
        id: textEdit

        text: container.text
        color: container.color
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: cancelIcon.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: container.pixelSize
        onAccepted: confirm()
        Keys.onEscapePressed: cancel()
    }

    // Label text providing information what information
    // to enter in the field
    Text {
        id: textLabel

        x: 5
        width: parent.width-10
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: "AlignHCenter"
        color: container.state == "editing" ? "#505050" : "#AAAAAA"
        font.pixelSize: container.pixelSize
        font.italic: true
        font.bold: true
        text: label
        opacity: textEdit.text == '' ? 1 : 0
    }

    // 'Editing' named state is entered when
    // textEdit component receives focus.
    // Icons are displayed, and text slightly re-aligned
    states:
        State {
        name: "editing"
        when: textEdit.activeFocus
        PropertyChanges {
            target: confirmIcon
            opacity: 1
        }
        PropertyChanges {
            target: keyboardIcon
            opacity: 1
        }
        PropertyChanges {
            target: cancelIcon
            opacity: 1
        }
        PropertyChanges {
            target: textEdit
            color: "white"
        }
        PropertyChanges {
            target: textEdit.anchors
            leftMargin: 34
        }
        PropertyChanges {
            target: textEdit.anchors
            rightMargin: 34
        }
    }

    transitions:
        Transition {
        to: "editing"
        reversible: true

        NumberAnimation {
            properties: "opacity,leftMargin,rightMargin"
            duration: 200
        }
    }
}
