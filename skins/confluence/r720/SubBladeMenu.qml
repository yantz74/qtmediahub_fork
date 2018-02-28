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

FocusScope {
    id: root

    property QtObject engine

    anchors.fill: parent

    ConfluenceListView {
        id: list
        focus: true
        anchors.fill: parent
        scrollbar: false
        model: engine ? engine.actionList : null

        Keys.onEnterPressed: currentItem.trigger()

        delegate: Item {
            id: delegate
            anchors.right: parent.right
            transformOrigin: Item.Right
            width: parent.width
            height: delegateText.height + 20
            focus: true

            Image {
                id: delegateBackground
                source: themeResourcePath + "/media/button-nofocus.png"
                anchors.fill: parent
            }

            Image {
                id: delegateImage
                source: themeResourcePath + "/media/button-focus.png"
                anchors.centerIn: parent
                width: parent.width-2
                height: parent.height
                opacity: 0

            }

            ConfluenceText {
                id: delegateText
                font.pointSize: 16
                text: model.modelData
                horizontalAlignment: Text.AlignRight
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            states:  [
                State {
                    name: "selected"
                    when: list.currentIndex == index
                    PropertyChanges {
                        target: delegateImage
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation { target: delegateImage; property: "opacity"; duration: 200 }
                }
            ]

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    list.currentIndex = index
                    list.forceActiveFocus()
                }

                onClicked: {
                    delegate.trigger()
                }
            }

            function trigger() {
                engine.actionMap["handle" + model.modelData + "Action"]()
            }
        }
    }
}
