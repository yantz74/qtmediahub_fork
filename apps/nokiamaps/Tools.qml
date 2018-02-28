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
import QtMobility.location 1.2

FocusScope {
    id: root

    function reset()
    {
        mapButton.triggered = false;
        satelliteButton.triggered = false;
    }

    focus: true
    width: childrenRect.width; height: childrenRect.height

    Component {
        id: manualHighlight

        Rectangle {
            color: "blue"
            opacity: parent.parent.activeFocus ? 0.2 : 0.0
            anchors.fill: parent
        }
    }

    Row {
        width: childrenRect.width; height: childrenRect.height
        Item {
            id: textField
            focus: true
            width: childrenRect.width; height: childrenRect.height

            KeyNavigation.right: mapButton

            Image {
                source: "images/textbox.png"
                TextInput {
                    anchors.fill: parent
                }
            }

            Loader { sourceComponent: manualHighlight; anchors.fill: parent }
        }

        Item {
            id: mapButton

            property bool triggered: false

            function trigger() {
                root.reset()
                triggered = true
                map.mapType = Map.StreetMap
            }

            MouseArea {
                anchors.fill: parent
                onClicked: mapButton.trigger()
            }

            width: childrenRect.width; height: childrenRect.height

            KeyNavigation.left: textField
            KeyNavigation.right: satelliteButton

            Image {
                source: "images/map.png"
            }
            Image {
                opacity: mapButton.triggered ? 1.0 : 0.0
                source: "images/map-active.png"
                Behavior on opacity {
                    PropertyAnimation {}
                }
            }
            Text {
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                text: "Map"
            }
            Loader { sourceComponent: manualHighlight; anchors.fill: parent }

            Keys.onEnterPressed:
                trigger()
            Keys.onReturnPressed:
                trigger()
        }

        Item {
            id: satelliteButton

            property bool triggered: false

            function trigger() {
                root.reset()
                triggered = true
                map.mapType = Map.SatelliteMapDay
            }

            MouseArea {
                anchors.fill: parent
                onClicked: satelliteButton.trigger()
            }

            width: childrenRect.width; height: childrenRect.height

            KeyNavigation.left: mapButton

            Image {
                source: "images/satellite.png"
            }
            Image {
                opacity: satelliteButton.triggered ? 1.0 : 0.0
                source: "images/satellite-active.png"
                Behavior on opacity {
                    PropertyAnimation {}
                }
            }
            Text {
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                text: "Satelitte"
            }

            Loader { sourceComponent: manualHighlight; anchors.fill: parent }

            Keys.onEnterPressed:
                satelliteButton.trigger()
            Keys.onReturnPressed:
                satelliteButton.trigger()
        }
    }
}
