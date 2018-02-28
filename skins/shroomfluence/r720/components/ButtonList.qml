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

Flow {
    id: root

    property int upperThreshold: children.length - 1

    property bool wrapping: false
    property int focusedIndex: 0

    signal activity
    signal lowerBoundExceeded
    signal upperBoundExceeded

    Keys.onPressed: {
        root.activity()

        if (event.key == Qt.Key_Left) {
            adjustIndex(-1)
            event.accepted = true;
        } else if (event.key == Qt.Key_Right) {
            adjustIndex(+1)
            event.accepted = true;
        }
    }

    function adjustIndex(delta)
    {
        var exceededLower = false
        var exceededUpper = false

        focusedIndex += delta
        
        //FIXME: surely I can queue these?!
        if(focusedIndex < 0) {
            focusedIndex = wrapping ? upperThreshold : 0
            exceededLower = true
        }
        if(focusedIndex > upperThreshold) {
            focusedIndex = wrapping ? 0 : upperThreshold
            exceededUpper = true
        }

        //Propagate beyond spacers && deactivated items
        (!children[focusedIndex].enabled || children[focusedIndex].children.length == 0)
                && !exceededUpper
                && !exceededLower
            ? adjustIndex(delta)
            : children[focusedIndex].forceActiveFocus() 

        if(exceededLower)
            lowerBoundExceeded()
        if(exceededUpper)
            upperBoundExceeded()
    }

    function focusItem() {
        var index = -1
        for(var i = 0; i < children.length; i++)
            if (children[i].activeFocus)
               index = i
        return index == -1 ? null : children[index]
    }

    function setFocusItem(item) {
        var index = -1

        for(var i = 0; i < children.length; i++)
            if (item == children[i]) 
                index = i

        if (index != -1) {
            children[index].forceActiveFocus()
            activity()
        }
    }

    function resetFocus() {
        focusedIndex = 0
        adjustIndex(0)
    }

    function giveFocus() {
        children[focusedIndex].focus = true
    }

    function focusLowerItem() {
        focusedIndex = 0
        adjustIndex(0)
    }

    function focusUpperItem() {
        focusedIndex = upperThreshold
        adjustIndex(0)
    }

    move: Transition {
        NumberAnimation {
            properties: "x,y"
            easing.type: confluence.standardEasingCurve
        }
    }

    add: Transition {
        NumberAnimation {
            properties: "x,y"
            easing.type: confluence.standardEasingCurve
        }
    }
}

