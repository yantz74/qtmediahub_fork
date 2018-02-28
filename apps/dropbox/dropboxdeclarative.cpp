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

#include "dropboxdeclarative.h"
#include "dropboxsession.h"
//#include <QThread>
#include <QDebug>

Dropbox::Dropbox(QObject *parent)
    : QObject(parent), m_session(DbSession::getInstance())
{
//    QThread *thread = new QThread;
//    thread->start();
//    m_session.moveToThread(thread);

    connect(&m_session, SIGNAL(newAuthUrl(const QString&)), this, SLOT(updateAuthUrl(const QString&)));
    connect(&m_session, SIGNAL(newFileIndex()), this, SIGNAL(fileProgressChanged()));
    connect(&m_session, SIGNAL(newState()), this, SIGNAL(statusChanged()));

    if (m_session.state == DbSession::RequestToken || m_session.state == DbSession::Done)
        m_session.requestToken();
}

Dropbox::~Dropbox()
{
    //qDebug() << "~Desctructing Dropbox";
}

QString Dropbox::authUrl()
{
    return m_authUrl;
}

Dropbox::Status Dropbox::status()
{
    Status status;
    switch (m_session.state) {
        case DbSession::RequestToken: status = Dropbox::Idle; break;
        case DbSession::Done: status = Dropbox::Done; break;
        default: status = Dropbox::Synchronizing;
    }
//    status = Dropbox::Synchronizing;
    return status;
}

void Dropbox::sync()
{
    if (m_session.state == DbSession::RequestToken)
        m_session.sync();
}

void Dropbox::updateAuthUrl(const QString &url)
{
    m_authUrl = url;
    emit authUrlChanged();
}

int Dropbox::fileProgress()
{
    return m_session.fileIndex;
}
