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

#ifndef DECLARATIVEVIEW_H
#define DECLARATIVEVIEW_H

#include <QElapsedTimer>

#ifdef QT5
#include <QQuickView>
#else
#include <QDeclarativeView>
#endif

#include <QDebug>

class GlobalSettings;

#ifdef QT5
class DeclarativeView : public QQuickView
#else
class DeclarativeView : public QDeclarativeView
#endif
{
    Q_OBJECT
    Q_PROPERTY(int fps READ fps NOTIFY fpsChanged)

public:
#ifdef QT5
    DeclarativeView(GlobalSettings *settings, QWindow *parent = 0);
#else
    DeclarativeView(GlobalSettings *settings, QWidget *parent = 0);
#endif
    void setSource(const QUrl &url);

    Q_INVOKABLE QObject *focusItem() const;

    Q_INVOKABLE void addImportPath(const QString &path);

    int fps() const;

#ifndef QT5
protected:
    void timerEvent(QTimerEvent *event);
    void paintEvent(QPaintEvent *event);

protected slots:
    void setupViewport(QWidget *viewport);
#endif

public slots:
    void handleSourceChanged();
    void printFocusItem() { qDebug() << "Focus is held by:" << focusItem(); }
#ifdef QT5
    void handleStatusChanged(QQuickView::Status status);
#else
    void handleStatusChanged(QDeclarativeView::Status status);
#endif

signals:
    void fpsChanged();

private:
    GlobalSettings *m_settings;
    bool m_drivenFPS;
    bool m_overlayMode;
    bool m_glViewport;
    int m_frameCount;
    int m_timeSigma;
    int m_fps;
    QElapsedTimer m_frameTimer;
    QUrl m_url;
};

#endif // DECLARATIVEVIEW_H

