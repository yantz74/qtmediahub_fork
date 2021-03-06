/****************************************************************************

This file is part of the QtMediaHub project on http://www.qtmediahub.com

Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Girish Ramakrishnan girish@forwardbias.in
Contact:  Nokia Corporation donald.carr@nokia.com
Contact:  Nokia Corporation johannes.zellner@nokia.com

You may use this file under the terms of the BSD license as follows:

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

****************************************************************************/

#ifndef DROPBOXSESSION_H
#define DROPBOXSESSION_H

#include <QNetworkRequest>
#include <QString>
#include <QDateTime>
#include <QStringList>
#include <QFile>

class QNetworkAccessManager;
class QNetworkReply;

class DbSession : public QObject
{
    Q_OBJECT

    enum State {
        RequestToken,
        AccessToken,
        ListDirectory,
        GetFile,
        Done
    };

public:
    static DbSession &getInstance();

private slots:
    void finished(QNetworkReply *networkReply);
    void readyRead();

signals:
    void newAuthUrl(const QString &url);
    void newFileIndex();
    void newState();

private:
    DbSession();
    ~DbSession();

    void requestToken();
    void sync();
    void setRawHeader();
    void downloadNext();

    static DbSession      *instance;

    QNetworkAccessManager *networkAccessmanager;
    QNetworkRequest        networkRequest;
    QNetworkReply         *networkReply;
    const QString          app_key;
    const QString          app_secret;
    QString                token;
    QString                secret;
    QStringList            files;
    int                    fileIndex;
    QString                localPath;
    QFile                  localFile;
    enum State             state;

    friend class Dropbox;
};

#endif //DROPBOXSESSION_H
