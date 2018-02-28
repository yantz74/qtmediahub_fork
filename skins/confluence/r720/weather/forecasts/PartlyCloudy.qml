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
import "elements"
import "../"

ForecastView {
    id: root

    SmallCloud {
        id: cloud3
        x: translateX(396)
        y: translateY(-800)
        finalY: translateY(-446);
        type: isDay ? "cloud" : "cloud_rain"
    }

    HungItem {
        id: sun
        x: isDay ? translateX(120) : translateX(220)
        y: translateY(-800)
        itemX: 0
        itemY:  isDay ? 200 : 180
        height:  isDay ? 500 : 440
        finalY: isDay ? translateY(-198) : translateY(-205)
        itemImage: isDay ? folder + "sun.png" : folder + "moon.png"
        lineImage: isDay ? folder + "sun_line.png" : folder + "moon_line.png"
    }

    MediumCloud {
        id: cloud2
        x: translateX(0)
        y: translateY(-800)
        finalY: translateY(-307)
        type: isDay ? "cloud" : "cloud_rain"
    }

    LargeCloud {
        id: cloud1
        x: translateX(267)
        y: translateY(-800)
        finalY: translateY(-291)
        type: isDay ? "cloud" : "cloud_rain"
    }

    states : State {
        name: "final"
        PropertyChanges { target: sun; y: sun.finalY; }
        PropertyChanges { target: cloud1; y: cloud1.finalY; }
        PropertyChanges { target: cloud2; y: cloud2.finalY; }
        PropertyChanges { target: cloud3; y: cloud3.finalY; }
    }

    transitions: Transition {
        SequentialAnimation {
            ParallelAnimation {
               NumberAnimation { target: cloud1; properties: "y";
                                 easing.type: "OutBack"; duration: 500 }

               SequentialAnimation {
                   PauseAnimation { duration: 200 }
                   NumberAnimation { target: cloud2; properties: "y";
                                     easing.type: "OutBack"; duration: 500 }
               }

               SequentialAnimation {
                   PauseAnimation { duration: 400 }
                   NumberAnimation { target: cloud3; properties: "y";
                                     easing.type: "OutBack"; duration: 500 }
               }
            }

            NumberAnimation { target: sun; properties: "y";
                              easing.type: "OutBack"; duration: 500 }
        }
    }

    onPresent: { root.state = "final"; }
}
