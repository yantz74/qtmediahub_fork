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

// BrowserMainView is a holder component for
// BookmarksView and BrowserView. The two views
// are displayed in two states
Item {
    id: mainView

    property alias bookmarkMode: bookmarkView.state  // "gridview" or "listview"
    property alias browserEngine: browserView.browserEngine

    // Handle toolbar and 'openUrl' events
    function handleToolbarEvent(event) {
        switch (event) {
            // When switching grid and list views
            // second press on the same view mode switches
            // between browser and bookmarks
        case "gridview":    // Fall through
        case "listview":
            if (mainView.state == "bookmarks" &&
                    bookmarkMode == event &&
                    browserEngine.url != "")
            {
                mainView.state = "browser";
            }
            else {
                mainView.state = "bookmarks";
                bookmarkMode = event;
            }
            parent.urlInput.setVisible(false);
            break;
        case "back":
            browserEngine.back.trigger();
            break;
        case "forward":
            browserEngine.forward.trigger();
            break;
        case "reload":
            browserEngine.reload.trigger();
            break;
//        case "fullscreen":
//            if (browserEngine.url == "") {
//                console.log("... nope! no url");
//            }
//            else if (mainView.state == "bookmarks") {
//                console.log("... nope! showing bookmarks");
//            }
//            else {
//                setFullscreen(true);
//                // Make sure the content fills the screen also when browsed to
//                // right or bottom end of the page
//                if (browserView.contentWidth - browserView.contentX <= document.properties.width)
//                    browserView.contentX -= document.properties.width - browserView.width;
//                if (browserView.contentHeight - browserView.contentY <= document.properties.height)
//                    browserView.contentY -= document.properties.height - browserView.height;
//            }
//            break;
        case "zoom_in":
            browserView.zoomIn();
            break;
        case "zoom_out":
            browserView.zoomOut();
            break;
        case "enterurl":
            urlInput.setVisible(true);
            break;
        }
    }

    function openUrl(url) {
        mainView.state = "browser";
        browserView.openUrl(url);
    }

    // View which displays the browser
    BrowserView {
        id: browserView
        anchors.fill: parent
        // Clipping is disabled in fullscreen and during
        // transitions to allow smooth animations)
//        clip: !inFullscreen // TODO digia
    }

    // Bookmark view
    BookmarkView {
        id: bookmarkView
        anchors.fill: parent
        anchors.margins: 30
        state: "gridview"

        // When clicking on a bookmark, switch to
        // the browser view and open the url
        onBookmarkSelected: {
            browserView.openUrl(url);
            // Start displaying browser view
            mainView.state = "browser"
        }
    }

    // Main view consists of bookmarks and browser sub views
    // When entering a state
    states: [
        State {
            name: "bookmarks"
            PropertyChanges{
                target: bookmarkView
                y: 0
                opacity: 1
            }
            PropertyChanges {
                target: browserView
                opacity: 0
                height: 0
            }
            StateChangeScript { script: setToolbarModel(toolbarBtnsBookmarks) }
        },

        State {
            name: "browser"
            PropertyChanges{
                target: bookmarkView
                y: parent.height
                opacity: 0
            }
            PropertyChanges {
                target: browserView
                opacity: 1
                height: mainView.height
            }
            StateChangeScript { script: setToolbarModel(toolbarBtnsBrowser) }
        }
    ]

    // Handle transitions slightly differently when switching between modes. In
    // browser->bookmarks transition change parameters at the same time,
    // and in bookmarks->browser transition do then in sequence with a small pause
    transitions: [
        Transition {
            to: "browser"
            reversible: true
            NumberAnimation { properties: "y,opacity,height"; easing.type: "InOutQuad"; duration: 500 }
        },
        Transition {
            to: "bookmarks"
            reversible: true
            SequentialAnimation {
                NumberAnimation { properties: "y,height"; easing.type: "InOutQuad" ; duration: 500 }
                PauseAnimation { duration: 100 }
                NumberAnimation { properties: "opacity"; easing.type: "OutSine"; duration: 500 }
            }
        }
    ]
}
