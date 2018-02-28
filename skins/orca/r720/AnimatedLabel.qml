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

Text {
    id: container
    text : " "
    color : "white"
    font.pixelSize: 42
    smooth: true

    property bool scaleAnim: true

    SequentialAnimation {
        id: anim1
        ParallelAnimation {
            NumberAnimation { target: container; property: "opacity"; to: 0.1; duration: 200 }
            NumberAnimation { target: container; property: "scale"; to: 2; duration: 200 }
        }
        PropertyAction {  }
        NumberAnimation { target: container; property: "scale"; to: 0.2; duration: 0 }
        ParallelAnimation {
            NumberAnimation { target: container; property: "opacity"; to: 1; duration: 200 }
            NumberAnimation { target: container; property: "scale"; to: 1.0; duration: 200 }
        }
    }

    SequentialAnimation {
        id: anim2
        ParallelAnimation {
            NumberAnimation { target: container; property: "y"; to: container.height; duration: 200 }
            NumberAnimation { target: container; property: "opacity"; to: 0; duration: 200 }
        }
        PropertyAction {  }
        ParallelAnimation {
            NumberAnimation { target: container; property: "y"; to: 0; duration: 200 }
            NumberAnimation { target: container; property: "opacity"; to: 1; duration: 200 }
        }
    }

    Behavior on text {
        animation: scaleAnim ? anim1 : anim2
    }
}
