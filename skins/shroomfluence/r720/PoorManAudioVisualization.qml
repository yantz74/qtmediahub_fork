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
import QtQuick.Particles 2.0

Rectangle {
	id: root
    anchors.fill: parent
//    width: 1920; height: 1080
//    width: 1368; height: 768
    color: "black" 

	SequentialAnimation on color {
		running: false
		loops: Animation.Infinite
		ColorAnimation { to: "black"; duration: 300; }
		ColorAnimation { to: "darkmagenta"; duration: 300; }
	}
Item {
        id: circle
        //anchors.fill: parent
        property real radius: 0
        property real dx: trunk.width / 2
        property real dy: trunk.height / 2
        property real cx: radius * Math.sin(percent*6.283185307179) + dx
        property real cy: radius * Math.cos(percent*6.283185307179) + dy
        property real percent: 0

        SequentialAnimation on percent {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
            duration: 1000
            from: 1
            to: 0
            loops: 8
            }
            NumberAnimation {
            duration: 1000
            from: 0
            to: 1
            loops: 8
            }

        }

        SequentialAnimation on radius {
            loops: Animation.Infinite
            running: true
            NumberAnimation {
                duration: 4000
                to: 50
            }
            NumberAnimation {
                duration: 4000
                to: 0
            }
        }
    }



        ShaderEffectSource {
        id: src
        anchors.fill: parent
        recursive: true
        smooth: true
        sourceItem: item
        hideSource: true
        property real angle: 60
        SequentialAnimation on angle {
            loops: Animation.Infinite
            NumberAnimation { to: 30; duration: 2000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 60; duration: 2000; easing.type: Easing.InOutSine }
        }
    }	

    Item {
        id: item
        anchors.fill: parent
	
        Rectangle {
            id: trunk
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 150
            width: 200
            height: 200
            //color: "#111122"
            color: "black"
            radius: 20
	    smooth: true
            
            /*Text {
                anchors.centerIn: parent
                text: "Qt"
                color: "darkgreen"
                font.pixelSize: parent.height * 0.6
        Image {
            id: trunk
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 150
	    source: "/home/eupton/qt-logo.png"
            width: 200
            height: 200
	*/
    	ParticleSystem { id: sys1 }

	ImageParticle {
        system: sys1
        source: "particle.png"
        color: "cyan"
        alpha: 0
        SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation {
                from: "cyan"
                to: "magenta"
                duration: 1000
            }
            ColorAnimation {
                from: "magenta"
                to: "blue"
                duration: 2000
            }
            ColorAnimation {
                from: "blue"
                to: "violet"
                duration: 2000
            }
            ColorAnimation {
                from: "violet"
                to: "cyan"
                duration: 2000
            }
        }
        colorVariation: 0.3
    }
    Emitter {
        id: trailsNormal
        system: sys1

        emitRate: 600
        lifeSpan: 3000


        y: circle.cy
        x: circle.cx

        speed: PointDirection {xVariation: 4; yVariation: 4;}
        acceleration: PointDirection {xVariation: 10; yVariation: 10;}
        speedFromMovement: 8

        size: 12
        sizeVariation: 4
    }


	
	SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation { to: 1; duration: 2000; }
            NumberAnimation { to: 1.2; duration: 3000; }
        }

	    NumberAnimation on rotation {
		loops: Animation.Infinite
		running: false
		from: 0
		to: 360
		duration: 2000
	    }
        }
        ShaderEffect {
            anchors.fill: parent
            opacity: 0.95
            smooth: true
            transform: [
                Translate { x: -trunk.x; y: -(trunk.y + trunk.height) },
                Rotation { angle: -src.angle },
                Scale { xScale: Math.cos(src.angle * Math.PI / 180); yScale: xScale },
                Translate { x: trunk.x; y: trunk.y }
            ]
            property variant source: src
            //property color color: "green"
            property color color: "black"
	    fragmentShader: "
                uniform sampler2D source;
                uniform lowp vec4 color;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    lowp vec4 c = texture2D(source, qt_TexCoord0);
                    gl_FragColor = vec4(mix(c.xyz, color.xyz * c.w, 0.05), c.w) * qt_Opacity;
                }"
        }
        ShaderEffect {
            anchors.fill: parent
            opacity: 0.95
            transform: [
                Translate { x: -(trunk.x + trunk.width); y: -(trunk.y + trunk.height) },
                Rotation { angle: 90 - src.angle },
                Scale { xScale: Math.sin(src.angle * Math.PI / 180); yScale: xScale },
                Translate { x: (trunk.x + trunk.width); y: trunk.y }
            ]
            property variant source: src
            //property color color: "#ff0000"
            property color color: "black"
	    SequentialAnimation on color {
		loops: Animation.Infinite
		running: false
		ColorAnimation { to: "black"; duration: 4000 }
		ColorAnimation { to: "blue"; duration: 3000 }
 	    }
            fragmentShader: "
                uniform sampler2D source;
                uniform lowp vec4 color;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    lowp vec4 c = texture2D(source, qt_TexCoord0);
                    gl_FragColor = vec4(mix(c.xyz, color.xyz * c.w, 0.08), c.w) * qt_Opacity;
                }"
        }
    }
}
