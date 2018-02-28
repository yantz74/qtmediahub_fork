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

    property variant device

    property list<QtObject> actionList: [
        ConfluenceAction {
            id: musicAction
            text: qsTr("MUSIC")
            options: [qsTr("off"), qsTr("on")]
        },
        ConfluenceAction {
            id: videoAction
            text: qsTr("VIDEO")
            options: [qsTr("off"), qsTr("on")]
        },
        ConfluenceAction {
            id: pictureAction
            text: qsTr("PICTURE")
            options: [qsTr("off"), qsTr("on")]
        },
        ConfluenceAction {
            id: radioAction
            text: qsTr("RADIO")
            options: [qsTr("off"), qsTr("on")]
        }]

    title: device && device.label != "" ? device.label : qsTr("DEVICE")
    onOpened: listView.focus = true

    Column {
        spacing: 30
        width: 620
        Text {
            id: browseLabel
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("SELECT MEDIA TYPE ON DEVICE")
            color: "steelblue"
        }

        ActionListView {
            id: listView
            focus: true
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height - browseLabel.height - buttonBox.height
            model: root.actionList

            Keys.onLeftPressed: buttonBox.focus = true
            Keys.onRightPressed: buttonBox.focus = true
        }

        DialogButtonBox {
            id: buttonBox
            anchors.horizontalCenter: parent.horizontalCenter
            onAccepted: {
                if (musicAction.currentOptionIndex) {
                    runtime.mediaScanner.addSearchPath("music", root.device.uuid, device.mountPoint);
                }
                if (videoAction.currentOptionIndex) {
                    runtime.mediaScanner.addSearchPath("video", root.device.uuid, device.mountPoint);
                }
                if (pictureAction.currentOptionIndex) {
                    runtime.mediaScanner.addSearchPath("picture", root.device.uuid, device.mountPoint);
                }
                if (radioAction.currentOptionIndex) {
                    runtime.mediaScanner.addSearchPath("radio", root.device.uuid, device.mountPoint);
                }

                root.accept()
            }
            onRejected: {
                root.reject()
            }

            Keys.onUpPressed: listView.focus = true
            Keys.onDownPressed: listView.focus = true
            Keys.onLeftPressed: listView.focus = true
            Keys.onRightPressed: listView.focus = true
        }
    }
}
