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
import RpcConnection 1.0
import DeviceList 1.0
import ActionMapper 1.0
import InputContextRpc 1.0
import DeviceDiscovery 1.0

PageStackWindow {
    id: appWindow

    initialPage: targetsPage
    property alias rpc : rpcClient
    property alias devices : deviceList

    DeviceList {
        id: deviceList
    }

    DeviceDiscovery {
        id: deviceDiscovery
        deviceList: deviceList
    }

    // this Timer and handleConnected make sure that the pageStack animation is finished before setting a new page
    Timer {
        id: connectionSettleTimer
        onTriggered: appWindow.handleConnected()
    }

    function handleConnected() {
        if (appWindow.pageStack.busy)
            connectionSettleTimer.restart()
        else
            appWindow.pageStack.push(controlPage)
    }

    InputContextRpc {
        id: inputContextRpc

        onInputPanelStartRequested: {
            controlPage.showTextInput()
        }
        onInputPanelStopRequested: {
            controlPage.showButtonInput()
        }
    }

    RpcConnection {
        id: rpcClient
        property string source
        property int position

        onClientConnected: {
            appWindow.handleConnected()
        }

        onClientDisconnected: {
            appWindow.pageStack.pop(targetsPage)
        }

        function send(ip, port, src, pos) {
            source = src
            position = pos
            connectToHost(ip, port);
        }
    }

    TargetsPage {
        id: targetsPage
        onConnectToIp: {
            appWindow.pageStack.push(busyPage)
            rpcClient.connectToHost(ip, 1234)
        }
    }

    ControlPage {
        id: controlPage
    }

    BusyPage {
        id: busyPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            platformIconId: "toolbar-add";
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: { newDeviceSheet.open() }
            opacity: appWindow.pageStack.currentPage == targetsPage ? 1 : 0
            Behavior on opacity {
                NumberAnimation {}
            }
        }
        ToolIcon {
            platformIconId: "icon-m-toolbar-search";
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: { deviceDiscovery.start() }
            opacity: appWindow.pageStack.currentPage == targetsPage ? 1 : 0
            Behavior on opacity {
                NumberAnimation {}
            }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu";
            anchors.right: parent===undefined ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
            opacity: appWindow.pageStack.currentPage == targetsPage ? 1 : 0
        }
        ToolIcon {
            platformIconId: "toolbar-back";
            anchors.left: parent===undefined ? undefined : parent.left
            onClicked: { appWindow.rpc.disconnectFromHost(); appWindow.pageStack.pop(targetsPage) }
            opacity: appWindow.pageStack.depth > 1 ? 1 : 0
            Behavior on opacity {
                NumberAnimation {}
            }
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("About Remote Control")
                onClicked: aboutDialog.open()
            }
            MenuItem {
                text: qsTr("Remove all devices")
                onClicked: allDeviceDeleteDialog.open()
            }
        }
    }

    NewDeviceSheet {
        id: newDeviceSheet
    }

    AboutDialog {
        id: aboutDialog
    }

    AllDeviceDeleteDialog {
        id: allDeviceDeleteDialog
        onAccepted: {
            appWindow.devices.clear()
        }
    }

    Component.onCompleted: {
        inputContextRpc.setConnection(rpcClient)
    }
}
