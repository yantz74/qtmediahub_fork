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

#ifndef SKIN_H
#define SKIN_H

#include <QObject>
#include <QMetaType>
#include <QUrl>

#include "global.h"
#include "globalsettings.h"

class QMH_EXPORT Skin : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString path READ path CONSTANT)
    Q_PROPERTY(QString config READ config CONSTANT)
    Q_PROPERTY(QString version READ version CONSTANT)
    Q_PROPERTY(QString screenshot READ screenshot CONSTANT)
    Q_PROPERTY(QString website READ website CONSTANT)
    Q_PROPERTY(QVariantMap authors READ authors CONSTANT)
    Q_PROPERTY(QVariantMap resolutions READ resolutions CONSTANT)
    Q_PROPERTY(Settings *settings READ settings CONSTANT)

public:
    enum Type { Invalid, Qml };
    static Skin *createSkin(const QString &skinPath, QObject *parent);
    ~Skin();

    // call before call any getters
    bool parseManifest();

    const QString &name() const;
    const QString &path() const;
    const QString &config() const;
    const QString &version() const;
    const QString &screenshot() const;
    const QString &website() const;
    const QVariantMap &authors() const;
    const QVariantMap &resolutions() const;

    Settings *settings() const;
    Type type(const QUrl &url) const; // ## remove the url argument
    bool isRemoteControl() const;
    QUrl urlForResolution(const QSize &preferredSize) const;

private:
    explicit Skin(QObject *parent = 0);


    QString m_path;
    QString m_name;
    QString m_config;
    QString m_version;
    QString m_screenshot;
    QString m_website;
    QVariantMap m_authors;
    QVariantMap m_resolutions;
    QString m_defaultResolution;
    Settings *m_settings;
};

Q_DECLARE_METATYPE(Skin *)

#endif // SKIN_H
