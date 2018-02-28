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

#include "lastfmprovider.h"

#include <QSqlError>

#define DEBUG if (0) qDebug() << __PRETTY_FUNCTION__

LastFMProvider::LastFMProvider(QSqlDatabase db, QObject *parent) :
    QObject(parent),
    m_reply(0),
    m_db(db)
{
    m_networkAccessManager = new QNetworkAccessManager(this);

    m_query = new QSqlQuery(m_db);
    m_query->setForwardOnly(true);
    m_query->exec("SELECT id, artist, title, album, track FROM music WHERE thumbnail IS NULL");

    connect(this, SIGNAL(replyFinished()), this, SLOT(requestNext()));
    emit replyFinished();
}

void LastFMProvider::handleTitleReply()
{
    DEBUG << "handle TITLE reply";

    QXmlStreamReader reader(m_reply);

    bool trackTagFound = false;
    bool albumTagFound = false;
    bool albumTitleTagFound = false;

    while (reader.readNext() && !reader.isEndDocument()) {
        if (reader.isStartElement() && reader.name() == "track") {
            trackTagFound = true;
        }

        if (trackTagFound && reader.isStartElement() && reader.name() == "album") {
            albumTagFound = true;
            m_currentTrack = reader.attributes().value("position").toString().toInt();
        }

        if (albumTagFound && !albumTitleTagFound && reader.isStartElement() && reader.name() == "title") {
            albumTitleTagFound = true;
            if (reader.readNext() && reader.isCharacters())
                m_currentAlbum = reader.text().toString();
        }

        if (albumTagFound && reader.isStartElement() && reader.name() == "image" && reader.attributes().value("size") == "large") {
            if (reader.readNext() && reader.isCharacters())
                m_currentThumbnail = reader.text().toString();
        }
    }

    m_reply->deleteLater();
    m_reply = 0;

    // if thumbnail still empty try to get artist info
    if (m_currentThumbnail.isEmpty()) {
        requestArtistInformation();
    } else {
        updateDatabase();
        emit replyFinished();
    }
}

void LastFMProvider::handleArtistReply()
{
    DEBUG << "handle ARTIST reply";

    QXmlStreamReader reader(m_reply);

    bool artistTagFound = false;

    while (reader.readNext() && !reader.isEndDocument()) {
        if (reader.name() == "artist") {
            artistTagFound = true;
        }

        if (artistTagFound && reader.name() == "image" && reader.attributes().value("size") == "large") {
            if (reader.readNext() && reader.isCharacters())
                m_currentThumbnail = reader.text().toString();
            break;
        }
    }

    DEBUG << "artist query result" << m_currentThumbnail;

    updateDatabase();

    m_reply->deleteLater();
    m_reply = 0;

    emit replyFinished();
}

void LastFMProvider::requestNext()
{
    if (m_query->next()) {
        m_currentId = m_query->value(0).toString();
        m_currentArtist = m_query->value(1).toString();
        m_currentTitle = m_query->value(2).toString();
        m_currentAlbum = m_query->value(3).toString();
        m_currentTrack = m_query->value(4).toInt();

        DEBUG << "empty thumbnail for" << m_currentId << m_currentArtist << m_currentTitle;

        // first try to get full title information
        requestTitleInformation();
    } else {
        emit allRequestsFinished();
    }
}

void LastFMProvider::handleError(QNetworkReply::NetworkError code)
{
    DEBUG << "cannot fetch lastFM data" << code << m_reply->errorString();

    m_reply->deleteLater();
    m_reply = 0;

    emit replyFinished();
}

void LastFMProvider::updateDatabase()
{
    DEBUG << "metadata from lastfm:" << m_currentId << m_currentAlbum << m_currentTrack << m_currentThumbnail;

    QSqlQuery query(m_db);
    if (!query.prepare("UPDATE music SET thumbnail=:thumbnail WHERE id=:id")) {
        qWarning() << query.lastError().text();
    }

    query.bindValue(":thumbnail", m_currentThumbnail);
    query.bindValue(":id", m_currentId);

    if (!query.exec())
        qWarning() << query.lastError().text();
}

void LastFMProvider::requestTitleInformation()
{
    static const QString apiUri = QString::fromLatin1("http://ws.audioscrobbler.com/2.0/?method=track.getinfo&api_key=e7e3601ddce49a72b56c758d29af4a3f&");
    QString requestString = apiUri + "artist=" + m_currentArtist + "&track=" + m_currentTitle;

    DEBUG << "TITLE query" << requestString;

    // execute request to lastFM
    m_reply = m_networkAccessManager->get(QNetworkRequest(QUrl(requestString)));
    connect(m_reply, SIGNAL(readyRead()), this, SLOT(handleTitleReply()));
    connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(handleError(QNetworkReply::NetworkError)));
}

void LastFMProvider::requestArtistInformation()
{
    static const QString apiUri = QString::fromLatin1("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&api_key=e7e3601ddce49a72b56c758d29af4a3f&");
    QString requestString = apiUri + "artist=" + m_currentArtist;

    DEBUG << "ARTIST query" << requestString;

    // execute request to lastFM
    m_reply = m_networkAccessManager->get(QNetworkRequest(QUrl(requestString)));
    connect(m_reply, SIGNAL(readyRead()), this, SLOT(handleArtistReply()));
    connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(handleError(QNetworkReply::NetworkError)));
}
