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
import "./components/uiconstants.js" as UIConstants
import "components/"

BorderImage {
    id: root
    property string currentPath: runtime.mediaScanner.currentScanPath

    clip: true
    border { top: 17; right: 14; bottom: 17; left: 14 }
    source: themeResourcePath + "/media/InfoMessagePanel.png"
    width: 350
    height: currentPathText.height * 4
    z: UIConstants.windowZValues.popupWindow
    anchors.bottom: parent.bottom
    anchors.bottomMargin: -height
    anchors.right: parent.right
    anchors.rightMargin: 50

    state: currentPath == "" ? "" : "visible"

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root.anchors; bottomMargin: 0 }
        }
    ]
    
    transitions: [
        Transition {
            ConfluenceAnimation { property: "bottomMargin" }
        }
    ]

    Column {
        id: column
        spacing: 5
        anchors.fill: parent
        anchors { topMargin: border.top; leftMargin: 30; rightMargin: root.border.right; bottomMargin: root.border.bottom }
        Text {
            text: qsTr("Loading media info from files...")
            color: "magenta"
        }
        Text {
            id: currentPathText
            color: "white"
            text: root.currentPath
            width: parent.width
            elide: Text.ElideRight
        }
    }
}

