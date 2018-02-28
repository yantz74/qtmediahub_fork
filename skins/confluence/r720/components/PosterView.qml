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

PathView {
    id: root

    property int delegateWidth : confluence.width/6.4
    property int delegateHeight : confluence.width/6.4
    property variant currentItem // QTBUG-16347
    signal clicked()
    signal activated()
    signal rightClicked(int mouseX, int mouseY)

    function setPathStyle(style) {
        root.preferredHighlightBegin = paths[style].highlightPos
        root.pathItemCount = paths[style].pathItemCount
        root.path = paths[style]

        // ## QML Bug: PathView doesn't seem to load items when the path changes
        model.reset()
    }

    preferredHighlightEnd: root.preferredHighlightBegin
    dragMargin: width

    Keys.onRightPressed: root.incrementCurrentIndex()
    Keys.onLeftPressed: root.decrementCurrentIndex()
    Keys.onUpPressed: root.model.back()
    Keys.onDownPressed: root.currentItem.activate()

    delegate: PosterViewDelegate { }

    QtObject {
        id: paths
        property PosterPath linearZoom: PosterPath {
            id: linearZoom
            pathItemCount: (root.width+2*root.delegateWidth)/root.delegateWidth

            startX: -root.delegateWidth; startY: (root.height - root.delegateHeight)/2.0
            PathAttribute { name: "scale"; value: 1 }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "opacity"; value: 0.2 }
            PathLine { x: root.width/2.5; y: linearZoom.startY }
            PathAttribute { name: "scale"; value: 1.0 }
            PathLine { x: root.width/2.0; y: linearZoom.startY }
            PathAttribute { name: "scale"; value: 1.5 }
            PathAttribute { name: "z"; value: 2 }
            PathAttribute { name: "opacity"; value: 1.0 }
            PathLine { x: root.width/1.5; y: linearZoom.startY }
            PathAttribute { name: "scale"; value: 1.0 }
            PathLine { x: root.width+root.delegateWidth; y: linearZoom.startY }
            PathAttribute { name: "scale"; value: 1 }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "opacity"; value: 0.2 }
        }
        property PosterPath sidlingZoom: PosterPath {
            id: sidlingZoom
            pathItemCount: 15//(root.width+2*root.delegateWidth)/root.delegateWidth

            startX: -root.delegateWidth; startY: (root.height - root.delegateHeight)/2.0
            PathAttribute { name: "scale"; value: 1 }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "opacity"; value: 0.1 }
            PathLine { x: root.width/2.5; y: sidlingZoom.startY }
            PathAttribute { name: "scale"; value: 1.0 }
            PathAttribute { name: "opacity"; value: 0.3 }
            PathLine { x: root.width/2.0; y: sidlingZoom.startY }
            PathAttribute { name: "scale"; value: 1.5 }
            PathAttribute { name: "z"; value: 2 }
            PathAttribute { name: "opacity"; value: 1.0 }
            PathLine { x: root.width/1.5; y: sidlingZoom.startY }
            PathAttribute { name: "scale"; value: 1.0 }
            PathAttribute { name: "opacity"; value: 0.3 }
            PathLine { x: root.width+root.delegateWidth; y: sidlingZoom.startY }
            PathAttribute { name: "scale"; value: 1 }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "opacity"; value: 0.1 }
        }
        property PosterPath amphitheatreZoom: PosterPath {
            id: amphitheatreZoom
            pathItemCount: 10
            startX: 0; startY: (root.height - root.delegateHeight)*6.0/7.0
            PathAttribute { name: "rotation"; value: 90 }
            PathAttribute { name: "scale"; value: 0.5 }
            PathAttribute { name: "z"; value: 1 }
            PathQuad { x: root.width/2; y: (root.height - root.delegateHeight)/2.0; controlX: root.width/4.0; controlY: amphitheatreZoom.startY/2 }
            PathAttribute { name: "scale"; value: 1.4 }
            PathAttribute { name: "z"; value: 10 }
            PathQuad { x: root.width; y: amphitheatreZoom.startY; controlX: root.width*3.0/4.0; controlY: amphitheatreZoom.startY/2 }
            PathAttribute { name: "rotation"; value: -90 }
            PathAttribute { name: "scale"; value: 0.5 }
            PathAttribute { name: "z"; value: 1 }
        }
        property PosterPath coverFlood: PosterPath {
            id: coverFlood
            pathItemCount: 10
            startX: 0; startY: (root.height - root.delegateHeight)/2.0
            PathAttribute { name: "rotation"; value: 60 }
            PathAttribute { name: "z"; value: 1.0 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: root.width/2 - root.delegateHeight/2.0 - 1; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: 60 }
            PathAttribute { name: "z"; value: 20.0 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: root.width/2; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: 0 }
            PathAttribute { name: "z"; value: 40 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: root.width/2 + root.delegateHeight/2.0 + 1; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: -60 }
            PathAttribute { name: "z"; value: 20.0 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: root.width; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: -60 }
            PathAttribute { name: "z"; value: 1.0 }
            PathAttribute { name: "scale"; value: 2.0 }
        }
        property PosterPath carousel: PosterPath {
            id: carousel
            highlightPos: 0.75
            pathItemCount: 15

            property double horizCenter: root.width/2
            property double vertCenter: (root.height - root.delegateHeight)/2.0

            property double perspectiveFlatteningFactor: 1.6
            property double offsetWidth: root.delegateWidth * 2
            property double offsetHeight: root.delegateHeight/perspectiveFlatteningFactor

            property double horizHypot: offsetWidth/Math.sqrt(2)
            property double vertHypot: offsetHeight/Math.sqrt(2)

            startX: carousel.horizCenter - offsetWidth; startY: carousel.vertCenter

            PathAttribute { name: "z"; value: 4 }
            PathAttribute { name: "scale"; value: 0.6 }
            PathQuad { x: carousel.horizCenter; y: carousel.vertCenter - carousel.offsetHeight; controlX: carousel.horizCenter - carousel.horizHypot; controlY: carousel.vertCenter - carousel.vertHypot }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "scale"; value: 0.2 }
            PathQuad { x: carousel.horizCenter + carousel.offsetWidth; y: carousel.vertCenter; controlX: carousel.horizCenter + carousel.horizHypot; controlY: carousel.vertCenter - carousel.vertHypot }
            PathAttribute { name: "z"; value: 4 }
            PathAttribute { name: "scale"; value: 0.6 }
            PathQuad { x: carousel.horizCenter; y: carousel.vertCenter + carousel.offsetHeight; controlX: carousel.horizCenter + carousel.horizHypot; controlY: carousel.vertCenter + carousel.vertHypot }
            PathAttribute { name: "z"; value: 7 }
            PathAttribute { name: "scale"; value: 2.0 }
            //Origin
            PathQuad { x: carousel.startX; y: carousel.startY; controlX: carousel.horizCenter - carousel.horizHypot; controlY: carousel.vertCenter + carousel.vertHypot }
        }
    }

    onCountChanged: if (currentIndex == -1) currentIndex = 0
}

