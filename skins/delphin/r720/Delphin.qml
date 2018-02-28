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
import Qt.labs.particles 1.0
import DirModel 1.0
import MediaModel 1.0
import IpAddressFinder 1.0

Item {
    id : delphin

    height: 720
    width: 1280
    focus: true
    clip: true

    property real scalingCorrection: delphin.width == 1280 ? 1.0 : delphin.width/1280
    property string themeResourcePath: runtime.skin.path + "/media/"
    property real bigFontSize: delphin.width / 25
    property real smallFontSize: delphin.width / 50

    property variant rootMenuModel: ListModel { }

    function showOptionDialog(model) {
        optionsList.model = model
        optionsList.state = "visible"
        optionsList.focus = true
        delphin.blackout.show()
    }

    function hideOptionDialog() {
        optionsList.state = ""
        optionsList.focus = false
        currentElement.focus = true
        delphin.blackout.hide()
    }

    function showMainMenu() {
        show(menuView, "")
    }

    property variant currentElement
    property variant background : backgroundImage
    property variant blackout : blackoutItem

    // some global z-layer values
    property int layerBackground: 1
    property int layerAVPlayer: layerBackground+1
    property int layerViews: layerAVPlayer+1
    // layerViews - 1000 reserved for stuff like clock, global busy, context menus
    property int layerBlackout: 1000
    property int layerDialogs: layerBlackout+10

    property alias player: avPlayer

    function createQmlObjectFromFile(file, parent) {
        var qmlComponent = Qt.createComponent(file)
        if (qmlComponent.status == Component.Ready) {
            return qmlComponent.createObject(parent, {})
        }
        console.log(qmlComponent.errorString())
        return null
    }

    Component.onCompleted: {
        var musicWindow = createQmlObjectFromFile("MusicWindow.qml", delphin);
        delphin.rootMenuModel.append({name: qsTr("Music"), visualElement: musicWindow, icon: themeResourcePath + "Music.png", url: "MusicWindow.qml"})

        var videoWindow = createQmlObjectFromFile("VideoWindow.qml", delphin);
        delphin.rootMenuModel.append({name: qsTr("Video"), visualElement: videoWindow, icon: themeResourcePath + "Video.png", url: "VideoWindow.qml"})

        var pictureWindow = createQmlObjectFromFile("PictureWindow.qml", delphin);
        delphin.rootMenuModel.append({name: qsTr("Picture"), visualElement: pictureWindow, icon: themeResourcePath + "Picture.png", url: "PictureWindow.qml"})

        var radioWindow = createQmlObjectFromFile("RadioWindow.qml", delphin);
        delphin.rootMenuModel.append({name: qsTr("Radio"), visualElement: radioWindow, icon: themeResourcePath + "Radio.png", url: "RadioWindow.qml"})

//        var apps = runtime.apps.findApplications()
//        for (var idx in apps) {
//            var path = apps[idx]
//            var manifest = createQmlObjectFromFile(path + "qmhmanifest.qml", delphin)
//            var uiType = manifest.ui.substring(manifest.ui.lastIndexOf('.')+1)
//            if (uiType == "qml") {
//                delphin.rootMenuModel.append({ name: manifest.name, visualElement: undefined, icon: manifest.icon != undefined ? path + manifest.icon : themeResourcePath + "Application.png", url: path + manifest.ui })
//                runtime.view.addImportPath(path + "imports")
//            } else {
//                console.log('Application ' + manifest.name + ' at ' + path + ' with ui:' + manifest.ui + ' could not be loaded.')
//            }
//        }

        menuView.model = delphin.rootMenuModel

        show(menuView, "")
    }

    function show(element, url)
    {
        if (currentElement == element)
            return;

        if (currentElement && currentElement != avPlayer)
            currentElement.state = ""

        if (element === undefined) {
            currentElement = createQmlObjectFromFile("ApplicationWindow.qml", delphin)
            createQmlObjectFromFile(url, currentElement);
        } else {
            currentElement = element
        }

        if (currentElement == avPlayer) {
            currentElement.state = "maximized"
        } else if (currentElement == menuView) {
            menuView.state = "visible"
            avPlayer.state = "background"
            avPlayer.showAudioOSD = true
        } else {
            particleEffect.burst(500);
            currentElement.state = "visible"
            avPlayer.state = "background"
            if (currentElement.mediaType == "music" || currentElement.mediaType == "radio")
                avPlayer.showAudioOSD = true
            else
                avPlayer.showAudioOSD = false
        }
        currentElement.forceActiveFocus()
    }

    AVPlayer {
        id: avPlayer
        state: "background"
    }

    Background {
        id: backgroundImage
        anchors.fill: parent
        smooth: true
        z: layerBackground
    }

    Particles {
        id: particleEffect
        anchors.centerIn: parent
        width: 1
        height: 1
        source: themeResourcePath + "/particle.png"
        lifeSpan: 500
        count: 0
        angle: 0
        angleDeviation: 360
        velocity: 500
        velocityDeviation: 4000
        z: layerViews
    }

    DigitalClock {
        id: digitalClock
        anchors { right: parent.right; top: parent.top; }
        textColor : "white"
        showSeconds : true
        z: layerViews+1
        state: avPlayer && avPlayer.state == "maximized" && avPlayer.hasVideo ? "" : "visible"
    }

    Keys.onMenuPressed:
        if (menuView.state == "visible") {
            if (avPlayer.playing)
                show(avPlayer, "");
        } else
            show(menuView, "");
    Keys.onVolumeUpPressed: avPlayer.increaseVolume();
    Keys.onVolumeDownPressed: avPlayer.decreaseVolume();

    Keys.onPressed: {
        if (event.key == Qt.Key_MediaTogglePlayPause) {
            avPlayer.togglePlayPause()
        } else if (event.key == Qt.Key_MediaStop) {
            avPlayer.stop()
        } else if (event.key == Qt.Key_MediaPrevious) {
            avPlayer.playPrevious()
        } else if (event.key == Qt.Key_MediaNext) {
            avPlayer.playNext()
        }
    }

    MenuView {
        id: menuView
        opacity: 0.0
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height
        state:  "visible"
        z: layerViews

        onActivated: delphin.show(visualElement, url)
    }

    VolumeOSD {
        id: volumeOSD

        player: avPlayer
        anchors.left: parent.left
        anchors.top: parent.top
        z: layerAVPlayer+1
    }

    Rectangle {
        id: blackoutItem
        anchors.fill: parent
        color: "black"
        opacity: 0
        z: layerBlackout

        function show() {
            opacity = 0.6
        }

        function hide() {
            opacity = 0
        }

        Behavior on opacity { NumberAnimation {} }

        MouseArea {
            id: mouseConsumer
            anchors.fill: parent
            hoverEnabled: true
            onClicked: mouse.accepted = true
        }
    }

    Connections {
        target: runtime.deviceManager
        onDeviceAdded: {
            console.log("new device detected");
            console.log("mount device "+device)
            runtime.deviceManager.getDeviceByPath(device).mount();
        }
        onDeviceRemoved: {
            console.log("device removed "+device)
        }
    }

    ScannerProgress {
        id: scannerProgress
        z: layerAVPlayer+1
    }

    ActionIconView {
        id: optionsList
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height/2.0 - height

        Keys.onUpPressed: hideOptionDialog()
        Keys.onDownPressed: hideOptionDialog()
        Keys.onBackPressed: hideOptionDialog()
        Keys.onMenuPressed: hideOptionDialog()
    }

    Text {
        z: 100000
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: ipAddressFinder.ipAddresses[0]
        color: "gray"

        IpAddressFinder {
            id: ipAddressFinder
        }
    }
}
