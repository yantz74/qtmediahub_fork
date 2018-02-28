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

#ifndef HTTPCLIENT_P_H
#define HTTPCLIENT_P_H

#include <QObject>
#include <QtNetwork>

class HttpServer;
class SkinManager;

class HttpClientPrivate : public QObject
{
    Q_OBJECT

public:

#ifdef QT5
    explicit HttpClientPrivate(qintptr sockfd, HttpServer *server, SkinManager* skinManager, QObject *parent = 0);
#else
    explicit HttpClientPrivate(int     sockfd, HttpServer *server, SkinManager* skinManager, QObject *parent = 0);
#endif



signals:
    void error(QTcpSocket::SocketError socketError);
    void disconnected();

private slots:
    void readClient();

private:
    void readMediaRequest(const QString& get);
    void readQmlRequest(const QString& get);
    void printRequestFormatErrorMessage(const QString& get);

    QUrl getMediaUrl(QString mediaType, int id, QString field = "uri");
    bool sendFile(QString fileName);
    bool sendPartial(QString fileName, qint64 offset);

    void answerOk(qint64 length);
    void answerNotFound();

#ifdef QT5
    qintptr m_sockfd;
#else
    int m_sockfd;
#endif
    HttpServer *m_server;
    SkinManager *m_skinManager;

    QTcpSocket *m_socket;
    QFile m_file;
    QHash<QString, QString> m_request;
};

#endif // HTTPCLIENT_H
