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
import "components/"
import "./components/uiconstants.js" as UIConstants
import "./components/cursor.js" as Cursor
import "util.js" as Util
import "confluence.js" as Confluence
import MediaModel 1.0
import IpAddressFinder 1.0
import QtMediaHub.components 2.0
import Metrics 1.0

FocusScope {
    id: confluence

    property bool scalingAllowed: runtime.skin.settings.pixmapScaling
    property real scalingCorrection: confluence.width == 1280 ? 1.0 : confluence.width/1280

    property string themePath: util.pathFromUrl(runtime.view.source)
    property string themeResourcePath: "file://" + runtime.skin.path + "/3rdparty/skin.confluence/"

    property int standardEasingCurve: Easing.InQuad
    property int standardAnimationDuration: 350

    property int standardHighlightRangeMode: ListView.NoHighlightRange
    property int standardHighlightMoveDuration: 400

    property bool standardItemViewWraps: true

    property variant rootMenuModel: ListModel { }

    // private
    property variant _ticker
    property variant _weatherWindow
    property int _openWindowIndex : 0
    property variant _openWindow

    anchors.fill: parent
    focus: true
    clip: true

    function resetFocus() {
        state = ""
        mainBlade.rootMenu.forceActiveFocus()
    }

    function openLink(link) {
            console.log('No browser present to open ' + link)
    }

    function showAboutWindow() {
        var aboutWindow = util.createQmlObjectFromFile(themePath + "AboutWindow.qml", { deleteOnClose: true }, confluence)
        show(aboutWindow)
    }

    function setBackground(source) {
        background.setBackground(source)
    }

    function setActiveEngine(index) {
        var engine = rootMenuModel.get(index)

        if (!engine.window) {
            if (engine.sourceUrl) {
                engine.window = util.createQmlObjectFromFile(engine.sourceUrl, engine.constructorArgs || {}, confluence) || { }
            } else if (engine.appUrl) {
                engine.window = util.createQmlObjectFromFile(themePath + "components/Window.qml", engine.constructorArgs || {}, confluence)
                var panel = util.createQmlObjectFromFile(themePath + "components/Panel.qml", {decorateFrame: true, decorateTitleBar: true}, engine.window, confluence)
                panel.anchors.centerIn = engine.window
                var app = util.createQmlObjectFromFile(engine.appUrl, {}, confluence)
                var item = Qt.createQmlObject("import QtQuick 2.0; Item { }", panel.contentItem)
                item.width = (function() { return engine.window ? engine.window.width - 60 : undefined })
                item.height = (function() { return engine.window ? engine.window.height - 60 : undefined })
                app.parent = item
                app.forceActiveFocus()
            }
        }

        _openWindow = engine.window

        if (index != _openWindowIndex) {
            if (Confluence.activationHandlers[index])
                Confluence.activationHandlers[index].call(engine.window)
        }

        _openWindowIndex = index
        show(_openWindow)
    }

    function show(element) {
        if (_openWindow && _openWindow != element) {
            _openWindow.close()
            if (_openWindow.deleteOnClose) {
                rootMenuModel.get(_openWindowIndex).window = null
                _openWindow = null
                _openWindowIndex = 0
            }
        }
        if (element == mainBlade) {
            state = ""
        } else if(element == avPlayer) {
            if(!avPlayer.hasMedia) {
                if (typeof runtime.videoEngine != "undefined")
                    show(runtime.videoEngine.window)
                else if (typeof runtime.musicEngine != "undefined")
                    show(runtime.musicEngine.window)
            } else {
                show(transparentVideoOverlay)
            }
        } else if (element == transparentVideoOverlay) {
            _openWindow = transparentVideoOverlay
            state = "showingSelectedElementMaximized"
        } else {
            _openWindow = element
            state = "showingSelectedElement"
        }
    }

    function showContextMenu(item, x, y) {
        showModal(item)
        item.x = x
        item.y = y
    }

    function showModal(item) {
        mouseGrabber.opacity = 0.9 // FIXME: this should probably become a confluence state
        var currentFocusedItem = runtime.view.focusItem();
        var onClosedHandler = function() {
            mouseGrabber.opacity = 0;
            if (currentFocusedItem)
                currentFocusedItem.forceActiveFocus()
            item.closed.disconnect(onClosedHandler)
        }
        item.closed.connect(onClosedHandler)
        item.parent = confluence // ## restore parent?
        item.z = UIConstants.screenZValues.diplomaticImmunity
        item.open()
        item.forceActiveFocus()
    }

    function showFullScreen(item) {
        item.z = background.z + 2
        item.parent = confluence
        item.opacity = 1
        item.forceActiveFocus()
    }

    states: [
        State {
            name:  ""
            StateChangeScript { name: "focusMainBlade"; script: mainBlade.forceActiveFocus() }
            PropertyChanges { target: _ticker; state: "visible" }
        },
        State {
            name: "showingSelectedElement"
            PropertyChanges { target: mainBlade; state: "hidden" }
            PropertyChanges { target: avPlayer; state: "hidden" }
            PropertyChanges { target: dateTimeHeader; expanded: true; showDate: false }
            PropertyChanges { target: weatherHeader; expanded: false }
            PropertyChanges { target: homeHeader; expanded: true }
            PropertyChanges { target: currentContextHeader; expanded: true }
            PropertyChanges { target: _ticker; state: "" }
            StateChangeScript { name: "showSelectedElement"; script: _openWindow.show() }
            PropertyChanges { target: avPlayer; state: "background" }
        },
        State {
            name: "showingSelectedElementMaximized"
            extend: "showingSelectedElement"
            StateChangeScript { name: "maximizeSelectedElement"; script: _openWindow.showMaximized() }
            PropertyChanges { target: avPlayer; state: _openWindow == transparentVideoOverlay ? "maximized" : "hidden" }
            PropertyChanges { target: dateTimeHeader; expanded: false; showDate: false }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: ""
        },
        Transition {
            from: "*"
            to: "showingSelectedElement"
            SequentialAnimation {
                // Move things out
                ParallelAnimation {
                }
                // Move things in
                ParallelAnimation {
                    ScriptAction { scriptName: "showSelectedElement" }
                }
            }
        }
    ]

    Keys.onPressed: {
        event.accepted = true
        if (event.key == Qt.Key_MediaTogglePlayPause) {
            avPlayer.togglePlayPause()
        } else if (event.key == Qt.Key_MediaStop) {
            avPlayer.stop()
        } else if (event.key == Qt.Key_MediaPrevious) {
            avPlayer.playPrevious()
        } else if (event.key == Qt.Key_MediaNext) {
            avPlayer.playNext()
        } else if (event.key == Qt.Key_Context1) {
            if (_openWindow && _openWindow.maximizable && state == "showingSelectedElement")
                _openWindow.maximized = true
        } else {
            event.accepted = false
        }
    }

    Keys.onMenuPressed: _openWindow && _openWindow.maximized ? _openWindow.maximized = false : show(mainBlade)
    Keys.onVolumeDownPressed: avPlayer.decreaseVolume()
    Keys.onVolumeUpPressed: avPlayer.increaseVolume()

    function _addRootMenuItems(rootMenuItems) {
        var mediaPlugins = runtime.mediaScanner.availableParserPlugins()
        for (var i = 0; i < rootMenuItems.length; i++) {
            var item = rootMenuItems[i]
            if (item.mediaPlugin && mediaPlugins.indexOf(item.mediaPlugin) == -1)
                continue
            rootMenuModel.append(item)
            if (item.onActivate)
                Confluence.activationHandlers[rootMenuModel.count-1] = item.onActivate
        }
    }

    Component.onCompleted: {
        Cursor.initialize()

        _weatherWindow = util.createQmlObjectFromFile(themePath + "WeatherWindow.qml", {}, confluence)

        var rootMenuItems = [
            { name: qsTr("Music"), mediaPlugin: "music", sourceUrl: themePath + "MusicWindow.qml", background: "music.jpg",  constructorArgs: { deleteOnClose: false } },
            { name: qsTr("Picture"), mediaPlugin: "picture", sourceUrl: themePath + "PictureWindow.qml", background: "pictures.jpg", constructorArgs: { deleteOnClose: false } },
            { name: qsTr("Video"), mediaPlugin: "video", sourceUrl: themePath + "VideoWindow.qml", background: "videos.jpg", constructorArgs: { deleteOnClose: false } },
            { name: qsTr("Weather"), sourceUrl: themePath + "WeatherWindow.qml", window: _weatherWindow, background: "weather.jpg" }
        ]

        var apps = runtime.apps.findApplications()
        for (var idx in apps) {
            var path = apps[idx]
            var manifest = util.createQmlObjectFromFile(path + "qmhmanifest.qml", {}, confluence)
            if (manifest == null)
                continue;
            var uiType = manifest.ui.substring(manifest.ui.lastIndexOf('.')+1)
            if (uiType == "qml") {
                rootMenuItems.push({ name: manifest.name, appUrl: path + manifest.ui, background: path + manifest.background,
                                   constructorArgs: { deleteOnClose: true }})
                runtime.view.addImportPath(path + "imports")
            } else {
                console.log('Application ' + manifest.name + ' at ' + path + ' with ui:' + manifest.ui + ' could not be loaded.')
            }
        }

        _addRootMenuItems(rootMenuItems)

//        _ticker = util.createQmlObjectFromFile(themePath + "Ticker.qml", { z: UIConstants.screenZValues.header, state: "visible" }, confluence)
        if (_ticker) {
            _ticker.linkClicked.connect(confluence.openLink)
        } else {
            _ticker = dummyItem
        }
    }

    AVPlayer {
        id: avPlayer
        state: "background"
    }

    QMHUtil {
        id: util
    }

    // dummyItem useful to avoid error ouput on component loader failures
    Item {
        id: dummyItem
        visible: false
    }

    Background {
        id: background
        anchors.fill: parent;
        visible: !avPlayer.playing
    }

    PoorManAudioVisualization {
        id: audioVisualisationPlaceholder
        z: -3
        visible: avPlayer.playing && !avPlayer.hasVideo
    }

    MainBlade {
        id: mainBlade;
        state: "open"
        focus: true
    }

    Header {
        id: homeHeader
        atRight : false
        expanded: false

        z: currentContextHeader.z + 1
        width: homeImage.width + 80
        Image {
            id: homeImage
            x: 40
            sourceSize { width: height; height: homeHeader.height-4; }
            source: themeResourcePath + "/media/HomeIcon.png"
        }
        MouseArea { anchors.fill: parent; onClicked: confluence.show(mainBlade) }
    }

    Header {
        id: currentContextHeader
        atRight: false
        expanded: false

        width: contextText.width + homeHeader.width + 25
        ConfluenceText {
            id: contextText
            anchors { right: parent.right; rightMargin: 25; verticalCenter: parent.verticalCenter }
            text: _openWindowIndex < rootMenuModel.count ? rootMenuModel.get(_openWindowIndex).name : ""
            color: "white"
        }
    }

    WeatherHeader {
        id: weatherHeader

        width: content.width + dateTimeHeader.width + 50
        city: runtime.skin.settings.weatherCity

        MouseArea {
            anchors.fill: parent
            onClicked: confluence.show(_weatherWindow)
        }
    }

    DateTimeHeader {
        id: dateTimeHeader
        expanded: true
        showDate: true
    }

    Rectangle {
        id: mouseGrabber
        color: "black"
        anchors.fill: parent;
        z: UIConstants.screenZValues.mouseGrabber
        opacity: 0

        Behavior on opacity {
            NumberAnimation { }
        }

        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true
        }
    }

    Window {
        id: transparentVideoOverlay
        onFocusChanged:
            activeFocus ? avPlayer.forceActiveFocus() : undefined
    }

    DeviceDialog {
        id: deviceDialog
    }

    Connections {
        target: runtime.deviceManager
        onDeviceAdded: {
            var d = runtime.deviceManager.getDeviceByPath(device)
            if (d.isPartition) {
                deviceDialog.device = d
                d.mount();
                confluence.showModal(deviceDialog)
            }
        }
        onDeviceRemoved: {
            deviceDialog.close()
            var d = runtime.deviceManager.getDeviceByPath(device)
            runtime.mediaScanner.removeSearchPath("music", device.uuid)
            runtime.mediaScanner.removeSearchPath("video", device.uuid)
            runtime.mediaScanner.removeSearchPath("picture", device.uuid)
            runtime.mediaScanner.removeSearchPath("radio", device.uuid)
        }
    }

    VolumeOSD {
        id: volumeOSD

        player: avPlayer
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 20
        z: UIConstants.screenZValues.diplomaticImmunity
    }

    Metrics {
        id: metrics
    }

    FPSItem {
        id: fpsItem
    }

    ThreadCountItem {
    }

    Text {
        z: 100000
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: ipAddressFinder.ipAddresses[0]

        IpAddressFinder {
            id: ipAddressFinder
        }
    }
}

