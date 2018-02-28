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
import QtMobility.systeminfo 1.1
import "components/"

Window {
    id: root

    Keys.onUpPressed: infoViewport.contentY = Math.max(0, infoViewport.contentY - 20)
    Keys.onDownPressed: infoViewport.contentY = Math.min(infoViewport.contentHeight - height, infoViewport.contentY + 20)

    NetworkInfo {
        id: networkInfo
        mode: NetworkInfo.EthernetMode
    }

    Panel {
        anchors.centerIn: parent;

        Flickable {
            id: infoViewport
            flickableDirection: Flickable.VerticalFlick
            contentWidth: textFlow.width
            contentHeight: textFlow.height
            width: textFlow.width
            height: confluence.height - 200
            Flow {
                id: textFlow
                width: confluence.width - 100
                flow: Flow.TopToBottom
                ConfluenceText { id: heading; font.pointSize: 26; text: "System Information"; horizontalAlignment: Qt.AlignHCenter; width: parent.width; font.weight: Font.Bold }
                Item { width: heading.width; height: heading.height }
                ConfluenceText { text: "Network Information"; horizontalAlignment: Qt.AlignHCenter; width: parent.width; font.weight: Font.Bold }
                ConfluenceText { text: "Mac address: " + networkInfo.macAddress }
                ConfluenceText { text: "Network status: " + networkInfo.networkStatus }
                ConfluenceText { text: "Network name: " + networkInfo.networkName }
                ConfluenceText { text: "Network signal strength: " + networkInfo.networkSignalStrength }
                //ConfluenceText { text: "cpu: " + runtime.file.readLines("/proc/cpuinfo") }
                Item { width: heading.width; height: heading.height }
                ConfluenceText { text: "CPU Information"; horizontalAlignment: Qt.AlignHCenter; width: parent.width; font.weight: Font.Bold }

                Repeater {
                    model: runtime.file.readLines("/proc/cpuinfo")
                    ConfluenceText { font.pointSize: 12; text: modelData; wrapMode: Text.WordWrap; width: textFlow.width }
                }
            }
        }
    }
}
