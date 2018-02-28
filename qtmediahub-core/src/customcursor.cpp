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

#include "customcursor.h"

#ifdef QT5
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <QPixmap>
#include <QDebug>

#include "globalsettings.h"

class MouseEventHorizon : public QObject
{
public:
    MouseEventHorizon(QObject *p) : QObject(p) { /**/ }

    bool eventFilter(QObject *obj, QEvent *event) {
        if (event->type() == QEvent::MouseMove) {
            return true;
        }
        return QObject::eventFilter(obj, event);
    }
};

CustomCursor::CustomCursor(GlobalSettings *settings, QObject *parent) :
    QObject(parent),
    m_timer(new QTimer(this)),
    m_clickedTimer(0),
    m_currentBehavior(Blank),
    m_blankCursor(Qt::BlankCursor),
    m_eventSink(new MouseEventHorizon(this)),
    m_settings(settings)
{
    connect(m_timer, SIGNAL(timeout()), this, SLOT(handleIdleTimeout()));
    enableCursor(m_settings->isEnabled(GlobalSettings::Mouse));
}

void CustomCursor::enableCursor(bool enable, bool temporary)
{
    qApp->removeEventFilter(m_eventSink);
    qApp->removeEventFilter(this);
    if (enable) {
        m_clickedTimer = new QTimer(this);
        m_clickedTimer->setSingleShot(true);
        m_clickedTimer->setInterval(200);
        connect(m_clickedTimer, SIGNAL(timeout()), this, SLOT(handleClickedTimeout()));

        qApp->installEventFilter(this);
        m_timer->setInterval(m_settings->value(GlobalSettings::MouseTimeout).toInt() * 1000);
    } else {
        qApp->installEventFilter(m_eventSink);
    }
    if (!temporary)
        m_settings->setValue(GlobalSettings::Mouse, enable);
}

void CustomCursor::moveBy(int dx, int dy)
{
    QPoint pos = QCursor::pos();
    QCursor::setPos(pos.x() + dx, pos.y() + dy);
}

QString CustomCursor::defaultCursorPath() const
{
    return m_defaultCursorPath;
}

QString CustomCursor::clickedCursorPath() const
{
    return m_clickedCursorPath;
}

void CustomCursor::setDefaultCursorPath(const QString &path)
{
    m_defaultCursorPath = path;
    m_defaultCursor = QCursor(QPixmap(m_defaultCursorPath), 0, 0);
}

void CustomCursor::setClickedCursorPath(const QString &path)
{
    m_clickedCursorPath = path;
    m_clickedCursor = QCursor(QPixmap(m_clickedCursorPath), 0, 0);
}

void CustomCursor::setCursor(Behavior current)
{
    if (m_currentBehavior == current)
        return;

    switch(current)
    {
    case Default:
        qApp->changeOverrideCursor(m_defaultCursor);
        break;
    case Clicked:
        qApp->changeOverrideCursor(m_clickedCursor);
        break;
    case Blank:
        qApp->changeOverrideCursor(m_blankCursor);
    default:
        break;
    }

    m_currentBehavior = current;
}

bool CustomCursor::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::MouseMove) {
        if (m_timer)
            m_timer->start();
        setCursor(Default);
    } else if (event->type() == QEvent::MouseButtonPress) {
        setCursor(Clicked);
        m_clickedTimer->start();
    }
    return QObject::eventFilter(obj, event);
}

void CustomCursor::handleClickedTimeout()
{
    setCursor(Default);
}

void CustomCursor::handleIdleTimeout()
{
    setCursor(Blank);
}
