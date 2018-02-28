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
import "./components/uiconstants.js" as UIConstants

Item {
    id: root
    z: UIConstants.screenZValues.background

    property string latentBackgroundPath
    property string backgroundPath: themeResourcePath + "/backgrounds/720p/"

    ListModel {
        id: imagesModel
    }

    Connections {
        target: audioVisualisationPlaceholder
        onVisibleChanged:
            if (audioVisualisationPlaceholder.visible)
            {
                setBackground(latentBackgroundPath)
                latentBackgroundPath = ""
            }
    }

    function setBackground(source) {
        if (source == "")
            return

        if (audioVisualisationPlaceholder.visible) {
            latentBackgroundPath = source
            return
        }

        var index = -1;

        for (var i = 0; i < imagesModel.count; ++i) {
            if (imagesModel.get(i).imageSource == source) {
                index = i;
            }
            imagesModel.get(i).opacity = 0
        }

        if (index !== -1) {
            imagesModel.get(index).opacity = 1
        } else {
            imagesModel.append({imageSource: source, opacity: 0})
            // explicitly set opacity again, to trigget fade animation
            imagesModel.get(imagesModel.count-1).opacity = 1
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: !runtime.settings.overlayMode
        color: "black"
    }

    Repeater {
        model: imagesModel
        anchors.fill: parent
        delegate: Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            opacity: model.opacity
            source: {
                if (imageSource) {
                    // check if source is an absolute path
                    return imageSource[0] == '/' ? imageSource : root.backgroundPath + imageSource
                } else {
                    return root.backgroundPath + "media-overlay.png"
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 500 }
            }
        }
    }
}
