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
import "util.js" as Util

FocusScope {
    id: root
    anchors.fill: parent
    opacity: 0
    scale: 1
    z: delphin.layerViews

    property string mediaType

    function showDialogAddMediaSourceDialog() {
        delphin.hideOptionDialog();
        addMediaDialog.open();
        addMediaDialog.focus = true;
    }

    function showDialogRemoveMediaSourceDialog() {
        delphin.hideOptionDialog();
        removeMediaDialog.open();
        removeMediaDialog.focus = true;
    }

    function refreshSearchPaths() {
        delphin.hideOptionDialog();
        runtime.mediaScanner.refresh(root.mediaType);
    }

    AddMediaSourceDialog {
        id: addMediaDialog
        parent: delphin
        mediaType: root.mediaType
        onClosed: delphin.currentElement.focus = true
    }

    RemoveMediaSourceDialog {
        id: removeMediaDialog
        parent: delphin
        mediaType: root.mediaType
        onClosed: delphin.currentElement.focus = true
    }

    transform: Rotation { id: rootTransform; origin.x: root.width/2.0; origin.y: 0; angle: -90; axis { x: 1; y: 0; z: 0}}

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: rootTransform
                angle: 0
            }
            PropertyChanges {
                target: root
                opacity: 1
                scale: 1
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "opacity"; duration: 350; easing.type: Easing.InQuad}
            NumberAnimation { properties: "angle"; duration: 350; easing.type: Easing.InQuad}
        }
    ]

    property list<QtObject> actionList: [
        Action {
            text: qsTr("Back")
            icon: "go-previous.png"
            onTriggered: { delphin.hideOptionDialog(); delphin.showMainMenu() }
        },
        Action {
            text: qsTr("Refresh")
            icon: "refresh.png"
            onTriggered: { root.refreshSearchPaths() }
        },
        Action {
            text: qsTr("New Source")
            icon: "folder-new.png"
            onTriggered: root.showDialogAddMediaSourceDialog()
        },
        Action {
            text: qsTr("Remove Source")
            icon: "folder-red.png"
            onTriggered: root.showDialogRemoveMediaSourceDialog()
        }]

    Keys.onContext1Pressed: delphin.showOptionDialog(actionList)
}

