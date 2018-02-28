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
    clip: true

    property bool isFullScreen: false

    property int column
    property int row
    x: parent.itemWidthWithSpace * column + parent.spacingW*0.5;       width: parent.itemWidthWithSpace-parent.spacingW
    y: parent.itemHeightWithSpace * row   + parent.spacingH*0.5;       height: parent.itemHeightWithSpace-parent.spacingH

    property string source: ""
    property Component sourceComponent: null

    property alias childWidth: loader.width
    property alias childHeight: loader.height

    property bool hasSelectFocus: (parent.focusRow == row && parent.focusColumn == column)

    function hijackedMouseClicked() {
        if(root.isFullScreen === false)
            console.debug("WARNING: hijackedMouseClicked(event) but app wasn't fullscreen! This is a bug!")

        root.isFullScreen = false
    }

    states: State {
        when: root.isFullScreen; name: "fullScreen";
        PropertyChanges { target: root; x: 0; y: 0; z: 10; width: parent.width; height: parent.height }
        PropertyChanges { target: rapid.qtcube; mouseAreaHijackItem: root }
    }

    transitions: [
        Transition { to: "fullScreen"
            SequentialAnimation {
                PropertyAction { target: root; properties: "z"; }
                NumberAnimation { target: root; properties: "x,y,width,height"; duration: 600; easing.type: Easing.OutBounce }
            } },
        Transition { from: "fullScreen"
            SequentialAnimation {
                NumberAnimation { target: root; properties: "x,y,width,height"; duration: 600; easing.type: Easing.OutBounce }
                PropertyAction { target: root; properties: "z"; }
            } }
    ]

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            root.isFullScreen = true
            root.parent.setFocusCoord(root.row, root.column)
        }
        z: root.isFullScreen ? 0 : 2
        //enabled: !root.isFullScreen <= don't do this, mousearea needed as not-able-to-click-through
    }

    Item { id: outline;
        anchors.fill: parent
        Rectangle {
            color: "black"
            border.color: "silver"
            border.width: root.hasSelectFocus ? 8 : 2
            anchors.fill: parent
            anchors.margins: 2
        }
        Rectangle {
            color: "transparent"
            border.color: "white"
            border.width: root.hasSelectFocus ? 4 : 1
            anchors.fill: parent
            anchors.margins: 7
        }
    }

    Loader {
        id: loader;

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        onVisibleChanged: {
            if(loader.visible == false) {
                loader.source = ""
                loader.sourceComponent = null
            }
            else if(root.source !== "")
                loader.source = root.source
            else if(root.sourceComponent !== null)
                loader.sourceComponent = root.sourceComponent
        }

        scale: Math.min(1, Math.min(root.height*0.9/loader.height, root.width*0.9/loader.width))

        onLoaded: { item.clip = true }
    }


    Component.onCompleted: {
        parent.addItem(root, row, column)
//        parent.delegateArray[parent.index(column, row)] = a1
    }
}
