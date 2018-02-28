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

FocusScope {
    id: root
    property alias view : container
    property alias model : container.model
    property variant activeView: container

    signal activated(variant visualElement, string url)

    opacity: 0
    scale: 1
    z: 2
    anchors.topMargin: height

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
                scale: 1
                anchors.topMargin: 0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "topMargin,opacity,scale"; duration: 350; easing.type: Easing.InQuad}
        }
    ]

    property list<QtObject> actionList: [
        Action {
            text: qsTr("Quit")
            icon: "application-exit.png"
            onTriggered: Qt.quit()
        },
        Action {
            text: qsTr("Shutdown")
            icon: "system-shutdown.png"
            onTriggered: runtime.powerManager.shutdown()
        },
        Action {
            text: qsTr("Restart")
            icon: "system-reboot.png"
            onTriggered: runtime.powerManager.restart()
        },
        Action {
            text: qsTr("Suspend")
            icon: "system-suspend.png"
            onTriggered: runtime.powerManager.suspend()
        }]

    function activate() {
        if (container.model) {
            root.activated(container.model.get(container.currentIndex).visualElement, container.model.get(container.currentIndex).url);
        }
    }

    PathView {
        id : container

        Component {
            id: delegate

            Item {
                id: delegateItem
                width: childrenRect.width
                height: childrenRect.height
                scale: PathView.scale
                opacity: PathView.opacity
                z: PathView.z

                Image {
                    id: iconImage
                    source: model.icon
                    smooth: true
                }

                MouseArea {
                    anchors.fill:parent;
                    onClicked: delphin.show(model.visualElement, model.url);
                }
            }
        }

        opacity: root.activeView == container ? 1 : 0.2
        Behavior on opacity {
            NumberAnimation {}
        }

        anchors.fill: parent
        delegate: delegate
        preferredHighlightBegin : 0.5
        preferredHighlightEnd : 0.5
        dragMargin: width
        path: Path {
            startX: -200; startY: container.height/2.0
            PathAttribute { name: "scale"; value: 0.5 }
            PathAttribute { name: "opacity"; value: 0.5 }
            PathAttribute { name: "z"; value: 1 }
            PathLine { x: container.width/2.0-200; y: container.height/2.0 }
            PathAttribute { name: "scale"; value: 0.6 }
            PathLine { x: container.width/2.0; y: container.height/2.0 }
            PathAttribute { name: "scale"; value: 1.5 }
            PathAttribute { name: "opacity"; value: 1.0 }
            PathAttribute { name: "z"; value: 2 }
            PathLine { x: container.width/2.0+200; y: container.height/2.0 }
            PathAttribute { name: "scale"; value: 0.6 }
            PathLine { x: container.width+200; y: container.height/2.0 }
            PathAttribute { name: "scale"; value: 0.5 }
            PathAttribute { name: "opacity"; value: 0.5 }
            PathAttribute { name: "z"; value: 1 }
        }
        focus: true

        Keys.onRightPressed: container.incrementCurrentIndex();
        Keys.onLeftPressed: container.decrementCurrentIndex();
        Keys.onEnterPressed: root.activate();
        Keys.onDownPressed: delphin.showOptionDialog(actionList)
        Keys.onUpPressed: delphin.showOptionDialog(actionList)
        Keys.onBackPressed: delphin.showOptionDialog(actionList)
        Keys.onContext1Pressed: delphin.showOptionDialog(actionList);

        AnimatedLabel {
            text: container.model.get(container.currentIndex) ? container.model.get(container.currentIndex).name : ""
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            font.pixelSize: 42
        }
    }
}
