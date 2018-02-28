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

#ifndef MEDIAPLAYERRPC_H
#define MEDIAPLAYERRPC_H

#include <QObject>

class MediaPlayerRpc : public QObject
{
    Q_OBJECT
public:
    explicit MediaPlayerRpc(QObject *parent = 0);

signals:
    Q_SCRIPTABLE void stopRequested();
    Q_SCRIPTABLE void pauseRequested();
    Q_SCRIPTABLE void resumeRequested();
    Q_SCRIPTABLE void togglePlayPauseRequested();
    Q_SCRIPTABLE void nextRequested();
    Q_SCRIPTABLE void previousRequested();
    Q_SCRIPTABLE void volumeUpRequested();
    Q_SCRIPTABLE void volumeDownRequested();

    Q_SCRIPTABLE void playRemoteSourceRequested(const QString &uri, qlonglong position);

public slots:
    Q_SCRIPTABLE void playRemoteSource(const QString &uri, qlonglong position);
    Q_SCRIPTABLE void stop() { emit stopRequested(); }
    Q_SCRIPTABLE void pause() { emit pauseRequested(); }
    Q_SCRIPTABLE void resume() { emit resumeRequested(); }
    Q_SCRIPTABLE void togglePlayPause() { emit togglePlayPauseRequested(); }
    Q_SCRIPTABLE void next() { emit nextRequested(); }
    Q_SCRIPTABLE void previous() { emit previousRequested(); }
    Q_SCRIPTABLE void volumeUp() { emit volumeUpRequested(); }
    Q_SCRIPTABLE void volumeDown() { emit volumeDownRequested(); }
};

#endif // MEDIAPLAYERRPC_H
