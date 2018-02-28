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
    width: blade.width + blade.x
    height: parent.height
    z: UIConstants.windowZValues.blade
    clip: true

    signal entered
    signal exited
    signal clicked
    signal opened
    signal closed
    signal hidden

    //pixmap specific offset (pixmap alpha!)
    property int bladeRightMargin: 30
    property Item focalWidget: root
    property bool hoverEnabled: false
    property int closedBladePeek: 30

    //Every blade belongs to a window
    property alias associatedWindow: root.parent
    property alias bladeVisibleWidth: blade.visibleWidth
    property alias bladeWidth: blade.width
    property alias bladePixmap: bladePixmap.source
    property alias bladeX: blade.x
    default property alias content: content.children

    function open() {
        if (content.children.length > 0) {
            root.state = "open"
            root.forceActiveFocus()
        }
    }
    function close() {
        //Won't be able to close unless we have a focal widget!
        if (associatedWindow.focalWidget && associatedWindow.focalWidget.visible) {
            associatedWindow.focalWidget.forceActiveFocus()
            if (associatedWindow.maximized)
                state = "hidden"
            else
                state = ""
        }
    }

    onVisibleChanged:
        //Our use of behavior over transitions
        //Makes it unclear how to achieve PropertyAction {}
        //type behavior: hence cleaning up
        if (!visible) state = "hidden"

    states: [
        State {
            name: ""
            StateChangeScript { script: root.closed() }
        },
        State {
            name: "hidden"
            PropertyChanges { target: blade; visibleWidth: 0 }
            StateChangeScript { script: root.hidden() }
        },
        State {
            name: "open"
            PropertyChanges { target: blade; visibleWidth: width }
            StateChangeScript { script: root.opened() }
        }
    ]

    Keys.onContext1Pressed: root.close()
    Keys.onMenuPressed: root.close()

    Item {
        id: blade
        x: -width + visibleWidth
        property int visibleWidth: closedBladePeek
        clip: true
        height: parent.height
        Image {
            id: bladePixmap
            anchors.right: blade.right
            anchors.fill:  parent
        }
        MouseArea {
            hoverEnabled: root.hoverEnabled
            anchors.fill: parent
            onPressed: root.clicked()
            onEntered: root.entered()
            onExited: root.exited()

            // The content has to be a child of the enclosing MouseArea. This is required
            // because if it were a sibling then the enclosing MouseArea would receive a 
            // exited when it enters the content's MouseArea
            Item {
                id: content
                focus: true
                width: parent.width; height: parent.height
            }
        }
        Behavior on x {
            ConfluenceAnimation { }
        }
    }

    Behavior on opacity {
        ConfluenceAnimation { property: "opacity"; }
    }
}
