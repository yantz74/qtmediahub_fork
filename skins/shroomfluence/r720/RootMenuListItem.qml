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

Item {
    id: menuItem
    width: parent.width; height: entry.height

    property string background: model.background || ""
    property bool hasSubBlade: false
    property alias textColor: entry.color
    property alias text: entry.text

    signal activated(int index)

    anchors.right: parent.right
    states: [
        State {
            name: 'highlighted'
            when: rootMenuList.activeFocus
                  && menuItem.ListView.isCurrentItem
                  && mainBlade.subMenu.state != "open"
            PropertyChanges { target: entry; state: "highlighted" }
            PropertyChanges { target: subIndicator; state: "highlighted" }
        },
        State {
            name: 'selected'
            when: mainBlade.subMenu.state == "open" || !rootMenuList.activeFocus
            PropertyChanges { target: entry; state: menuItem.ListView.isCurrentItem ? "" : "non-selected" }
        }
    ]

    MouseArea {
        id: mr
        anchors.fill: menuItem
        hoverEnabled: true

        onEntered: {
            rootMenuList.currentIndex = index
            rootMenuList.forceActiveFocus()
        }
        onClicked: menuItem.activated(index)
    }

    Keys.onEnterPressed: menuItem.activated(index)

    ConfluenceText {
        id: entry

        anchors.right: parent.right
        anchors.rightMargin: font.pixelSize // keep margin in sync with pixelSize

        transformOrigin: Item.Right
        opacity: 0.3
        scale: 0.5

        font.pixelSize: confluence.width/24 //60
        text: model.name
        horizontalAlignment: Text.AlignRight
        font.weight: Font.Bold

        states: [
            State {
                name: 'highlighted'
                //Scale of 1 actually results in jarring transition from scaled to unscaled
                PropertyChanges { target: entry; scale: 0.9999; opacity: 1 }
            },
            State {
                name: 'non-selected'
                PropertyChanges { target: entry; opacity: 0 }
            }
        ]

        transitions: Transition {
            NumberAnimation { properties: "scale, opacity" }
        }
    }

    Item {
        id: subIndicator
        anchors.fill: menuItem

        Image {
            id: glare
            opacity: 0
            anchors { right: subIndicator.right; bottom: subIndicator.bottom; bottomMargin: -15; rightMargin: -20 }
            source: themeResourcePath + "/media/radialgradient60.png"

            Behavior on opacity {
                SequentialAnimation {
                    // let the indicator flare up
                    NumberAnimation { duration: confluence.standardAnimationDuration / 4; easing.type: confluence.standardEasingCurve }
                    NumberAnimation { to: 0.0; duration: confluence.standardAnimationDuration; easing.type: confluence.standardEasingCurve }
                }
            }
        }

        Image {
            id: symbol
            opacity: 0
            //width: sourceSize.width*confluence.scalingCorrection; height: sourceSize.height*confluence.scalingCorrection
            anchors { right: subIndicator.right; bottom: subIndicator.bottom; bottomMargin: 0; rightMargin: -5 }
            source: themeResourcePath + "/media/HomeHasSub.png"

            /* the behaviour prevents the symbol from vanishing completely again.
            Behavior on opacity {
                SequentialAnimation {
                    NumberAnimation { duration: confluence.standardAnimationDuration * 2; easing.type: confluence.standardEasingCurve }
                }
            }
            */
        }

        visible: hasSubBlade
        smooth: true
        scale: 1

        states: [
            State {
                name: 'highlighted'
                PropertyChanges { target: symbol; opacity: 0.6 }
                PropertyChanges { target: glare; opacity: 0.8 }
            }
        ]
    }
}
