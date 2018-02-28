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

import Qt 4.7
import "forecasts/elements"
import "../components/"

Item {
    id: root
    anchors.fill: parent

    signal present();

    property bool isDay : true;
    property bool isClear : true;
    property string cityName;
    property int currentTemperature;
    property string currentHumidity;
    property string currentWindCondition;
    property string folder: "images/"

    function translateX(x) {
        return root.width/10.0 + (x/700*root.width);
    }

    function translateY(y) {
        var tmp = y+root.height/5.0;
        return tmp > 0 ? -20 : tmp;
    }

    Row {
        anchors.bottom: line.top
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1

        ConfluenceText {
            id: temperatureText
            text: root.currentTemperature ? root.currentTemperature : " "
            font.pixelSize: 170
            font.bold: true
            color: "white"
        }

        Image {
            source: folder + "centigrades.png"
            anchors.bottom: temperatureText.bottom
            anchors.bottomMargin: 34
            opacity: temperatureText.text != " " ? 1 : 0
            Behavior on opacity { NumberAnimation {} }
        }
    }

    Image {
        id: line
        source: folder + "division_line.png"
        anchors.bottom: currentConditionColumn.top
        anchors.topMargin: 104
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: temperatureText.text != " " ? 1 : 0
        z: 1
        Behavior on opacity { NumberAnimation {} }
    }

    Column {
        id: currentConditionColumn
        anchors.bottom: cityLabel.top
        anchors.horizontalCenter: parent.horizontalCenter
        z: 1

        ConfluenceText {
            text: root.currentHumidity ? root.currentHumidity : " "
            font.pixelSize: 32
            font.bold: true
            color: "white"
        }

        ConfluenceText {
            text: root.currentWindCondition ? root.currentWindCondition : " "
            font.pixelSize: 32
            font.bold: true
            color: "white"
        }
    }

    ConfluenceText {
        id: cityLabel
        text: root.cityName ? root.cityName : " "
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.height/10.0
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: confluence.width/20
        z: 1
    }
}
