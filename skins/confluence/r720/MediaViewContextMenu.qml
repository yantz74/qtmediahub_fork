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

ContextMenu {
    id: root

    property variant view;

    title: qsTr("Actions")
    ConfluenceAction { id: playAction; text: qsTr("Play");
        onTriggered: mediaWindow.play()
    }
    ConfluenceAction { id: rootAction; text: qsTr("Go to root"); onTriggered: view.rootIndex = undefined; }
    ConfluenceAction { id: removeAction; text: qsTr("Remove"); onTriggered: mediaModel.removeSearchPath(view.currentIndex)
                       enabled: !!view.currentItem && view.currentItem.itemdata.type == "SearchPath" }
    ConfluenceAction { id: informationAction; text: qsTr("Show Information"); onTriggered: root.showInformationSheet()
                       enabled: !!view.currentItem && view.currentItem.itemdata.type == "File" }
    ConfluenceAction { id: rescanAction; text: qsTr("Rescan this item"); onTriggered: mediaModel.rescan(view.currentIndex)
                       enabled: !!view.currentItem && view.currentItem.itemdata.type == "SearchPath" }
    ConfluenceAction { id: addSourceAction; text: qsTr("Add Source Path"); onTriggered: confluence.showModal(addMediaSourceDialog) }

    model: [playAction, rootAction, removeAction, informationAction, rescanAction, addSourceAction]
}
