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
import "components/"

Window {
    id: root

    property Item animationItem

    onVisibleChanged:
        if (!visible && animationItem)
            animationItem.destroy()

    RotationAnimation {
        target: rotation
        running: true
        from: 0
        to: 360
        duration: 30000
        properties: "angle"
        loops: Animation.Infinite
    }

    Flipable {
        id: flipable
        anchors.centerIn: parent
        width: backPanel.width; height: backPanel.height
        smooth: true

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2; origin.y: flipable.height/2
            axis { x: 0; y: 1; z: 0 }
        }

        onSideChanged:
            if (flipable.side == Flipable.Back && !animationItem) {
                var component = Qt.createComponent("qtlogo-animation/startup.qml");
                if (component.status == Component.Ready) {
                    animationItem = component.createObject(placeHolder);
                }
            }

        back: Panel {
            id: backPanel
            Item {
                id: placeHolder
                width: 800; height: 480
            }
        }

        front: Panel {
            id: frontPanel
            anchors.fill: parent
            Flow {
                flow:  Flow.TopToBottom
                Row {
                    ConfluenceText {
                        id: confTxt
                        text: qsTr("All resources and style from") 
                        height: confluenceImage.height
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                    }
                    Image {
                        id: confluenceImage
                        source: themeResourcePath + "/media/Confluence_Logo.png"
                    }
                }
                Row {
                    ConfluenceText { 
                        id: xbmcTxt
                        text: qsTr("Inspired by ") 
                        height: xbmcImage.height
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                    }
                    Image {
                        id: xbmcImage
                        source: themeResourcePath + "/media/XBMC_Logo.png"
                    }
                }
                ConfluenceText { text: "<br/>http://xbmc.org/"}
                ConfluenceText { text: "<br/> <br/> <br/>" + qsTr("QtMediaHub is hosted at %1.").arg("http://gitorious.org/qtmediahub")}
                ConfluenceText { text: "<br/> <br/> " + qsTr("Developed by Girish Ramakrishnan and Donald Carr") }
            }
        }
    }
}

