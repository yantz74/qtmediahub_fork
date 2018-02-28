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
import QtWebKit 1.1
import Dropbox 1.0

FocusScope {
    id: dropboxApp

    anchors.fill: parent
    anchors.leftMargin: 40
    focus: true

    Dropbox {
        id: dropbox
        onAuthUrlChanged: {
            webview.url = authUrl
        }
    }

    WebView {
        id: webview
        anchors.fill: parent
        preferredWidth: parent.width
        preferredHeight: parent.height
        smooth: false
        opacity: dropbox.status == Dropbox.Idle ? 1.0 : 0.0
        onUrlChanged: {
            //console.log("~New URL:"+url)
            if(url == "https://www.dropbox.com/1/oauth/authorize") {
                //console.log("~STARTING SYNC")
                dropbox.sync()
            }
        }
    }

    Rectangle {
        id: download
        anchors.fill: parent
        color: "white"
        opacity: dropbox.status != Dropbox.Idle ? 1.0 : 0.0

        Image {
            id: dropimg
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            source: "dropbox-medium.png"

            SequentialAnimation on rotation {
                running: dropbox.status == Dropbox.Synchronizing
                loops: Animation.Infinite
                RotationAnimation { duration: 500; to:  25; }
                RotationAnimation { duration: 500; to: -25; }
                onRunningChanged: dropimg.rotation = 0
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dropimg.bottom
            anchors.topMargin: 50
            font.pointSize: 32
            text: dropbox.status == Dropbox.Synchronizing ? "Downlaoding file " + dropbox.fileProgress : "Up-to-date!"
        }
    }
}

