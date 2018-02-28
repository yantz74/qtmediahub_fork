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

#ifndef CUSTOMCURSOR_H
#define CUSTOMCURSOR_H

#include <QObject>
#include <QCursor>
#include <QTimer>

class GlobalSettings;

class CustomCursor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString defaultCursorPath READ defaultCursorPath WRITE setDefaultCursorPath)
    Q_PROPERTY(QString clickedCursorPath READ clickedCursorPath WRITE setClickedCursorPath)

public:
    enum Behavior { Default, Clicked, Blank, BehaviorCount };

    explicit CustomCursor(GlobalSettings *settings, QObject *parent = 0);

    Q_INVOKABLE void enableCursor(bool enable = true, bool temporary = true);
    Q_INVOKABLE void moveBy(int dx, int dy);

    QString defaultCursorPath() const;
    void setDefaultCursorPath(const QString &path);

    QString clickedCursorPath() const;
    void setClickedCursorPath(const QString &path);

    void setCursor(Behavior current);

    bool eventFilter(QObject *obj, QEvent *event);

public slots:
    void handleClickedTimeout();
    void handleIdleTimeout();

private:
    QTimer *m_timer;
    QTimer *m_clickedTimer;

    Behavior m_currentBehavior;

    QString m_defaultCursorPath;
    QString m_clickedCursorPath;
    QCursor m_defaultCursor;
    QCursor m_clickedCursor;
    QCursor m_blankCursor;

    QObject *m_eventSink;
    GlobalSettings *m_settings;
};

#endif // CUSTOMCURSOR_H
