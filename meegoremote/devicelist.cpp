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

#include "devicelist.h"

#include <QStringList>

DeviceList::DeviceList(QObject *parent) :
    QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles = roleNames();
    roles.insert(Qt::UserRole+1, "name");
    roles.insert(Qt::UserRole+2, "ip");
    setRoleNames(roles);

    loadSettings();
}

void DeviceList::addDevice(const QString &name, const QString &ip)
{
    emit beginResetModel();
    m_devices.insert(name, ip);
    emit endResetModel();
    m_settings.setValue("Devices/"+name, ip);
    m_settings.sync();
}

void DeviceList::updateDevice(int idx, const QString &name, const QString &ip)
{
    emit beginRemoveRows(QModelIndex(), idx, idx);
    m_devices.remove(m_devices.keys().at(idx));
    emit endRemoveRows();
    addDevice(name, ip);
}

QVariant DeviceList::data(const QModelIndex &index, int role) const
{
    if (role == Qt::DisplayRole || role == Qt::UserRole+1) {
        return m_devices.keys().at(index.row());
    } else if (role == Qt::UserRole+2) {
        return m_devices.value(m_devices.keys().at(index.row()));
    } else {
        return QVariant();
    }
}

void DeviceList::loadSettings()
{
    m_settings.beginGroup("Devices");

    emit beginInsertRows(QModelIndex(), 0, m_devices.count());
    QStringList keys = m_settings.allKeys();
    foreach (QString key, keys) {
        m_devices.insert(key, m_settings.value(key, "").toString());
    }
    emit endInsertRows();

    m_settings.endGroup();
}

void DeviceList::removeDevice(const QString &name)
{
    emit beginRemoveRows(QModelIndex(), 0, m_devices.count());
    m_devices.remove(name);
    emit endRemoveRows();

    m_settings.remove("Devices/"+name);
    m_settings.sync();
}

void DeviceList::clear()
{
    emit beginRemoveRows(QModelIndex(), 0, m_devices.count());
    m_devices.clear();
    emit endRemoveRows();
    m_settings.remove("Devices");
}
