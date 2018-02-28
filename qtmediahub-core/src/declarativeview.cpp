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

#include "declarativeview.h"
#include <QGraphicsObject>
#include <QDeclarativeEngine>
#include <QDebug>
#include <QPaintEvent>
#include <QShortcut>

#ifdef GL
#include <QGLWidget>
#endif

#include "globalsettings.h"

static void optimizeGraphicsViewAttributes(GlobalSettings *settings, QGraphicsView *view)
{
    if (settings->isEnabled(GlobalSettings::SmoothScaling))
        view->setRenderHints(QPainter::Antialiasing | QPainter::SmoothPixmapTransform | QPainter::TextAntialiasing);

    view->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    view->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    view->setFrameStyle(0);
    view->setOptimizationFlags(QGraphicsView::DontSavePainterState);
    view->scene()->setItemIndexMethod(QGraphicsScene::NoIndex);
    view->setCacheMode(QGraphicsView::CacheNone);
}

DeclarativeView::DeclarativeView(GlobalSettings *settings, QWidget *parent)
    : QDeclarativeView(parent),
      m_settings(settings),
      m_glViewport(false),
      m_frameCount(0),
      m_timeSigma(0),
      m_fps(0)
{
    new QShortcut(QKeySequence(Qt::ALT + Qt::Key_Semicolon), this, SLOT(printFocusItem()));

    optimizeGraphicsViewAttributes(settings, this);
    setResizeMode(QDeclarativeView::SizeRootObjectToView);

    if (settings->isEnabled(GlobalSettings::OpenGLUsage)) {
#ifdef GLVIEWPORT
        if (settings->isEnabled(GlobalSettings::OpenGLViewport)) {
            QGLWidget *viewport = new QGLWidget();
            if (settings->isEnabled(GlobalSettings::OverlayMode)) {
                viewport->setAttribute(Qt::WA_TranslucentBackground);
            }
            viewport->qglClearColor(Qt::transparent);
            setViewport(viewport);
        }
#endif //GLVIEWPORT
        setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    } else {
        viewport()->setAutoFillBackground(false);
        setViewportUpdateMode(QGraphicsView::BoundingRectViewportUpdate);
    }
    viewport()->setAttribute(Qt::WA_OpaquePaintEvent);

    m_drivenFPS = m_settings->value(GlobalSettings::DrivenFPS).toBool();
    m_overlayMode = m_settings->value(GlobalSettings::OverlayMode).toBool();

    startTimer(1000);
    connect(this, SIGNAL(statusChanged(QDeclarativeView::Status)), this, SLOT(handleStatusChanged(QDeclarativeView::Status)));
}

void DeclarativeView::setSource(const QUrl &url)
{
    m_url = url;
    QMetaObject::invokeMethod(this, "handleSourceChanged", Qt::QueuedConnection);
}

void DeclarativeView::setupViewport(QWidget *widget)
{
#ifdef GL
    m_glViewport = qobject_cast<QGLWidget*>(widget);
#else
    m_glViewport = false;
#endif
}

void DeclarativeView::paintEvent(QPaintEvent *event)
{
    if (!m_glViewport && m_overlayMode) {
        QPainter painter(viewport());
        painter.fillRect(event->rect(), Qt::transparent);
    }
    ++m_frameCount;

    if (m_drivenFPS) {
        QDeclarativeView::paintEvent(event);
        //Force the frog march
        viewport()->update();
    } else {
        m_frameTimer.restart();
        QDeclarativeView::paintEvent(event);
        m_timeSigma += m_frameTimer.elapsed();
    }
}

void DeclarativeView::timerEvent(QTimerEvent *event)
{
    if (!m_drivenFPS && m_timeSigma) {
        m_fps = 1000*m_frameCount/m_timeSigma;
    } else {
        m_fps = m_frameCount;
    }
    m_timeSigma = m_frameCount = 0;
    emit fpsChanged();
    QDeclarativeView::timerEvent(event);
}

void DeclarativeView::handleSourceChanged()
{
    QDeclarativeView::setSource(m_url);
}

void DeclarativeView::handleStatusChanged(QDeclarativeView::Status status)
{
    if (status == QDeclarativeView::Ready) {
        activateWindow();
    }
}

QObject *DeclarativeView::focusItem() const
{
    return qgraphicsitem_cast<QGraphicsObject *>(scene()->focusItem());
}

int DeclarativeView::fps() const
{
    return m_fps;
}

void DeclarativeView::addImportPath(const QString &path)
{
    engine()->addImportPath(path);
}

