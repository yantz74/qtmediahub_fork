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

#include "contextcontentrpc.h"
#include "rpcconnection.h"

#include <QDebug>

ContextContentRpc::ContextContentRpc(QObject *parent) :
    QObject(parent),
    m_connection(0)
{
    setObjectName("contextContent");
}

void ContextContentRpc::newContextContent(QString skinName, QString contentName, QList<QVariant> vList)
{
    if(m_connection) {
        m_contextUrl = "http://" + m_peerName + ":1337/qml/" + skinName + "/" + contentName;

        m_idList.clear();
        for(int i = 0; i < vList.length(); i++) {
            bool ok;
            m_idList.append(vList[i].toInt(&ok));
            if(!ok) {
                qWarning() << "void ContextContentRpc::newContextContent(QString skinName, QString contentName, QList<QVariant> vList)" <<
                              " got vList containing a non-int QVariant.";
                return;
            }
        }

        emit contextUrlChanged();
        emit remoteModelChanged();
    }
}

void ContextContentRpc::invalidateContextContent()
{
    if(!m_contextUrl.isEmpty()) {
        m_contextUrl = "";
        emit contextUrlChanged();
    }
}


void ContextContentRpc::setConnection(RpcConnection *connection)
{
    m_connection = connection;
    m_connection->registerObject(this);
    connect(m_connection, SIGNAL(clientConnected()),    this, SLOT(clientConnected()));
    connect(m_connection, SIGNAL(clientDisconnected()), this, SLOT(clientDisconnected()));

}

void ContextContentRpc::clientConnected()
{
    invalidateContextContent();
    if(m_peerName != m_connection->peerName()) {
        m_peerName = m_connection->peerName();
        emit peerNameChanged();
    }
}

void ContextContentRpc::clientDisconnected()
{
    invalidateContextContent();
    if(!m_peerName.isEmpty()) {
        m_peerName = "";
        emit peerNameChanged();
    }
}
