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

Item {
    id: root
    anchors.fill: parent

    function oneUp() {          rootMenuList.decrementCurrentIndex();   }
    function oneDown() {        rootMenuList.incrementCurrentIndex();   }
    function getCurrentIndex() { return rootMenuList.currentIndex; }
    function setCurrentIndex(index) { rootMenuList.currentIndex = index; }


    function switchMenu() {
        if(root.state == "collapsed")
            root.state = "extended"
        else
            root.state = "collapsed"
    }

    states: [
        State { name: "collapsed"
            PropertyChanges { target: menu; x: -menu.width; opacity: 0 }
            PropertyChanges { target: sideBarRotation; angle: 0 }
        },
        State { name: "extended"
            PropertyChanges { target: menu; x: -5; opacity: 0.8}
            PropertyChanges { target: sideBarRotation; angle: -90 }
        }
    ]

    transitions: [
        Transition { to: "extended"
            SequentialAnimation {
                ScriptAction { script: rapid.forceActiveFocus() }
                NumberAnimation { properties: "angle"; duration: 500; easing.type: Easing.Linear}
                NumberAnimation { properties: "x,opacity"; duration: 1000; easing.type: Easing.OutBounce}
            }
        },
        Transition { to: "collapsed"
            SequentialAnimation {
                NumberAnimation { properties: "x,angle,opacity"; duration: 1000; easing.type: Easing.OutBounce}
                ScriptAction { script: rapid.selectedElement.forceActiveFocus() }
            }
        }
    ]

    MouseArea {
        enabled: root.state == "extended"
        anchors.fill: parent
        onClicked: { root.state = "collapsed" }
    }

    Item {
        id: menu

        width: menuPic.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom


        BorderImage {
            id: menuPic
            source: "./images/menu.png"

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            border.left: 0; border.top: 90
            border.right: 0; border.bottom: 90
        }

        PathView {
            id: rootMenuList
            anchors.fill: parent

            pathItemCount: 6
            path: Path { // TODO... values..
                startX: menu.width-220
                startY: -rapid.menuFontPixelSize

                PathQuad {
                    x: menu.width-230
                    y: menu.height + rapid.menuFontPixelSize
                    controlX: menu.width-140
                    controlY: menu.height/2.0 - rapid.menuFontPixelSize
                }
            }

            dragMargin: 1000

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            highlightRangeMode: PathView.StrictlyEnforceRange

            model: rapid.rootMenuModel
            delegate: RootMenuListItem { }
        }
    }

    BorderImage {
        id: sideBar
        source: "./images/sidebar.png"

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        border.left: 20; border.top: 90
        border.right: 0; border.bottom: 90

        MouseArea {
            anchors.fill: parent
            onClicked: root.switchMenu();
        }

        transform: Rotation { id: sideBarRotation; origin.x: 0; origin.y: sideBar.height/2.0; axis { x: 0; y: 1; z: 0 } angle: 0}
    }
}



