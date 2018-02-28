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
import ActionMapper 1.0
import ContextContent 1.0

Page {
    id: root
    tools: commonTools

    function showButtonInput() {
        if (pageStackItem.busy || pageStackItem.currentPage == buttonTab)
            return;
        buttonInputButton.checked = true
        showPage(buttonTab)
    }

    function showMouseInput() {
        if (pageStackItem.busy || pageStackItem.currentPage == touchPadTab)
            return;
        mouseInputButton.checked = true
        showPage(touchPadTab)
    }

    function showTextInput() {
        if (pageStackItem.busy || pageStackItem.currentPage == keyBoardTab)
            return;
        textInputButton.checked = true
        showPage(keyBoardTab)
    }

    function showContent() {
        if (pageStackItem.busy || pageStackItem.currentPage == contentTab)
            return;
        contentButton.checked = true
        showPage(contentTab)
    }

    function showPage(page) {
        if (pageStackItem.busy)
            return;

        pageStackItem.replace(page)
    }

    PageStack {
        id: pageStackItem

        anchors.top: controlSwitchRow.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Page {
            id: contentTab
            ContextContent {
                id: contextContent
                onRemoteModelChanged: {
                    if(contentLoader.status == Loader.Ready)
                        contentLoader.item.model = contextContent.remoteModel
                }

                onContextUrlChanged: {
                    if(contextUrl == "" && pageStackItem.currentPage == contentTab)
                        showButtonInput()
                }
            }
            Text {
                anchors.centerIn: parent
                font.pixelSize: 60
                text: "Currently\n   no Content!"
                visible: contextContent.contextUrl == ""
            }
            Loader {
                id: contentLoader
                anchors.fill: parent

                source: contextContent.contextUrl;
                onLoaded: {
                    contentLoader.item.model = contextContent.remoteModel
                    contentLoader.item.peerName = contextContent.peerName
                }

                Connections {
                    target: contentLoader.item
                    onItemSelected: appWindow.rpc.call("contextContent.selectItemById", id)

                }
            }
        }

        Page {
            id: touchPadTab
            orientationLock: PageOrientation.LockPortrait

            Trackpad {
                id: trackpad
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 20
            }
        }

        Page {
            id: keyBoardTab
            orientationLock: PageOrientation.LockLandscape

            VirtualKeyboard {
                id: virtualKeyboard
                anchors.fill: parent

                onKeyEvent: appWindow.rpc.call("qmhrpc.processKey", event.charCodeAt(0))
                onReturnEvent: appWindow.rpc.call("qmhrpc.processKey", Qt.Key_Return)
                onBackspaceEvent: appWindow.rpc.call("qmhrpc.processKey", Qt.Key_Backspace)
            }
        }

        Page {
            id: buttonTab
            orientationLock: PageOrientation.LockPortrait

            property int squareSize: 130

            Button {
                id: buttonUp
                text: qsTr("up")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Up)
                anchors.bottom: buttonEnter.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10
                width: buttonTab.squareSize
                height: width
            }

            Button {
                id: buttonDown
                text: qsTr("down")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Down)
                anchors.top: buttonEnter.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10
                width: buttonTab.squareSize
                height: width
            }

            Button {
                id: buttonLeft
                text: qsTr("left")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Left)
                anchors.right: buttonEnter.left
                anchors.verticalCenter: buttonEnter.verticalCenter
                anchors.margins: 10
                width: buttonTab.squareSize
                height: width
            }

            Button {
                id: buttonRight
                text: qsTr("right")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Right)
                anchors.left: buttonEnter.right
                anchors.verticalCenter: buttonEnter.verticalCenter
                anchors.margins: 10
                width: buttonTab.squareSize
                height: width
            }

            Button {
                id: buttonEnter
                text: qsTr("OK")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Enter)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: buttonTab.squareSize
                height: width
            }

            Button {
                id: buttonMenu
                text: qsTr("Menu")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Menu)
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 16
                width: buttonTab.squareSize
                height: width
            }

            Button {
                id: buttonContext
                text: qsTr("Context")
                onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.Context)
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 16
                width: buttonTab.squareSize
                height: width
            }

            ButtonRow {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 16
                exclusive: false

                Button {
                    width: 25
                    height: width
                    iconSource: "image://theme/icon-m-toolbar-mediacontrol-previous"
                    onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.MediaPrevious)
                }

                Button {
                    width: 25
                    height: width
                    iconSource: "image://theme/icon-m-toolbar-mediacontrol-stop"
                    onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.MediaStop)
                }


                Button {
                    width: 25
                    height: width
                    iconSource: "image://theme/icon-m-toolbar-mediacontrol-play"
                    onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.MediaPlayPause)
                }


                Button {
                    width: 25
                    height: width
                    iconSource: "image://theme/icon-m-toolbar-mediacontrol-next"
                    onClicked: appWindow.rpc.call("qmhrpc.takeAction", ActionMapper.MediaNext)
                }
            }
        }
    }

    ButtonRow {
        id: controlSwitchRow
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 16

        Button {
            id: buttonInputButton
            text: qsTr("Buttons")
            onClicked: root.showButtonInput()
        }
        Button {
            id: mouseInputButton
            text: qsTr("Touch")
            onClicked: root.showMouseInput()
        }
        Button {
            id: textInputButton
            text: qsTr("Keyboard")
            onClicked: root.showTextInput()
        }
        Button {
            id: contentButton
            text: qsTr("Content")
            enabled: contextContent.contextUrl != ""
            onClicked: root.showContent()
        }
    }

    Component.onCompleted: {
        pageStackItem.replace(buttonTab)
        contextContent.setConnection(appWindow.rpc)
    }
}
