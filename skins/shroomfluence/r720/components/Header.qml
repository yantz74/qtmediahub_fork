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
import "uiconstants.js" as UIConstants

Item {
    height: 32
    z: UIConstants.screenZValues.header
    property int leftBorder: 0
    property int rightBorder : 200

    property bool atTop   : true
    property bool atRight : true
    property bool expanded : true

    anchors.top: atTop ? confluence.top : undefined
    anchors.bottom: atTop ? undefined : confluence.bottom

    x: expanded ? (atRight ? confluence.width - width : 0) : (atRight ? confluence.width : -width)

    Behavior on x { ConfluenceAnimation { } }

    BorderImage {
        anchors.fill: parent
        source: themeResourcePath + "/media/header.png"
        border.left: leftBorder
        border.right: rightBorder
        smooth: true
        transform: Rotation {
            // if it's not top and left I need to rotate it around different axis
            angle: (!atTop || atRight) ? 180 : 0
            axis { x: ((!atTop && !atRight) ? 1 : 0);
                   y: (( atTop &&  atRight) ? 1 : 0);
                   z: ((!atTop &&  atRight) ? 1 : 0) }
            origin { x: width/2; y: height/2 }
        }
    }
}


