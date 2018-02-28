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

Rectangle {
    // some values (e.g. width, carImage.y) are kind of crap .. but are working, so keeping for now. TODO: cleanup :)

    property int innerRadius: 80
    property int additionalSpace: 50
    property int rightShift: 250
    width: rightShift*2 + additionalSpace*2
    property bool animationRunning: false

    Image {
        id: carImage
        source: "simple-car-top_view.png"
        x: rightShift-additionalSpace-(innerRadius/2)-10
        y: -60
        width: additionalSpace+innerRadius*2
        height: 120

    }



    DistanceBeam {
        id: leftOuterBack
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: -30}
        x: innerRadius + rightShift + additionalSpace
    }
    DistanceBeam {
        id: leftMidBack
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: -10}
        x: innerRadius + rightShift + additionalSpace
    }
    DistanceBeam {
        id: rightMidBack
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: 10}
        x: innerRadius + rightShift + additionalSpace
    }
    DistanceBeam {
        id: rightOuterBack
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: 30}
        x: innerRadius + rightShift + additionalSpace
    }


    DistanceBeam {
        id: leftOuterFront
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: -210}
        x: innerRadius + rightShift - additionalSpace
    }
    DistanceBeam {
        id: leftMidFront
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: -190}
        x: innerRadius + rightShift - additionalSpace
    }
    DistanceBeam {
        id: rightMidFront
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: 190}
        x: innerRadius + rightShift - additionalSpace
    }
    DistanceBeam {
        id: rightOuterFront
        transform: Rotation { origin.x: -innerRadius; origin.y: 0; angle: 210}
        x: innerRadius + rightShift - additionalSpace
    }

    states: [
        State { when: animationRunning; name: "animating" },
        State { when: !animationRunning; name: "notAnimating" }
    ]

    transitions: [
        Transition { from: "*"; to: "notAnimating"; ScriptAction { script: parallelParkingAnimation.stop() } },
        Transition { from: "*"; to: "animating";    ScriptAction { script: parallelParkingAnimation.start()} }
    ]



    SequentialAnimation {
        id: parallelParkingAnimation
        running: false
        /*loops: Animation.Infinite*/

        //ScriptAction { script: {rightOuterBack.distance=7} }
        ScriptAction { script: {rightMidBack.distance=7} }
        ScriptAction { script: {leftMidBack.distance=7} }
        ScriptAction { script: {leftOuterBack.distance=7} }

        ScriptAction { script: {leftOuterFront.distance=7} }
        ScriptAction { script: {leftMidFront.distance=7} }
        ScriptAction { script: {rightMidFront.distance=7} }
        ScriptAction { script: {rightOuterFront.distance=7} }


        ScriptAction { script: {rightOuterBack.distance=6} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=5} }
        ScriptAction { script: {rightMidBack.distance=6} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=4} }
        ScriptAction { script: {rightMidBack.distance=5} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=3} }
        ScriptAction { script: {rightMidBack.distance=4} }
        ScriptAction { script: {leftMidBack.distance=6} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=2} }
        ScriptAction { script: {rightMidBack.distance=4} }
        ScriptAction { script: {leftMidBack.distance=5} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=2} }
        ScriptAction { script: {rightMidBack.distance=3} }
        ScriptAction { script: {leftMidBack.distance=4} }
        ScriptAction { script: {leftOuterBack.distance=6} }
        ScriptAction { script: {leftOuterFront.distance=5} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=2} }
        ScriptAction { script: {rightMidBack.distance=3} }
        ScriptAction { script: {leftMidBack.distance=4} }
        ScriptAction { script: {leftOuterBack.distance=5} }

        ScriptAction { script: {leftOuterFront.distance=4} }
        ScriptAction { script: {leftMidFront.distance=6} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=2} }
        ScriptAction { script: {rightMidBack.distance=2} }
        ScriptAction { script: {leftMidBack.distance=3} }
        ScriptAction { script: {leftOuterBack.distance=3} }

        ScriptAction { script: {leftOuterFront.distance=1} }
        ScriptAction { script: {leftMidFront.distance=4} }
        ScriptAction { script: {rightMidFront.distance=6} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=1} }
        ScriptAction { script: {rightMidBack.distance=1} }
        ScriptAction { script: {leftMidBack.distance=2} }
        ScriptAction { script: {leftOuterBack.distance=2} }

        ScriptAction { script: {leftOuterFront.distance=2} }
        ScriptAction { script: {leftMidFront.distance=3} }
        ScriptAction { script: {rightMidFront.distance=4} }
        ScriptAction { script: {rightOuterFront.distance=6} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=1} }
        ScriptAction { script: {rightMidBack.distance=1} }
        ScriptAction { script: {leftMidBack.distance=1} }
        ScriptAction { script: {leftOuterBack.distance=1} }

        ScriptAction { script: {leftOuterFront.distance=3} }
        ScriptAction { script: {leftMidFront.distance=4} }
        ScriptAction { script: {rightMidFront.distance=4} }
        ScriptAction { script: {rightOuterFront.distance=5} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=2} }
        ScriptAction { script: {rightMidBack.distance=2} }
        ScriptAction { script: {leftMidBack.distance=2} }
        ScriptAction { script: {leftOuterBack.distance=2} }

        ScriptAction { script: {leftOuterFront.distance=3} }
        ScriptAction { script: {leftMidFront.distance=3} }
        ScriptAction { script: {rightMidFront.distance=3} }
        ScriptAction { script: {rightOuterFront.distance=3} }
        PauseAnimation { duration: 500 }


        ScriptAction { script: {rightOuterBack.distance=3} }
        ScriptAction { script: {rightMidBack.distance=3} }
        ScriptAction { script: {leftMidBack.distance=3} }
        ScriptAction { script: {leftOuterBack.distance=3} }

        ScriptAction { script: {leftOuterFront.distance=2} }
        ScriptAction { script: {leftMidFront.distance=2} }
        ScriptAction { script: {rightMidFront.distance=2} }
        ScriptAction { script: {rightOuterFront.distance=2} }
        PauseAnimation { duration: 500 }
    }
}
