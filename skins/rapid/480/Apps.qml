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
import AnimatedTiles 1.0
import QMHPlugin 1.0

import "cursor.js" as Script

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginMore
    clip: true

    // width // x
    property int columns: 3
    property int spacingW: 30
    property int itemWidthWithSpace: root.width/root.columns

    // height // y
    property int rows: 2
    property int spacingH: 30
    property int itemHeightWithSpace: root.height/root.rows

    property int focusRow: 0
    property int focusColumn: 0

    function addItem(item, row, column) {
        Script.addItem(item, row, column)
    }
    function setFocusCoord(row, column) {
        root.focusRow = row
        root.focusColumn = column
    }

    AppsDelegate { id: a1;      column: 0; row: 0;
        childWidth: root.width; childHeight: root.height
        sourceComponent: AnimatedTiles{}
    }

    AppsDelegate { id: a2;      column: 1; row: 0;
        childWidth: root.width; childHeight: root.height
        source: runtime.skin.resourcePath + "/widgets/samegame/samegame.qml"
    }

    AppsDelegate { id: a3;      column: 2; row: 0;
        source: runtime.skin.resourcePath + "/widgets/qmlremotecontrol/qmlremotecontrol.qml"

    }

    AppsDelegate { id: b1;      column: 0; row: 1;
//        source: skin.resourcePath + "/widgets/qtflyingbus/main_800_480.qml"
    }


    AppsDelegate { id: b2;      column: 1; row: 1;
        source: runtime.skin.resourcePath + "/widgets/Reversi/DesktopGame.qml"
    }

    AppsDelegate { id: b3;      column: 2; row: 1;
        source: runtime.skin.resourcePath + "/widgets/flickr/flickr.qml"
    }

    Keys.onPressed: {
        if (Script.getItem(root.focusRow, root.focusColumn).isFullScreen == true) {
            if(event.key == Qt.Key_Enter) {
                Script.getItem(root.focusRow, root.focusColumn).isFullScreen = false
                event.accepted = true
            }
        }
        else {
            if (event.key == Qt.Key_Right) {
                focusColumn = (++focusColumn) % root.columns
                event.accepted = true
            }
            if (event.key == Qt.Key_Down) {
                focusRow    = (++focusRow)    % root.rows
                event.accepted = true
            }
            if (event.key == Qt.Key_Left) {
                --focusColumn;
                if(focusColumn<0) focusColumn = root.columns-1
                event.accepted = true
            }
            if (event.key == Qt.Key_Up) {
                --focusRow;
                if(focusRow<0) focusRow = root.rows-1
                event.accepted = true
            }

            if (event.key == Qt.Key_Enter) {
                Script.getItem(root.focusRow, root.focusColumn).isFullScreen = true
                event.accepted = true
            }
        }
    }
}

