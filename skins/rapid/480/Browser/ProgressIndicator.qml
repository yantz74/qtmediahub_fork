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

Item {
    id: container

    // Relative progress value  between 0-1
    property real progress: 0
    
    // Notifies observers that stop button
    // has been pressed
    signal stopped

    // Position sybcomponents within the backeround component
    Rectangle {
        anchors.fill: parent
        // Use gradient fill in the background
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.5, 0.5, 0.5, 0.8) }
            GradientStop { position: 1.0; color: Qt.rgba(0.1, 0.1, 0.1, 0.8) }
        }

        // Progress bar that expands according to the progress property
        Rectangle {
            width: (parent.width-stopButton.width)*container.progress
            height: parent.height-parent.radius
            y: parent.radius/2
            x: 0
            radius: parent.radius/2
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.0, 0.8, 0.0, 0.8) }
                GradientStop { position: 1.0; color: Qt.rgba(0.0, 0.3, 0.0, 0.8) }
            }
        }

        // Textual presentation of the progress (in per cent)
        Text {
            width: 100
            anchors.centerIn: parent
            text: Math.floor(container.progress * 100) + " %"
            font.pixelSize: 14
            font.bold: true
            color: "lightgrey"
        }

        // Stop button is placed at the right end of the progress indicator
        Rectangle {
            id: stopButton

            width: 80
            height: parent.height
            anchors.right: parent.right
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.8, 0.0, 0.0, 0.8) }
                GradientStop { position: 1.0; color: Qt.rgba(0.3, 0.0, 0.0, 0.8) }
            }

            Text {
                text: "Stop"
                font.pixelSize: 14
                font.bold: true
                color: "lightgrey"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                // Send the signal indicating stop button press
                onClicked: stopped()
            }
        }
    }

    // A named state 'hidden' hides the progress indicator.
    // Otherwise it is visible
    states:
        State {
        name: "hidden"
        PropertyChanges{ target: container; opacity: 0 }
    }

    transitions: [
        Transition {
            to: "hidden"
            reversible: true
            NumberAnimation { properties: "opacity"; easing.type: "InOutQuad"; duration: 500 }
        }
    ]
}
