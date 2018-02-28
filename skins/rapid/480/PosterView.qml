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
import ActionMapper 1.0

PathView {
    id: pathView

    property string style: "carousel"
    property variant posterModel // Not an alias because of QTBUG-16357
    property alias rootIndex : visualDataModel.rootIndex
    signal rootIndexChanged() // Fire signals of aliases manually, QTBUG-14089
    property int delegateWidth : parent.width/6.4
    property int delegateHeight : parent.width/6.4
    property variant currentItem // QTBUG-16347
    signal clicked()
    signal activated()
    signal rightClicked(int mouseX, int mouseY)

    function currentModelIndex() {
        return visualDataModel.modelIndex(currentIndex);
    }

    function setPathStyle() {
        //console.debug("debug: PathView.setPathStyle( " + style + " )")
        pathView.preferredHighlightBegin = paths[style].highlightPos
        pathView.pathItemCount = paths[style].pathItemCount
        pathView.path = paths[style]
    }

    model: visualDataModel
    preferredHighlightEnd: pathView.preferredHighlightBegin

    VisualDataModel {
        id: visualDataModel
        delegate : PosterViewDelegate { }
        Component.onCompleted: {
            model = pathView.posterModel // Workaround for QTBUG-16357
            var oldRootIndex = rootIndex
            rootIndex = modelIndex(0)
            rootIndex = oldRootIndex // Workaround for QTBUG-16365
        }
    }

    Component.onCompleted: {
        setPathStyle()
    }

    onCountChanged: {
        if(pathView.count >= 15 && style == "carousel") {
            style = "carousel2"
            setPathStyle()
        } else if(pathView.count < 15 && style == "carousel2") {
            style = "carousel"
            setPathStyle()
        }
    }

    QtObject {
        id: paths

        property PosterPath coverFlood: PosterPath {
            id: coverFlood
            highlightPos: 0.5
            pathItemCount: 7
            startX: 0; startY: (pathView.height - pathView.delegateHeight)/2.0
            PathAttribute { name: "rotation"; value: 70 }
            PathAttribute { name: "z"; value: 1.0 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: pathView.width/2 - pathView.delegateHeight/2.0 - 1; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: 55 }
            PathAttribute { name: "z"; value: 20.0 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: pathView.width/2; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: 0 }
            PathAttribute { name: "z"; value: 40 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: pathView.width/2 + pathView.delegateHeight/2.0 + 1; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: -55 }
            PathAttribute { name: "z"; value: 20.0 }
            PathAttribute { name: "scale"; value: 2.0 }
            PathLine { x: pathView.width; y: coverFlood.startY }
            PathAttribute { name: "rotation"; value: -70 }
            PathAttribute { name: "z"; value: 1.0 }
            PathAttribute { name: "scale"; value: 2.0 }
        }
        property PosterPath carousel: PosterPath {
            id: carousel
            highlightPos: 0.75
            pathItemCount: 15

            property double horizCenter: pathView.width/2
            property double vertCenter: (pathView.height - pathView.delegateHeight)/2.0

            property double perspectiveFlatteningFactor: 1.5
            property double offsetWidth: pathView.delegateWidth * 2.5
            property double offsetHeight: pathView.delegateHeight/perspectiveFlatteningFactor

            property double horizHypot: offsetWidth/Math.sqrt(2)
            property double vertHypot: offsetHeight/Math.sqrt(2)

            startX: carousel.horizCenter - offsetWidth; startY: carousel.vertCenter

            PathAttribute { name: "z"; value: 4 }
            PathAttribute { name: "scale"; value: 1 }
            PathQuad { x: carousel.horizCenter; y: carousel.vertCenter - carousel.offsetHeight; controlX: carousel.horizCenter - carousel.horizHypot; controlY: carousel.vertCenter - carousel.vertHypot }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "scale"; value: 0.5 }
            PathQuad { x: carousel.horizCenter + carousel.offsetWidth; y: carousel.vertCenter; controlX: carousel.horizCenter + carousel.horizHypot; controlY: carousel.vertCenter - carousel.vertHypot }
            PathAttribute { name: "z"; value: 4 }
            PathAttribute { name: "scale"; value: 1 }
            PathQuad { x: carousel.horizCenter; y: carousel.vertCenter + carousel.offsetHeight; controlX: carousel.horizCenter + carousel.horizHypot; controlY: carousel.vertCenter + carousel.vertHypot }
            PathAttribute { name: "z"; value: 7 }
            PathAttribute { name: "scale"; value: 3.0 }
            //Origin
            PathQuad { x: carousel.startX; y: carousel.startY; controlX: carousel.horizCenter - carousel.horizHypot; controlY: carousel.vertCenter + carousel.vertHypot }
        }
        property PosterPath carousel2: PosterPath {
            id: carousel2
            highlightPos: 0.5
            pathItemCount: 60

            property double horizDamping: 0.85; property double horizDampingINV: 1-horizDamping
            property double vertDampingBOT: 0.7; property double vertDampingTOP: 0.1//kind of invers of vertDampingBOT

            startX: pathView.width/2.0;                           startY: pathView.height*carousel2.vertDampingTOP
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "scale"; value: 0.3 }


            PathQuad{
                controlX: pathView.width*carousel2.horizDampingINV; controlY: pathView.height*carousel2.vertDampingTOP
                x:         pathView.width*carousel2.horizDampingINV; y: pathView.height/2.0*carousel2.vertDampingBOT }
            PathAttribute { name: "z"; value: 5 }
            PathAttribute { name: "scale"; value: 1.0 }
            PathPercent { value: 0.40 }

            PathQuad {
                controlX: pathView.width*carousel2.horizDampingINV; controlY: pathView.height*carousel2.vertDampingBOT
                x: pathView.width/2.0;                            y: pathView.height*carousel2.vertDampingBOT }
            PathAttribute { name: "z"; value: 10 }
            PathAttribute { name: "scale"; value: 3.0 }
            PathPercent { value: 0.5 }

            PathQuad{
                controlX: pathView.width*carousel2.horizDamping; controlY: pathView.height*carousel2.vertDampingBOT
                x:         pathView.width*carousel2.horizDamping; y: pathView.height/2.0*carousel2.vertDampingBOT }
            PathAttribute { name: "z"; value: 5 }
            PathAttribute { name: "scale"; value: 1.0 }
            PathPercent { value: 0.60 }

            PathQuad{
                controlX: pathView.width*carousel2.horizDamping; controlY: pathView.height*carousel2.vertDampingTOP
                x:         pathView.width/2.0;                       y: pathView.height*carousel2.vertDampingTOP }
            PathAttribute { name: "z"; value: 1 }
            PathAttribute { name: "scale"; value: 0.3 }
            PathPercent { value: 1.0 }
        }
    }
}

