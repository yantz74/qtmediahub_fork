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
import QtWebKit 1.0
//import "../shared"

// BrowserView component. The actual view
// is wrapped inside an Item component
// together with scroll bars and progress bar
Item {
    id: wrapper

    // Zoom value when zooming with double click
    property real doubleClickZF: 2.0
    property alias browserEngine: browserEngine
    property alias contentWidth: browserView.contentWidth
    property alias contentHeight: browserView.contentHeight
    property alias contentX: browserView.contentX
    property alias contentY: browserView.contentY

    // Open a url by assigning the url value
    // to WebView component
    function openUrl(url) {
        browserEngine.url = url;
    }
    // Zoom in/out the web page
    function zoomIn() {
        browserEngine.contentsScale += 0.1;
    }
    function zoomOut() {
        // Do not scale smaller than the original size
        if (browserEngine.contentsScale > 1)
            browserEngine.contentsScale -= 0.1;
    }

    Flickable {
        id: browserView

        anchors.fill: parent
        // Allocate size for content which is at least as big as the view area
        contentWidth: Math.max(parent.width, browserEngine.width)
        contentHeight: Math.max(parent.height, browserEngine.height)

        // Black background for the browserView
        Rectangle  {
            id: browserBackground
            anchors.fill: parent
            color: 'black'
        }

        // The actual web page content
        WebView {
            id: browserEngine

            preferredWidth: browserView.width
            preferredHeight: browserView.height

            // On double click try to find a new zoom level with
            // heuristicZoom(). if it is not possible,
            //  zoom with default zooming factor
            onDoubleClick: {
                if (!browserEngine.heuristicZoom(clickX, clickY, 5.0)) {
                    var zf = doubleClickZF;
                    if (contentsScale > 1)
                        zf = 1;
                    browserEngine.zoomTo(zf, clickX, clickY);
                }
            }
            // If web page loading fails,
            // just hide the progress indicator
            onLoadFailed: {
                console.log("failed to load",url);
                progressIndicator.state = "hidden";
            }

            // When loading starts,
            // display the progress indicator
            onLoadStarted: {
                console.log("loading", url);
                progressIndicator.state = "visible";
            }
            // When loading finishes,
            // hide the progress indicator
            onLoadFinished: {
                console.log("finished loading", url);
                progressIndicator.state = "hidden";
            }

            // zoomTo handler of WebView
            onZoomTo: contentsScale = zoom
        }
    }

    // Vertical scroll bar
//    ScrollIndicator {
//        id:         yScroller

//        position:   browserView.visibleArea.yPosition
//        zoom:       browserView.visibleArea.heightRatio
//        shown:      browserView.moving
//        anchors.top:    parent.top
//        anchors.bottom: parent.bottom
//        anchors.right:  parent.right
//    }

    // Horizontal scroll bar.
    // ScrollIndicator is vertical only; rotate to get horizontal scroller
//    ScrollIndicator {
//        id:         xScroller

//        position:   browserView.visibleArea.xPosition
//        zoom:       browserView.visibleArea.widthRatio
//        shown:      browserView.moving && browserView.visibleArea.widthRatio < 1
//        anchors.bottom: yScroller.bottom
//        anchors.right:  yScroller.left
//        height: parent.width - yScroller.width

//        transform: Rotation {
//            angle: -90
//            origin.x: xScroller.width / 2
//            origin.y: xScroller.height-xScroller.width / 2
//        }
//    }

    // Display progress indicator with data obtained
    // from webEngine component
    ProgressIndicator {
        id: progressIndicator

        progress: browserEngine.progress
        height: 30
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        state: "hidden"

        // When pressing stop button,
        // stop loading the web page
        onStopped: browserEngine.stop.trigger()
    }
}
