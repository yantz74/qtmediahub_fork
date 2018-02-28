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

#include "dbreader.h"

#define DEBUG if (0) qDebug() << __PRETTY_FUNCTION__

DbReader::DbReader(QObject *parent)
    : QObject(parent), m_stop(false)
{
    qRegisterMetaType<QList<QSqlRecord> >();
    qRegisterMetaType<QSqlDatabase>();
    qRegisterMetaType<QSqlQuery>();
    qRegisterMetaType<DbReader *>();
    qRegisterMetaType<void *>();
}

DbReader::~DbReader()
{
    m_db = QSqlDatabase();
    QSqlDatabase::removeDatabase(m_db.connectionName());
}

void DbReader::stop() 
{
    m_stop = true;
}

void DbReader::initialize(const QSqlDatabase &db)
{
    m_db = QSqlDatabase::cloneDatabase(db, QUuid::createUuid().toString());
    if (!m_db.open())
        qFatal("Erorr opening database: %s", qPrintable(m_db.lastError().text()));
}

void DbReader::execute(const QString &q, const QStringList &bindings, void *userData)
{
    QSqlQuery query(m_db);
    query.setForwardOnly(true);
    query.prepare(q);
    foreach(const QString &binding, bindings)
        query.addBindValue(binding);

    if (!query.exec()) {
        qWarning("Error executing query: %s", qPrintable(query.lastQuery()));
        return;
    }

    QList<QSqlRecord> data = readRecords(query);
    DEBUG << "Read " << data.count() << "records";

    if (!m_stop)
        emit dataReady(this, data, userData);
}

QList<QSqlRecord> DbReader::readRecords(QSqlQuery &query)
{
    QList<QSqlRecord> data;
    while (query.next() && !m_stop) {
        data.append(query.record());
    }
    return data;
}

