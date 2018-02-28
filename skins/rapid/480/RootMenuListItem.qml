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
    id: menuItem
    width: parent.width;
    height: entry.height

    function trigger() {
        menuItem.PathView.view.currentIndex = index
        rapid.setActiveElementByIndex(index)
    }
    MouseArea {
        id: mr;
        anchors.fill: menuItem;
        anchors.margins: -15
        onClicked: { trigger() }
    }

    Text {
        id: entry
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter

        text: model.name
        horizontalAlignment: Text.AlignRight
        transformOrigin: Item.Right                 // This is for proper alignment, not for the rotation!
        //      font.family: "Nokia large"
        font.pixelSize: rapid.menuFontPixelSize


        property int indexOffSet: Math.abs(menuItem.PathView.view.currentIndex - index)
        property int focusAnimationDuration: 400

        scale: indexOffSet == 0 ? 0.9999 : 0.6;
        Behavior on scale {  NumberAnimation { duration: entry.focusAnimationDuration; } }

        property int angle: indexOffSet == 0 ? 0 : 360
        Behavior on angle {  NumberAnimation { duration: entry.focusAnimationDuration; } }
        transform: Rotation { origin.x: entry.width/2.0; origin.y: entry.height/2.0; axis { x: 1; y: 0; z: 0 } angle: entry.angle }

        color: indexOffSet == 0 ? "green" : "white"
        Behavior on color { ColorAnimation { duration: entry.focusAnimationDuration; } }
    }
}
