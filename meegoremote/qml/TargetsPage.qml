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
import com.nokia.meego 1.0

Page {
    id: root
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    signal connectToIp(string ip)

    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 16
        text: qsTr("Select Device")
        platformStyle: LabelStyle {
            fontPixelSize: 40
        }
    }

    ListView {
        id: devicesView

        anchors {
            top: label.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            rightMargin: 16
            leftMargin: 16
            topMargin: 16
        }

        model: appWindow.devices
        clip: true
        spacing: 10

        delegate: Rectangle {
            id: delegate
            width: ListView.view.width
            height: 80
            color: delegateMouseArea.containsMouse ? "lightgray" : "transparent"
            radius: 10
            smooth: true

            Behavior on color {
                ColorAnimation { }
            }

            Label {
                id: nameLabel
                text: model.name
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 6
                platformStyle: LabelStyle {
                    fontPixelSize: 30
                }
            }

            Label {
                id: ipLabel
                text: model.ip
                anchors.top: nameLabel.bottom
                anchors.left: nameLabel.left
                anchors.margins: 6

                platformStyle: LabelStyle {
                    fontPixelSize: 20
                    textColor: "gray"
                }
            }

            MouseArea {
                id: delegateMouseArea
                anchors.fill: parent
                onClicked: root.connectToIp(model.ip)
            }

            Button {
                anchors.right: deleteButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16
                width: 50
                height: width
                iconSource: "image://theme/icon-m-toolbar-edit"
                onClicked: {
                    updateDeviceSheet.idx = model.index
                    updateDeviceSheet.name = model.name
                    updateDeviceSheet.ip = model.ip
                    updateDeviceSheet.open()
                }
            }

            Button {
                id: deleteButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16
                width: 50
                height: width
                iconSource: "image://theme/icon-m-toolbar-delete"
                onClicked: { deviceDeleteDialog.name = model.name; deviceDeleteDialog.open() }
            }
        }
    }

    DeviceDeleteDialog {
        id: deviceDeleteDialog
        onAccepted: {
            appWindow.devices.removeDevice(deviceDeleteDialog.name)
            deviceDeleteDialog.name = ""
        }
    }

    UpdateDeviceSheet {
        id: updateDeviceSheet
    }
}
