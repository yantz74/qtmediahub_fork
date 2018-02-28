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

// BookmarkView displays the stored bookmarks
// either in grid or list modes. Clicking
// a bookmark opens the associated web page
Item {
    id: container

    // In grid view the bookmarks are
    // allocated in three columns
    property int columns: 3
    // Dimensions for a bookmark in the list view
    property int bmWidth: 0.31*container.width
    property int bmHeight: 110
    property int bmSpacing: 20
    // Bookmark item dimensions
    property real itemHeight: container.height/3
    property real itemWidth: container.width/4
    // Bookmark icon dimensions in the grid view
    property int iconWidth: 0.7*itemWidth
    property int iconHeight: 0.7*itemHeight
    property real xstep: itemWidth + bmSpacing
    // Parameters handing the transition between
    // grid and list views
    property real ystep: 0
    property real ystep3: itemHeight+bmSpacing

    // Signals observers that a bookmark has been selected
    signal bookmarkSelected(string url)

    state: "gridview"

    // Bookmark drawer for bookmark list items. The
    // drawer dimensions and position change according
    // to the used bookmark view state (grid or list).
    // In effect, the bookmark list items are transitioned
    // between grid and list layouts
    Component {
        id: bookmarkDrawer

        Item {
            id: wrapper

            width: itemWidth
            height: itemHeight
            // Define the position according to the current
            // animation parameter state
            x: xstep/3 + (index % columns) * xstep
            y: Math.floor(index / columns) * ystep3  + (index % columns)*ystep

            // Border image for the item.
            BorderImage {
                id: bookmarkBackgroundborder
                border.left: 22
                border.top: 20
                border.right: 22
                border.bottom: 20
                horizontalTileMode: BorderImage.Stretch
                verticalTileMode:  BorderImage.Stretch
                width:parent.width
                height: parent.height
                source: "../images/icons/listbar_internet.png"
            }

            // Bookmark icon obtained from dummydata
            Image {
                id: bookmarkIcon
                y: 5
                anchors.horizontalCenter: parent.horizontalCenter
                source:  picture
                width: iconWidth
                height: iconHeight
                fillMode: "PreserveAspectFit"
            }

            // Bookmark title
            Text {
                id: bookmarkText
                font.pixelSize: 18
                font.bold: true
                color: "lightgrey"
                text: title
                anchors.horizontalCenter: wrapper.horizontalCenter
                // Align the text either below the icon, or middle of the list item
                y: {
                    if (bookmarkIcon.height > (wrapper.height - height) / 2)
                        return anchors.topMargin + bookmarkIcon.y + bookmarkIcon.height
                    else
                        return (wrapper.height - height) / 2
                }
            }

            // When clicking the bookmark item, notify observers
            MouseArea {
                anchors.fill: parent
                onClicked: container.bookmarkSelected(url)
            }
        }
    }
    // The bookmark list. Use Flickable here instead or
    // ListView or GridView to allow switching between
    // list and grid modes in the same component
    Flickable {
        id: flickable
        width: container.width
        height: container.height
        contentWidth: container.width
        contentHeight: repe.height
        clip: true

        // Use Repeater and its delegate property
        // to draw the items in correct positions
        Repeater {
            id: repe
            anchors.fill:parent
            // bookmarkData is obtained from dummydata
            model: ListModel {
                ListElement {
                    title: "Qt"
                    url: "http://qt.nokia.com/"
                    picture: "../images/bookmarks/qt.png"
                }
                ListElement {
                    title: "Nokia"
                    url: "http://europe.nokia.com/home"
                    picture: "../images/bookmarks/nokia_europe.png"
                }
                ListElement {
                    title: "QtMediaHub"
                    url: "http://www.qtmediahub.com/"
                    picture: "../images/bookmarks/QMHLogo.png"
                }
                ListElement {
                    title: "Slashdot"
                    url: "http://slashdot.org/"
                    picture: "../images/bookmarks/slashdot.png"
                }
                ListElement {
                    title: "BBC"
                    url: "http://www.bbc.co.uk"
                    picture: "../images/bookmarks/bbc.png"
                }
                ListElement {
                    title: "Google"
                    url: "http://www.google.com"
                    picture: "../images/bookmarks/google.png"
                }
            }

            delegate: bookmarkDrawer
        }
    }

    // The bookmark list has grid and list modes,
    // which are implemented in two states
    states:
        State {
        name: "listview"
        PropertyChanges {
            target: container
            itemHeight: 65
            itemWidth: columns*bmWidth + (columns-1)*bmSpacing
            iconHeight: 0
            iconWidth: 0
            xstep: 0
            ystep: itemHeight + bmSpacing
            ystep3: (itemHeight + bmSpacing) * 3
        }
    }

    transitions:
        Transition {
        from: "gridview"
        to: "listview"
        reversible: true

        // Carry out the animation in sequence; first
        // the vertical transitions and then horizontal
        // transitions
        SequentialAnimation {
            NumberAnimation {
                properties: "iconHeight,itemHeight,y,ystep,ystep3"
                easing.type: "InOutQuad"
                duration: 500
            }
            NumberAnimation {
                properties: "iconWidth,itemWidth,x,xstep"
                easing.type: "InOutQuad"
                duration: 500
            }
        }
    }
}
