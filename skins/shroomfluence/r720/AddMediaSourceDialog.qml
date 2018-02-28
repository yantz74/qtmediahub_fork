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
import "components/"
import DirModel 1.0

Dialog {
    id: root

    property variant mediaModel

    onOpened: fileSystemView.focus = true

    Column {
        spacing: 5
        width: 620
        Text {
            id: browseLabel
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("BROWSE FOR THE MEDIA LOCATIONS")
            color: "steelblue"
        }
        TreeView {
            id: fileSystemView

            width: parent.width
            height: 350
            treeModel : DirModel { }
            rootIndex: treeModel.modelIndexForHomePath()
            focus: true
            onRootIndexChanged: sourceNameInput.text = treeModel.baseName(rootIndex)

            Keys.onLeftPressed: sourceNameInput.focus = true
            Keys.onRightPressed: sourceNameInput.focus = true
        }
        Text {
            id: sourceNameLabel
            width: parent.width
            text: qsTr("ENTER A NAME FOR THIS MEDIA SOURCE.")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "steelblue"
        }
        Image {
            id: sourceNameEntry
            width: parent.width
            source: themeResourcePath + "/media/" + (sourceNameEntryMouseArea.containsMouse || sourceNameInput.activeFocus ? "MenuItemFO.png" : "MenuItemNF.png");

            TextInput {
                id: sourceNameInput
                anchors.centerIn: parent
                text: qsTr("Home")
                color: "white"

                Keys.onLeftPressed: buttonBox.focus = true
                Keys.onRightPressed: buttonBox.focus = true
                Keys.onDownPressed: buttonBox.focus = true
                Keys.onUpPressed: fileSystemView.focus = true
            }

            MouseArea {
                id: sourceNameEntryMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sourceNameInput.focus = true
            }
        }
        DialogButtonBox {
            id: buttonBox
            anchors.horizontalCenter: parent.horizontalCenter
            onAccepted: {
                runtime.mediaScanner.addSearchPath(mediaModel.mediaType, fileSystemView.treeModel.filePath(fileSystemView.rootIndex), sourceNameInput.text);
                root.accept()
            }
            onRejected: {
                root.reject()
            }

            Keys.onLeftPressed: fileSystemView.focus = true
            Keys.onRightPressed: fileSystemView.focus = true
            Keys.onDownPressed: fileSystemView.focus = true
            Keys.onUpPressed: sourceNameInput.focus = true
        }
    }
}

