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
import MediaModel 1.0

Window {
    id: mediaWindow

    focalWidget: viewLoader

    signal itemActivated(variant mediaItem)
    signal itemSelected(variant mediaItem)
    property alias view : viewLoader.item
    property string viewType : "POSTER"
    property string groupBy : "None"
    property variant mediaWindowRipple
    property Item informationSheet

    property variant groupByOptions : [qsTr("None")]
    property variant structures : [""]

    property alias mediaModel: mediaModel
    
    MediaModel {
        id: mediaModel
    }

    function play() {
        avPlayer.playForeground(mediaModel, view.currentIndex)
    }

    function setCurrentView(viewType) {
        var currentIndex = typeof view != "undefined" ? view.currentIndex : 0
        var dotDotPosition = MediaModel.End
        if (viewType == qsTr("BIG GRID") || viewType == qsTr("GRID")) {
            viewLoader.changeView(thumbnailView)
            view.hidePreview = viewType == qsTr("BIG GRID")
            dotDotPosition = MediaModel.Beginning
        } else if (viewType == qsTr("LIST") || viewType == qsTr("BIG LIST")) {
            viewLoader.changeView(listView)
            view.hidePreview = viewType == qsTr("BIG LIST")
            dotDotPosition = MediaModel.Beginning
        } else if (viewType == qsTr("POSTER")) {
            viewLoader.changeView(posterView)
            view.setPathStyle("linearZoom")
        } else if (viewType == qsTr("SIDLING")) {
            viewLoader.changeView(posterView)
            view.setPathStyle("sidlingZoom")
        } else if (viewType == qsTr("AMPHI")) {
            viewLoader.changeView(posterView)
            view.setPathStyle("amphitheatreZoom")
        } else if (viewType == qsTr("CAROUSEL")) {
            viewLoader.changeView(posterView)
            view.setPathStyle("carousel")
        } else if (viewType == qsTr("FLOW")) {
            viewLoader.changeView(posterView)
            view.setPathStyle("coverFlood")
        } else {
            //Default in case we remove their stored preference
            viewLoader.changeView(posterView)
            view.setPathStyle("POSTER")
        }

        mediaModel.dotDotPosition = dotDotPosition

        blade.viewAction.currentOptionIndex = blade.viewAction.options.indexOf(viewType)
        mediaWindow.viewType = viewType
        view.currentIndex = currentIndex
    }

    function setGroupBy(attribute) {
        var index = blade.groupByAction.options.indexOf(attribute)
        if (index == -1)
            index = 0
        blade.groupByAction.currentOptionIndex = index
        mediaModel.structure = structures[index]
    }

    onItemSelected: {
        confluence.shroomfluence ? mediaWindowRipple.stop() : undefined
    }
    onItemActivated: {
        confluence.shroomfluence ? mediaWindowRipple.ripple(mediaItem) : undefined
        root.play()
    }

    function visibleTransitionFinished() {
        if (mediaModel.rowCount() < 1) 
            confluence.showModal(addMediaSourceDialog)
    }

    function showInformationSheet() {
        informationSheet.currentItem = viewLoader.item.currentItem
        confluence.showModal(informationSheet)
    }

    Connections {
        target: addMediaSourceDialog
        onRejected: if (mediaModel.rowCount() < 1) confluence.show(mainBlade)
    }

    MediaScanInfo {
        id: mediaScanInfo
    }

    bladeComponent: MediaWindowBlade {
        property alias viewAction: viewAction
        property alias groupByAction: groupByAction

        parent: root
        visible: true
        defaultBladeActionIndex: 1

        actionList: [
            ConfluenceAction {
                id: rootAction
                text: qsTr("Go to root")
                //Number.MAX_VALUE
                //JS maxInt?
                onTriggered: mediaModel.back(100)
            },
            ConfluenceAction {
                id: viewAction
                text: qsTr("VIEW")
                options: [qsTr("LIST"), qsTr("BIG LIST"), qsTr("GRID"), qsTr("BIG GRID"), qsTr("POSTER"), qsTr("SIDLING"), qsTr("AMPHI"), qsTr("CAROUSEL"), qsTr("FLOW")]
                onTriggered: mediaWindow.setCurrentView(currentOption)
                enabled: options.length > 1
            },
            ConfluenceAction {
                id: sortByAction
                text: qsTr("SORT BY")
                options: [qsTr("NAME"), qsTr("SIZE"), qsTr("DATE")]
                onTriggered: mediaModel.sort(view.rootIndex, currentOption)
                enabled: options.length > 1
            },
            ConfluenceAction {
                id: groupByAction
                text: qsTr("GROUP BY")
                options: mediaWindow.groupByOptions
                onTriggered: mediaWindow.setGroupBy(currentOption)
                enabled: options.length > 1
            },
            ConfluenceAction {
                id: addNewSourceAction
                text: qsTr("Add New Source")
                onTriggered: confluence.showModal(addMediaSourceDialog)
            },
            ConfluenceAction {
                id: removeAction
                text: qsTr("Remove Source")
                onTriggered: confluence.showModal(removeMediaSourceDialog)
            },
            ConfluenceAction {
                id: addToPlaylistAction
                text: qsTr("Add to Playlist");
                onTriggered: { avPlayer.mediaPlaylist.add(mediaWindow.mediaModel, view.currentIndex); avPlayer.playIndex(0) }
            },
            ConfluenceAction {
                id: playAction;
                text: qsTr("Play");
                onTriggered: mediaWindow.play()
            },
            ConfluenceAction {
                id: informationAction
                text: qsTr("Show Info")
                onTriggered: showInformationSheet()
                enabled: informationSheet && view.currentItem && view.currentItem.itemdata.isLeaf ? true : false
            }
        ]
    }

    Component {
        id: thumbnailView
        MediaThumbnailView {
            mediaModel: mediaWindow.mediaModel
        }
    }

    Component {
        id: listView
        MediaListView {
            mediaModel: mediaWindow.mediaModel
        }
    }

    Component {
        id: posterView
        MediaPosterView {
            mediaModel: mediaWindow.mediaModel
        }
    }

    ViewLoader {
        id: viewLoader
        focus: true
        anchors.fill: parent
    }

    AddMediaSourceDialog {
        id: addMediaSourceDialog
        focalWidget: viewLoader
        mediaModel: mediaWindow.mediaModel
        title: qsTr("Add %1 source").arg(mediaModel.mediaType)
    }

    RemoveMediaSourceDialog {
        id: removeMediaSourceDialog
        focalWidget: viewLoader
        mediaType: mediaModel.mediaType
        title: qsTr("Remove %1 source").arg(mediaModel.mediaType)
    }

    Component.onCompleted: {
        setCurrentView(mediaWindow.viewType)
        setGroupBy(mediaWindow.groupBy)
        if (confluence.shroomfluence)
            mediaWindowRipple = confluence.createQmlObjectFromFile("MediaWindowRipple.qml", {}, root)
    }
}
