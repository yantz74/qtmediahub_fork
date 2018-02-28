/*
 * RemoteDisplay QML plugin
 * Copyright (C) 2011 Nokia Corporation
 *
 * This file is part of the RemoteDisplay QML plugin.
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at
 * your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library;  If not, see <http://www.gnu.org/licenses/>.
 */

#include "remotedisplayplugin.h"
#include "remotedisplay.h"

void RemoteDisplayPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<RemoteDisplay>(uri, 1, 0, "RemoteDisplay");
}

Q_EXPORT_PLUGIN2(remotedisplayplugin, RemoteDisplayPlugin);

