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

#include "skin.h"
#include "libraryinfo.h"
#include "jsonparser/json.h"

#include <QtGui>
#include <QtDebug>

Skin::Skin(QObject *parent)
    : QObject(parent),
      m_settings(new Settings(this))
{
}

Skin::~Skin()
{
    m_settings->save();
}

const QString &Skin::name() const
{
    return m_name;
}

const QString &Skin::path() const
{
    return m_path;
}

const QString &Skin::config() const
{
    return m_config;
}

const QString &Skin::version() const
{
    return m_version;
}

const QString & Skin::screenshot() const
{
    return m_screenshot;
}

const QString & Skin::website() const
{
    return m_website;
}

const QVariantMap &Skin::authors() const
{
    return m_authors;
}

const QVariantMap &Skin::resolutions() const
{
    return m_resolutions;
}

Settings *Skin::settings() const
{
    return m_settings;
}


Skin *Skin::createSkin(const QString &skinPath, QObject *parent)
{
    QString mapFile = skinPath + "/skin.manifest";
    if (!QFile(mapFile).exists())
        return 0;

    Skin *skin = new Skin(parent);
    QFileInfo fileInfo(skinPath);
    skin->m_name = fileInfo.fileName();
    skin->m_path = skinPath; // fileInfo.canonicalFilePath() doesn't work for qar files
    skin->m_config = mapFile;

    return skin;
}

QUrl Skin::urlForResolution(const QSize &preferredSize) const
{
    const QString resolutionString = QString("%1x%2").arg(preferredSize.width()).arg(preferredSize.height());

    foreach (const QString &name, m_resolutions.keys()) {
        if (name == resolutionString) {
            return QUrl::fromLocalFile(m_path % "/" % m_resolutions.value(name).toMap()["file"].toString());
        }
    }

    const QString defaultResolutionString = m_resolutions.value(m_defaultResolution).toMap()["file"].toString();
    return QUrl::fromLocalFile(m_path % "/" % defaultResolutionString);
}

bool Skin::isRemoteControl() const
{
    return m_name.contains("remote"); // ## obviously bad
}

Skin::Type Skin::type(const QUrl &url) const
{
    if (url.path().right(3) == "qml") {
        return Qml;
    }
    return Invalid;
}

bool Skin::parseManifest()
{
    QFile skinConfig(m_config);
    if (!skinConfig.open(QIODevice::ReadOnly)) {
        qWarning() << "Can't read " << m_config << " of skin " << m_name;
        return false;
    }

    JsonReader reader;
    if (!reader.parse(skinConfig.readAll())) {
        qWarning() << "Failed to parse config file " << m_config << reader.errorString();
        return false;
    }

    const QVariantMap root = reader.result().toMap();

    m_version = root["version"].toString();
    if (m_version.isEmpty())
        qWarning() << "Skin has no version";

    m_defaultResolution = root["default_resolution"].toString();
    if (m_defaultResolution.isEmpty())
        qWarning() << "Skin has no default resolution";

    m_resolutions = root["resolutions"].toMap();
    if (m_resolutions.isEmpty())
        qWarning() << "Skin does not declare any supported resolutions";

    m_screenshot = root["screenshot"].toString();
    if (m_screenshot.isEmpty())
        qWarning() << "Skin does not have any screenshot";

    m_website = root["website"].toString();
    if (m_website.isEmpty())
        qWarning() << "Skin does not have any website";

    // load default settings
    const QVariantList settings = root["settings"].toList();
    foreach (const QVariant &s, settings) {
        const QVariantMap entry = s.toMap();
        m_settings->addOptionEntry(entry.value("name").toString(), entry.value("default_value").toString(), entry.value("doc").toString());
    }
    const QString configFilePath = QFileInfo(QSettings().fileName()).absolutePath() + QLatin1String("/") + name() + QLatin1String(".conf");
    m_settings->loadConfigFile(configFilePath);
    m_settings->parseArguments(qApp->arguments());

    return true;
}


