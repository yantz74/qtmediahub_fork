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

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QString>
#include <QUrl>
#include <QDateTime>
#include <QStringList>
#include <QFile>
#include <QFileInfo>
#include <QSettings>
#include <QDir>
#include <QDebug>
#include "json.h"
#include "dropboxsession.h"


DbSession* DbSession::instance = 0;

DbSession &DbSession::getInstance()
{
    if (!instance)
        instance = new DbSession();
    return *instance;
}

DbSession::DbSession()
    : QObject(), app_key("utju04c6jckb0in"), app_secret("8z6nux9px2xhzy8"), state(RequestToken)
{
    const QLatin1String key("localPath");
    QSettings settings("MediaTrolls", "dropbox");
    localPath = settings.value(key).toString();
    if (localPath.isEmpty()) {
        localPath = QDir::homePath() + "/drop-qmh";
        settings.setValue(key, localPath);
    }

    QDir dir(localPath);
    if (!dir.exists())
        dir.mkpath(localPath);

    qsrand(QDateTime::currentDateTime().toTime_t());

    networkAccessmanager = new QNetworkAccessManager(this);
    connect(networkAccessmanager, SIGNAL(finished(QNetworkReply*)), this, SLOT(finished(QNetworkReply*)));

    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/octet-stream");
}

DbSession::~DbSession()
{
    //qDebug() << "~Destructing DbSession";
}

void DbSession::requestToken()
{
    setRawHeader();
    networkRequest.setUrl(QUrl("https://api.dropbox.com/1/oauth/request_token"));
    state = RequestToken;
    networkAccessmanager->post(networkRequest, static_cast<QIODevice*>(0));
}

void DbSession::sync()
{
    setRawHeader();
    networkRequest.setUrl(QUrl("https://api.dropbox.com/1/oauth/access_token"));
    state = AccessToken;
    //emit newState();
    networkAccessmanager->post(networkRequest, static_cast<QIODevice*>(0));
}

void DbSession::setRawHeader()
{
    QString header = QString("OAuth realm=\"\", oauth_timestamp=\"%1\""
                             ", oauth_nonce=\"%2\""
                             ", oauth_consumer_key=\"%3\""
                             ", oauth_signature_method=\"PLAINTEXT\""
                             ", oauth_version=\"1.0\"")
                             .arg(QDateTime::currentDateTime().toUTC().toTime_t())
                             .arg(qrand())
                             .arg(app_key);

    if(token.isEmpty()) {
        header += QString(", oauth_signature=\"%4\%26\"").arg(app_secret);
    } else {
        header += QString(", oauth_token=\"%4\", oauth_signature=\"%5\%26\%6\"")
                                    .arg(token).arg(app_secret).arg(secret);
    }
    networkRequest.setRawHeader("Authorization", header.toUtf8());
}

void DbSession::finished(QNetworkReply *reply)
{
    if(!reply->error()) {
        switch(state) {
        case RequestToken: {
            QList<QByteArray> content = reply->readAll().split('&');
            secret = content.at(0).split('=').at(1);
            token = content.at(1).split('=').at(1);
            //qDebug() << "~Reply (RequestToken)------>";
            //qDebug() << "~url:" << reply->url();
            //qDebug() << "~token:" << token << "secret:" << secret;
            QString userUrl = "https://www.dropbox.com/1/oauth/authorize?oauth_token=" + token;
            //qDebug() << "~Authorize here:" << userUrl;
            emit newAuthUrl(userUrl);
            break;
        }

        case AccessToken: {
            QList<QByteArray> content = reply->readAll().split('&');
            secret = content.at(0).split('=').at(1);
            token = content.at(1).split('=').at(1);
            //qDebug() << "~Reply (AccessToken)------>";
            //qDebug() << "~url:" << reply->url();
            //qDebug() << "~content:" << reply->readAll();
            //qDebug() << "~token:" << token << "secret:" << secret;

            setRawHeader();
            networkRequest.setUrl(QUrl("https://api.dropbox.com/1/metadata/sandbox"));
            state = ListDirectory;
            networkAccessmanager->get(networkRequest);
            break;
        }

        case ListDirectory: {
            //qDebug() << "~Reply (ListDirectory)------>";
            //qDebug() << "~url:" << reply->url();

            JsonReader reader;
            if (reader.parse(reply->readAll())) {
                QVariantList list = reader.result().toMap()["contents"].toList();
                for(int i = 0; i < list.size(); ++i) {
                    QVariantMap map = list[i].toMap();
                    if (map["is_dir"].toString() == "false")
                        files.append(map["path"].toString());
                }
                //qDebug() << files;
            } else {
                //qDebug() << reader.errorString();
            }

            state = GetFile;
            emit newState();
            fileIndex = 0;
            downloadNext();
            break;
        }

        case GetFile:
            //qDebug() << "~Reply (GetFile)------>";
            //qDebug() << "~url:" << reply->url();
            //qDebug() << "~content:" << reply->readAll();
            downloadNext();
            break;

        default: ;
        }
    } else {
        qWarning("Netwrok reply error!");
        qDebug() << "url:" << reply->url();
        qDebug() << "error:" << reply->errorString() << reply->errorString();
    }
}

void DbSession::downloadNext()
{
    if (localFile.isOpen())
        localFile.close();

    if (fileIndex == files.size()) {
        state = Done;
        emit newState();
        return;
    }

    while (fileIndex < files.size()) {
        QString file = files.at(fileIndex);
        fileIndex++;
        emit newFileIndex();
        QString localFileName(localPath);
        localFileName.append(file);
        QFileInfo info(localFileName);
        if (!info.exists()) {
            networkRequest.setUrl(QString("https://api-content.dropbox.com/1/files/sandbox").append(file));
            networkReply = networkAccessmanager->get(networkRequest);
            connect(networkReply, SIGNAL(readyRead()), this, SLOT(readyRead()));
            localFile.setFileName(localFileName);
            localFile.open(QFile::WriteOnly);
            break;
        } else {
            if (fileIndex == files.size()) {
                state = Done;
                emit newState();
            }
        }
    }
}

void DbSession::readyRead()
{
    //qDebug() << "****ReadyRead****";
    //qDebug() << "content:" << networkReply->readAll();
    if (localFile.isOpen())
        localFile.write(networkReply->readAll());
}
