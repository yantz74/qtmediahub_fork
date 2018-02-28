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

import Qt 4.7

FocusScope {
    id: root
    width: 200
    height: 600
    state: "off"
    focus: true

    property alias mModel : view.model
    property alias mView : view

    Rectangle {
        color: "black"
        opacity: 0.8
        anchors.fill: parent
    }

    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: 10
        model: settings.audioSources
        focus: true

        delegate: FocusScope {
            property string mFolder : model.modelData.path

            id: listDelegate
            width: view.width
            height: childrenRect.height

            Row {
                Image {
                    id: delegateImage
                    source: settings.themePath + "icons/" + model.modelData.icon
                    smooth: true
                    fillMode: Image.PreserveAspectFit;
                    width: 64
                    height: 64
                }

                Text {
                    id: delegateText
                    text: model.modelData.name
                    color: "white"
                    font.pixelSize: 24
                    anchors.verticalCenter: delegateImage.verticalCenter
                    clip: true
                    width: listDelegate.width - delegateImage.width
                }
            }

            state: view.currentIndex == index ? "focus" : "default"
            transformOrigin: "Left"
            smooth: true

            states: [
                State { name: "default"; PropertyChanges { target: listDelegate; opacity: 0.5; scale: 0.9} },
                State { name: "focus"; PropertyChanges { target: listDelegate; opacity: 1.0; scale: 1.0} }
            ]

             transitions: Transition {
                 ParallelAnimation {
                    PropertyAnimation { properties: "opacity,scale"; }
                }
             }
        }
    }

    states: [
        State { name: "off"; PropertyChanges { target: root; x: -root.width } },
        State { name: "on"; PropertyChanges { target: root; x: 0 } }
    ]

     transitions: Transition {
         PropertyAnimation { properties: "x"; duration: 300; easing.type: Easing.InOutQuad }
     }
}
