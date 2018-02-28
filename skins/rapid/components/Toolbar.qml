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

// Toolbar is a component which is displayed
// on the bottom of the display, and it contains
// a set of ToolbarButtons. A button press generates
// an event that is handled in an observing application
Item {
    id: root

//    height: 100

    property int bottomMargin: 4
    // model specifies the set of toolbar buttons (ListModel)
    property alias model: buttons.model

    // Notify that a button has been clicked
    // 'event' parameter specifies the triggered event
    signal btnClicked(string event)

    // Set a button highlighted
    function activateButton(index) {
        buttons.currentItem.selected=false;
        buttons.currentIndex = index;
        buttons.currentItem.selected=true;
    }

    // Black background rectangle with white border
    Rectangle {
        id: background
        border.width: 2
        color: "black"
        border.color:"white"
        width:  parent.width
        height: parent.height
        radius: 15
        opacity: 0.5
    }

    // Arrange the toolbar buttons in a row with ListView.
    // (Unlike Row, ListView provides selection information for list
    // elements + automatic indexing)
    ListView {
        id: buttons
        // model information is assigned dynamically on runtime
        model: {}
        delegate: ToolbarButton {
            MouseArea {
                anchors.fill: parent
                anchors.margins: buttons.spacing/2
                onClicked: {
                    // If the button is enabled, highlight
                    // the button and notify observers
                    if (buttonEnabled) {
                        activateButton(index);
                        root.btnClicked(event);
                    }
                }
            }
        }
        orientation: "Horizontal"
        width: root.width
        height: root.height
        spacing: 15
        interactive: false
    }
}
