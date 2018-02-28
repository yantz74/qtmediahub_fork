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
import "util.js" as Util
import "components/"

// We explicitly want to build the model in the QML since we want to the view
// to entirely control the display of information. 
// Future work:
// 1. A live map showing geolocation

Sheet {
    property variant currentItem
    width: 600
    title: qsTr("Music Information")

    resources : ListModel {
        id: listModel
    }

    onCurrentItemChanged : {
        listModel.clear()
        var item = currentItem.itemdata
        // First add items that are guaranteed to be present
        listModel.append({key: qsTr("Title"), value: item.title})
        listModel.append({key: qsTr("File path"), value: item.filepath})
        listModel.append({key: qsTr("File size"), value: Util.toHumanReadableBytes(item.filesize)})
        // Tag information may or may not be present
        var translations = { // FIXME: make global
            artist: qsTr("Artist"),
            album: qsTr("Album"),
            comment: qsTr("Comment"),
            genre: qsTr("Genre"),
            year: qsTr("Year"),
            track: qsTr("Track"),
            length: qsTr("Length"),
            bitrate: qsTr("Bitrate"),
            samplerate: qsTr("Sample Rate")
        }
        for (var role in translations) {
            if (role in item)
                listModel.append({key: translations[role], value: item[role]})
        }
    }

    ConfluenceListView {
        id: listView
        anchors.fill: parent
        model : listModel
        focus: true

        delegate: ConfluenceTwoColumnDelegate {
            column1Text: model.key
            column2Text: model.value
        }
    }
}

