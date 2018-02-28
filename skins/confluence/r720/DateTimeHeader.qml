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

Header {
    id: root
    property bool showDate: true
    width: dateTimeText.x + dateTimeText.width + 10
    property variant now

    Timer {
        id: updateTimer
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: { root.now = new Date() }
    }

    function currentTime() {
        var now = new Date();
        return "<span style=\"color:'white'\">" + Qt.formatDateTime(root.now, "hh:mm:ss AP") + "</span>"
    }

    function currentDateTime() {
        return "<span style=\"color:'gray'\">" + Qt.formatDateTime(root.now, "dddd, MMMM dd, yyyy") + " </span> " 
               + "<span style=\"color:'white'\"> | </span>"
               + currentTime()
 
    }

    ConfluenceText {
        id: shadowText

        property string plainCurrentTime: Qt.formatDateTime(root.now, "hh:mm:ss AP")
        property string plainCurrentDateTime: Qt.formatDateTime(root.now, "dddd, MMMM dd, yyyy") + " | " + plainCurrentTime

        x: root.showDate ? 41 : 21;
        y: 1
        color: "white"
        text: showDate ? plainCurrentDateTime : plainCurrentTime
        anchors.verticalCenter: parent.verticalCenter
        animated: false
    }

    ConfluenceText {
        id: dateTimeText
        x: root.showDate ? 40 : 20
        text: showDate ? currentDateTime() : currentTime()
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
        animated: false
    }
}

