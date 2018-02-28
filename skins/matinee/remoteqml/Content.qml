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

GridView {
    id: view
    anchors.fill: parent

    signal itemSelected(int id);
    cellWidth: width/2.0
    cellHeight: cellWidth

    property string peerName;
    property string contentTypeString
    // model to be set by Loader!

    delegate: Item {
        id: delegate
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight

        Image {
            id: image

            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            fillMode: Image.PreserveAspectFit

            source: "http://" + view.peerName + ":1337/" + contentTypeString + modelData

            onStatusChanged: {
                if(image.status == Image.Ready)
                    inAnimation.start()
            }

            NumberAnimation {
                id: inAnimation
                target: image;
                property: "anchors.horizontalCenterOffset";
                from: index%2 ? -image.width : image.width;
                to: 0;
                easing.type: Easing.OutElastic
                duration: 1000
            }
        }

        ToolIcon {
            anchors.centerIn: parent
            iconId: "toolbar-up";
            visible: modelData == -1
        }

        Text {
            anchors.centerIn: parent
            text: "?"
            font.pixelSize: delegate.height
            visible: image.status == Image.Error
        }

        MouseArea {
            anchors.fill: parent
            onClicked: itemSelected(modelData)
        }

        BusyIndicator {
            id: placeHolder
            platformStyle: BusyIndicatorStyle { size: "large" }
            running: image.status == Image.Loading && modelData != -1
            visible: image.status == Image.Loading && modelData != -1
            anchors.centerIn: parent
        }
    }
}
