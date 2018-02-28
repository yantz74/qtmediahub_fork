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

import QtQuick 1.1
import Qt3D 1.0
import Qt3D.Shapes 1.0
import QtMediaHub.components.media 1.0

ParticleVisualization {
    running: true
    width: parent.width; height: parent.height
    Viewport {
        width: parent.width; height: parent.height

        light: Light {
            direction: Qt.vector3d(1, 0, 2)
        }

        Sphere {
            scale: 1.5
            levelOfDetail: 6
            axis: Qt.YAxis

            effect: Effect {
                // Moon texture sourced from:
                // http://www.lns.cornell.edu/~seb/celestia/moon-4k-18.jpg
                // The source texture was scaled down to a more reasonable size,
                // and the brightness and contrast were increased.
                texture: "moon-texture.jpg"
            }
            
            transform: [
                Scale3D { scale: 1.5 },
                Rotation3D {
                    axis: Qt.vector3d(1, 1, 1)
                    NumberAnimation on angle {
                        running: true
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 200000
                    } 
                }
            ]
        }
    }
}
