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
//import "../shared"

// Component which displays an
// input field for entering urls
// The component includes a button
// which triggers loading the web page
Item {
    id: container
    property alias url: urlText.input

    signal urlEntered

    // Shows/hides the component
    function setVisible(show) {
        if (show)
            state = 'visible';
        else
            state = 'hidden';
    }

    // By default, UrlInputBox is not visible
    state: 'hidden'

    // Draw background rectangle and text label
    // with InputBox for url and 'GO' button
    Rectangle {
        radius: 10
        border.width: 1
        border.color: "#d5d5d5"
        anchors.left: parent.left
        anchors.right: parent.right
        color: urlText.bgColor
        height: 60

        LabelInputBox {
            id: urlText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:  parent.left
            anchors.leftMargin: 10
            anchors.right: urlGoButton.left
            anchors.rightMargin: 10
            labelWidth: 50
            label: "URL:"
            helpText: "Enter URL"
            input: "http://"
        }

        Rectangle {
            id: urlGoButton

            color: urlText.bgColor
            radius: 8
            border.color: "#d5d5d5"
            border.width: 1
            width: 40
            height: parent.height
            anchors.right: parent.right

            Text {
                text: "Go"
                anchors.centerIn: parent
                color: 'white'
                font.pixelSize: urlText.textSize
            }

            MouseArea {
                anchors.fill: parent
                onClicked: container.urlEntered()
            }
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: container
                height: 60
                anchors.bottomMargin: 0
            }
        },

        State {
            name: "hidden"
            PropertyChanges {
                target: container
                height: 0
                anchors.bottomMargin: 0
                opacity: 0
            }
        }
    ]

    transitions:
        Transition {
        NumberAnimation { properties: "height, bottomMargin, opacity";
            easing.type: "InOutQuad" ; duration: 500 }
    }
}
