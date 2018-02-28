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

#include "mediaparser.h"
#include "scopedtransaction.h"
#include "globalsettings.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#define DEBUG if (0) qDebug() << __PRETTY_FUNCTION__
#define WARNING qDebug() << __PRETTY_FUNCTION__

MediaParser::MediaParser(GlobalSettings *settings, QObject *parent) :
    QObject(parent),
    m_settings(settings)
{
}

QHash<QString, MediaScanner::FileInfo> MediaParser::topLevelFilesInPath(const QString &path, QSqlDatabase db)
{
    QHash<QString, MediaScanner::FileInfo> hash;
    QSqlQuery query(db);
    query.setForwardOnly(true);
    query.prepare(QString("SELECT id, filepath, mtime, ctime, filesize FROM %1 WHERE directory=:path").arg(type()));
    query.bindValue(":path", path);
    if (!query.exec()) {
        WARNING << query.lastError().text();
        return hash;
    }

    while (query.next()) {
        MediaScanner::FileInfo fi;
        fi.rowid = query.value(0).toLongLong();
        fi.name = query.value(1).toString();
        fi.mtime = query.value(2).toLongLong();
        fi.ctime = query.value(3).toLongLong();
        fi.size = query.value(4).toLongLong();

        hash.insert(fi.name, fi);
    }

    return hash;
}

QSet<qint64> MediaParser::fileIdsInPath(const QString &path, QSqlDatabase db)
{
    QSet<qint64> rowids;
    QSqlQuery query(db);
    query.setForwardOnly(true);
    query.prepare(QString("SELECT id FROM %1 WHERE filepath LIKE :path").arg(type()));
    query.bindValue(":path", path + "%");
    if (!query.exec()) {
        WARNING << "ops" << query.lastError().text();
        return rowids;
    }

    while (query.next()) {
        rowids.insert(query.value(0).toInt());
    }
    return rowids;
}

void MediaParser::removeFiles(const QSet<qint64> &ids, QSqlDatabase db)
{
    bool startedTransaction = db.transaction();
    QSqlQuery query(db);
    query.prepare(QString("DELETE FROM %1 WHERE id=:id").arg(type()));

    for (QSet<qint64>::const_iterator it = ids.constBegin(); it != ids.constEnd(); ++it) {
        query.bindValue(":id", *it);
        if (!query.exec()) {
            WARNING << query.lastError().text();
        }
    }
    if (startedTransaction) {
        db.commit();
    }
}

