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
import QtMediaHub.components.media 1.0


Item {
    id: root

    property variant player
    property int position
    property int duration                       // TODO: duration is not working in QMHPlayer!!

    property int lablePixelSize: height * 0.035
    property int textPixelSize: height * 0.048

    function ms2string(ms)
    {
        var ret = "";

        if (ms <= 0)
            return "00:00";

        var h = Math.floor(ms/(1000*60*60))
        var m = Math.floor((ms%(1000*60*60))/(1000*60))
        var s = Math.floor(((ms%(1000*60*60))%(1000*60))/1000)

        if (h >= 1) {
            ret += h < 10 ? "0" + h : h + "";
            ret += ":";
        }

        ret += m < 10 ? "0" + m : m + "";
        ret += ":";
        ret += s < 10 ? "0" + s : s + "";

        return ret;
    }


    clip: true

    Image {
        id: coverArt
        source: player.thumbnail
        fillMode: Image.PreserveAspectFit
        height: root.height * 0.25
    }

    Text {
        id: artistLabel;
        anchors.top: coverArt.bottom
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: root.lablePixelSize;
        text: "Artist:"
    }
    Item {
        id: artist;
        anchors.top: artistLabel.bottom
        height: root.textPixelSize * 2.3;
        width: root.width
//        color: "transparent"
        clip: true
        Text {
            color: "white"
            font.pixelSize: root.textPixelSize;
            text: player.artist
            width: parent.width
            wrapMode: Text.Wrap
        }
    }

    Text { id: titleLabel;
        anchors.top: artist.bottom
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: root.lablePixelSize;
        text: "Title:"
    }
    Item {
        id: title;
        anchors.top: titleLabel.bottom
        height: root.textPixelSize * 3.5;
        width: root.width
        clip: true
        Text {
            color: "white"
            font.pixelSize: root.textPixelSize;
            text: player.title
            width: parent.width
            wrapMode: Text.Wrap
        }
    }

    Text { id: albumLabel;
        anchors.top: title.bottom
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: root.lablePixelSize;
        text: "Album:"
    }
    Item {
        id: album;
        anchors.top: albumLabel.bottom
        height: root.textPixelSize * 3.5;
        width: root.width
        clip: true
        Text {
            color: "white"
            font.pixelSize: root.textPixelSize;
            text: player.album
            width: parent.width
            wrapMode: Text.Wrap
        }
    }



    Text {
        id: playPosition
        anchors.bottom: root.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        font.pixelSize: root.height * 0.052;
        text: ms2string(root.position) + " / " + ms2string(root.duration)
    }

}
