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
import "components/"
import "./components/uiconstants.js" as UIConstants

Blade {
    id: root
    clip: false
    z: UIConstants.screenZValues.mainBlade
    focalWidget: rootMenu

    property int visibleWidth: root.bladeVisibleWidth
                               + subMenu.bladeVisibleWidth
    //FIXME: fudge factor below empirically derived
    //media blade pixmap packing alpha
                               - 12
    property alias subMenu : subMenu
    property alias rootMenu: rootMenu

    function close() {
        if (confluence.state == "" && avPlayer.playing) 
            show(transparentVideoOverlay)
    }

    bladeWidth: confluence.width/3.5
    bladePixmap: themeResourcePath + "/media/HomeBlade.png"

    content: RootMenu {
        id: rootMenu
        focus: true
        buttonGridX: bladeX + 5 + bladeRightMargin; 
        onOpenSubMenu: {
            if (currentItem.hasSubBlade) {
                subMenu.forceActiveFocus()
                // not really nice should be also a property of the currentItem, but I don't know how to add a QList<QObject*> property
                subMenuList.engine = null
            }
        }
        onActivated: confluence.setActiveEngine(index)
    }

    children: Blade {
        id: subMenu

        closedBladePeek: 10
        bladeWidth: 200
        bladeRightMargin: 8

        //Magical pixmap offset again
        anchors { left: root.right; leftMargin: -10 }

        bladePixmap: themeResourcePath + "/media/MediaBladeSub.png"

        Keys.onLeftPressed:
            subMenu.close()
        Keys.onMenuPressed:
            subMenu.close()

        SubBladeMenu {
            id: subMenuList
            focus: true
        }
    }
}
