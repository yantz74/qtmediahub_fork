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


Item {
    id: root
    width: 680; height: 216

    property real speed: speedDial.value
    property real rotation: rotationDial.value

    property bool animationRunning

    SpeedDial {
        id: speedDial;
        anchors.top: parent.top
        anchors.left: parent.left

        //value: speedSlider.x *120 / (speedContainer.width - 34)
        MouseArea {
            id: animationMouseArea1
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            onClicked: { mainElement.reverting = !mainElement.reverting}
        }
    }

    RotationDial {
        id: rotationDial;
        anchors.top: parent.top
        anchors.right: parent.right

        //value: rotationSlider.x *60 / (speedContainer.width - 34)

        MouseArea {
            id: animationMouseArea2
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            onClicked: { simulationAnimation.running = !simulationAnimation.running }
        }
    }

    ReservoirDial {
        id: reservoirDial;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32

        //value: reservoirSlider.x *1 / (speedContainer.width - 34)
    }

    Image {
        id: flasherRight
        scale: 0.5
        opacity: 0.2
        source: "iconRight.png"

        anchors.right: rotationDial.left
        anchors.rightMargin: -32            // This is needed because of sacle ... a bug?
        anchors.bottom: reservoirDial.top
        anchors.bottomMargin: -32           // This is needed because of sacle ... a bug?

        MouseArea {
            id: mouseAreaRightFlasher
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            onClicked: {
                if(rightFlasherAnimation.running == true) {
                    rightFlasherAnimation.loops = 1
                    rightFlasherAnimation.complete()
                }
                else {
                    rightFlasherAnimation.loops = Animation.Infinite
                    rightFlasherAnimation.start()
                }
            }
        }
    }

    Image {
        id: flasherLeft
        scale: 0.5
        opacity: 0.2
        source: "iconLeft.png"

        anchors.left: speedDial.right
        anchors.leftMargin: -32            // This is needed because of sacle ... a bug?
        anchors.bottom: reservoirDial.top
        anchors.bottomMargin: -32          // This is needed because of sacle ... a bug?

        MouseArea {
            id: mouseAreaLeftFlasher
            anchors.fill: parent
            onClicked: {
                if(leftFlasherAnimation.running == true) {
                    leftFlasherAnimation.loops = 1
                    leftFlasherAnimation.complete()
                }
                else {
                    leftFlasherAnimation.loops = Animation.Infinite
                    leftFlasherAnimation.start()
                }
            }
        }
    }

    SequentialAnimation {
        id: leftFlasherAnimation
        PropertyAnimation { target: flasherLeft; property: "opacity"; from: 0.2; to: 1.0; duration: 50 }
        PauseAnimation { duration: 250 }
        PropertyAnimation { target: flasherLeft; property: "opacity"; from: 1.0; to: 0.2; duration: 300; easing.type: "OutExpo"}
    }

    SequentialAnimation {
        id: rightFlasherAnimation
        PropertyAnimation { target: flasherRight; property: "opacity"; from: 0.2; to: 1.0; duration: 50 }
        PauseAnimation { duration: 250 }
        PropertyAnimation { target: flasherRight; property: "opacity"; from: 1.0; to: 0.2; duration: 300; easing.type: "OutExpo"}
    }

    PropertyAnimation {
        id: saniGasUsage;
        target: reservoirDial; property: "value";
        from: 1.0; to: 0.0; duration: 30000; /* wast whole tank in 1/2 minute ;)*/
        running: mainElement.ignition && root.animationRunning
        loops: Animation.Infinite
    }

    SequentialAnimation {
        id: simulationAnimation // short: sani
        running: true
        paused: !root.animationRunning
        loops: Animation.Infinite

        //delay at the beginning
        PauseAnimation { duration: 1000 }

        ParallelAnimation {
            id: saniStart

            SequentialAnimation {
                ScriptAction { script: {  mainElement.gearSetter = 0 } }
                ScriptAction { script: {  mainElement.ignition = true } }
                PropertyAnimation { target: rotationDial; property: "value"; from: 0; to: 60;  duration: 800}
                PropertyAnimation { target: rotationDial; property: "value"; from: 60; to: 8;  duration: 800}
            }

            PropertyAnimation { target: reservoirDial; property: "value"; from: 0.0; to: 1.0; duration: 1000}
        }

        ParallelAnimation {
            id: saniRunningCar

            SequentialAnimation {
                id: saniMovingAround

                // TODO their needs to be a better way then copy past ...
                SequentialAnimation {
                    id: saniFlashLeftAndTakeALookOverTheShow

                    ScriptAction { script: {
                            leftFlasherAnimation.loops = 4
                            leftFlasherAnimation.start()
                        } }

                    PauseAnimation { duration: 2000 }
                }

                ParallelAnimation {
                    id: saniStartDrivingAndAccelerateTo40

                    SequentialAnimation {
                        ScriptAction { script: { mainElement.gearSetter = 1 } }
                        PropertyAnimation { target: rotationDial; property: "value"; from: 8; to: 5;  duration: 500}
                        PropertyAnimation { target: rotationDial; property: "value"; from: 5; to: 30;  duration: 2000}
                    }

                    PropertyAnimation { target: speedDial; property: "value"; from: 0; to: 40;  duration: 2000}
                }

                SequentialAnimation {
                    id: saniShiftToSecondGear
                    PropertyAnimation { target: rotationDial; property: "value"; from: 30; to: 8;  duration: 350}
                    ScriptAction { script: { mainElement.gearSetter = 2 } }
                    PropertyAnimation { target: rotationDial; property: "value"; from: 8; to: 15;  duration: 200}
                }

                ParallelAnimation {
                    id: saniAccelerateTo70
                    PropertyAnimation { target: rotationDial; property: "value"; from: 15; to: 35;  duration: 2000}
                    PropertyAnimation { target: speedDial; property: "value"; from: 40; to: 70;  duration: 2000}
                }

                SequentialAnimation {
                    id: saniShiftToThirdGear
                    PropertyAnimation { target: rotationDial; property: "value"; from: 35; to: 8;  duration: 380}
                    ScriptAction { script: { mainElement.gearSetter = 3 } }
                    PropertyAnimation { target: rotationDial; property: "value"; from: 8; to: 20;  duration: 200}
                }

                SequentialAnimation {
                    ParallelAnimation {
                        id: saniAccelerateTo100
                        PropertyAnimation { target: rotationDial; property: "value"; from: 20; to: 40;  duration: 2000}
                        PropertyAnimation { target: speedDial; property: "value"; from: 70; to: 100;  duration: 2000}
                    }
                    ScriptAction { script: rightFlasherAnimation.start() }
                }

                ParallelAnimation {
                    id: saniDeCoupleAndSlowdownTo0
                    PropertyAnimation { target: rotationDial; property: "value"; from: 25; to: 8;  duration: 250}
                    PropertyAnimation { target: speedDial; property: "value"; from: 100; to: 0;  duration: 2000}
                    ScriptAction { script:  {
                            rightFlasherAnimation.loops = 4
                            rightFlasherAnimation.start()
                        }  }
                }

                PauseAnimation { duration: 1000 }

                SequentialAnimation {
                    id: parallelParking
                    ScriptAction { script: { mainElement.gearSetter = -2 } }

                    ParallelAnimation {
                        PropertyAnimation { target: rotationDial; property: "value"; from: 8; to: 15;  duration: 1500}
                        PropertyAnimation { target: speedDial; property: "value"; from: 0; to: 10;  duration: 1500}
                    }
                    ParallelAnimation {
                        PropertyAnimation { target: rotationDial; property: "value"; from: 15; to: 8;  duration: 2000}
                        PropertyAnimation { target: speedDial; property: "value"; from: 10; to: 0;  duration: 2000}
                    }

                    ParallelAnimation {
                        PropertyAnimation { target: rotationDial; property: "value"; from: 8; to: 10;  duration: 1000}
                        PropertyAnimation { target: speedDial; property: "value"; from: 0; to: 5;  duration: 1000}
                    }
                    ParallelAnimation {
                        PropertyAnimation { target: rotationDial; property: "value"; from: 10; to: 8;  duration: 1000}
                        PropertyAnimation { target: speedDial; property: "value"; from: 5; to: 0;  duration: 1000}
                    }

                    PauseAnimation { duration: 2000 }

                    ScriptAction { script: { mainElement.gearSetter = 0 } }
                }

                PauseAnimation { duration: 1000 }

                ParallelAnimation {
                    ScriptAction { script: {  mainElement.ignition = false } }
                    ScriptAction { script: {  mainElement.gearSetter = -1 } }
                    PropertyAnimation { target: rotationDial; property: "value"; from: 8; to: 0;  duration: 300}
                }

                PauseAnimation { duration: 1000 }
            }
        }
    }
}

