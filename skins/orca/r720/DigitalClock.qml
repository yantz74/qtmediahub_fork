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

Item {
    id: root

    property color textColor : "steelblue"
    property int fontSize : 42
    property int fontSizeDate: 25
    property string hours : "00"
    property string minutes : "00"
    property string seconds : "00"
    property string date: ""
    property variant shift : 0
    property bool showSeconds : true
    property bool showDate : true

    width: columnLayout.width
    height: columnLayout.height
    opacity: 0
    z: delphin.layerViews

    function timeChanged() {
        // To be fixed to fit locale
        var Month = new Array(qsTr("January"), qsTr("February"), qsTr("March"), qsTr("April"), qsTr("May"),
                            qsTr("June"), qsTr("July"), qsTr("August"), qsTr("September"), qsTr("October"),
                            qsTr("November"), qsTr("December"));
        var d = new Date;

        // hours
        var tmp = checkTime(shift ? d.getUTCHours() + Math.floor(root.shift) : d.getHours())
        if (tmp != hours)
            hours = tmp

        // minutes
        tmp = checkTime(shift ? d.getUTCMinutes() + ((root.shift % 1) * 60) : d.getMinutes())
        if (tmp != minutes)
            minutes = tmp

        // seconds
        seconds = checkTime(d.getUTCSeconds())

        // get Date
        date = d.getDate() + ". " + Month[d.getMonth()] + " " + d.getFullYear();
    }

    function checkTime(i) {
        return (i<10) ? "0"+i : i;
    }

    states:
        State {
            name: "visible"
            PropertyChanges {
                target: root
                opacity: 1
            }
        }

    transitions:
        Transition {
            NumberAnimation { property: "opacity"; duration: 350; easing.type: Easing.InQuad }
        }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: root.timeChanged()
    }

    Column {
        id: columnLayout

        Row {
            id : rowLayout
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: hoursText
                text: root.hours
                color: root.textColor
                font.pixelSize: root.fontSize

                Behavior on text {
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation { target: hoursText; property: "opacity"; to: 0.1; duration: 200 }
                            NumberAnimation { target: hoursText; property: "y"; to: root.height; duration: 300 }
                        }
                        PropertyAction {  }
                        NumberAnimation { target: hoursText; property: "y"; to: -root.height; duration: 0 }
                        ParallelAnimation {
                            NumberAnimation { target: hoursText; property: "opacity"; to: 1; duration: 200 }
                            NumberAnimation { target: hoursText; property: "y"; to: 0; easing.type: Easing.OutBounce; duration: 400 }
                        }
                    }
                }
            }

            Text {
                text: ":"
                color: root.textColor
                font.pixelSize: root.fontSize
            }

            Text {
                id : minutesText
                text: root.minutes
                color: root.textColor
                font.pixelSize: root.fontSize

                Behavior on text {
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation { target: minutesText; property: "opacity"; to: 0.1; duration: 200 }
                            NumberAnimation { target: minutesText; property: "y"; to: root.height; duration: 300 }
                        }
                        PropertyAction {  }
                        NumberAnimation { target: minutesText; property: "y"; to: -root.height; duration: 0 }
                        ParallelAnimation {
                            NumberAnimation { target: minutesText; property: "opacity"; to: 1; duration: 200 }
                            NumberAnimation { target: minutesText; property: "y"; to: 0; easing.type: Easing.OutBounce; duration: 400 }
                        }
                    }
                }
            }

            Text {
                text: ":"
                color: root.textColor
                font.pixelSize: root.fontSize
                visible : root.showSeconds
            }

            Text {
                id : secondsText
                text: root.seconds
                color: root.textColor
                font.pixelSize: root.fontSize
                visible : root.showSeconds

                Behavior on text {
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation { target: secondsText; property: "opacity"; to: 0.1; duration: 200 }
                            NumberAnimation { target: secondsText; property: "y"; to: root.height; duration: 300 }
                        }
                        PropertyAction {  }
                        NumberAnimation { target: secondsText; property: "y"; to: -root.height; duration: 0 }
                        ParallelAnimation {
                            NumberAnimation { target: secondsText; property: "opacity"; to: 1; duration: 200 }
                            NumberAnimation { target: secondsText; property: "y"; to: 0; easing.type: Easing.OutBounce; duration: 400 }
                        }
                    }
                }
            }
        }

        Text {
            id : dateText
            text: root.date
            color: root.textColor
            font.pixelSize: root.fontSizeDate
            visible : root.showDate
        }
    }
}
