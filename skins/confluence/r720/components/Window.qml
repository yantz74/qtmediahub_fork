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
import "uiconstants.js" as UIConstants

FocusScope {
    id: root
    clip: true

    z: UIConstants.screenZValues.window

    anchors.centerIn: parent

    opacity: 0; visible: false
    scale: 0

    property Item focalWidget: root

    property alias blade: bladeLoader.item

    property int transitionDuration: confluence.standardAnimationDuration

    property bool maximized: false
    property bool maximizable: false

    property int maximizedWidth: confluence.width
    property int maximizedHeight: confluence.height

    property bool deleteOnClose: false


    function show() {
        stateGroup.state = "visible"
    }

    function showMaximized() {
        stateGroup.state = "maximized"
    }

    function close() {
        stateGroup.state = "closed"
    }

    function visibleTransitionFinished() {
        //no impl
    }

    width: confluence.width
    height: confluence.height

    property Component bladeComponent : Blade {
    }

    onMaximizedChanged:
        confluence.state = root.maximized ? "showingSelectedElementMaximized" : "showingSelectedElement"

    StateGroup {
        id: stateGroup

        states: [
            State {
                name: "closed"
                StateChangeScript { name: "hideAdditionalItems"; script: { background.opacity = 0; blade.opacity = 0; if (root.deleteOnClose) root.destroy() } }
            },
            State {
                name: "visible"
                PropertyChanges {
                    target: root
                    visible: true
                    opacity: 1
                    scale: 1
                }
                StateChangeScript { name: "forceActiveFocus"; script: { if (focalWidget) focalWidget.forceActiveFocus() } }
                StateChangeScript { name: "showAdditionalItems"; script: { background.opacity = 0.5; blade.opacity = 1 } }
            },
            State {
                name: "maximized"
                extend: "visible"
                PropertyChanges {
                    target: root
                    width: maximizedWidth
                    height: maximizedHeight
                    anchors.horizontalCenterOffset: 0
                }
                PropertyChanges {
                    target: bladeLoader.item
                    state: "hidden"
                }
            }
        ]

        transitions: [
            Transition {
                to: "closed"
                SequentialAnimation {
                    PropertyAction { target: blade; property: "visible"; value: false }
                    ParallelAnimation {
                        NumberAnimation { property: "opacity"; duration: transitionDuration/2.0; easing.type: confluence.standardEasingCurve }
                        NumberAnimation { property: "scale"; duration: transitionDuration; easing.type: confluence.standardEasingCurve }
                    }
                    PropertyAction { target: root; property: "visible"; value: false }
                    ScriptAction { scriptName: "hideAdditionalItems" }
                }
            },
            Transition {
                to: "visible"
                SequentialAnimation {
                    PauseAnimation { duration: transitionDuration } // wait for main blade to be hidden
                    PropertyAction { target: root; property: "anchors.horizontalCenterOffset"; value: 0 }
                    PropertyAction { target: root; property: "visible"; value: true }
                    ParallelAnimation {
                        NumberAnimation { property: "opacity"; duration: transitionDuration; easing.type: confluence.standardEasingCurve }
                        NumberAnimation { property: "scale"; duration: transitionDuration; easing.type: Easing.OutBack }
                    }
                    ScriptAction { scriptName: "forceActiveFocus" }
                    ScriptAction { scriptName: "showAdditionalItems" }
                    PropertyAction { target: blade; property: "visible"; value: true }
                    PropertyAction { target: blade; property: "state"; value: "" }

                    ScriptAction { script: root.visibleTransitionFinished() }
                }
            },
            Transition {
                reversible: true
                from: "visible"
                to: "maximized"
            }
        ]
    }

    Keys.onContext1Pressed: blade.open()

    Loader {
        id: bladeLoader
        sourceComponent: bladeComponent
    }


    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        opacity: 0

        Behavior on opacity {
            NumberAnimation { property: "opacity"; duration: transitionDuration; easing.type: confluence.standardEasingCurve }
        }
    }
}

